extends Node2D
signal player_died(score,highscore)
signal pause_game


@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GameGround
@onready var parallax1 = $ParallaxBackground/ParallaxLayer 
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3
@onready var hud = $UILayer/Hud

var player: Player = null
var player_scene = preload("res://scenes/player.tscn")
var camera_scene = preload("res://scenes/game_camera.tscn")
var viewport_size: Vector2
var player_spawn_pos : Vector2
var score : int  = 0
var highscore: int = 0
var camera = null
var save_file_path = "user://highscore.save"
var game_in_progress = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	hud.set_score(0)
	viewport_size = get_viewport_rect().size
	var player_spawn_pos_y_offset = 135
	player_spawn_pos.x = viewport_size.x / 2.0
	player_spawn_pos.y = viewport_size.y - player_spawn_pos_y_offset
	
	ground_sprite.global_position.x = viewport_size.x /2 
	ground_sprite.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	hud.visible=false
	ground_sprite.visible = false
	hud.paused_game.connect(_on_pause_game)

	load_score()
	#new_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if player:
		if score < viewport_size.y - player.global_position.y:
			score = viewport_size.y - player.global_position.y
			#print(score)
			hud.set_score(score)
func new_game():
	reset_game()
	player = player_scene.instantiate()
	player.global_position = player_spawn_pos
	player.died.connect(_on_player_died)
	add_child(player)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)

	if player:
		level_generator.setup(player)
		print("start generation called from game script")
		level_generator.start_generation()
	
	hud.visible = true
	ground_sprite.visible = true
	score = 0

func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	var scale_size = viewport_size.x / parallax_texture_width
	var result = Vector2(scale_size, scale_size)
	return result

func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if parallax_sprite != null:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		var my = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = my 
		
		#print(parallax_sprite.scale)
		#print(parallax_layer.motion_mirroring.y)


func _on_player_died():
	#print("player died")
	hud.visible = false
	
	if score > highscore:
		highscore = score
		save_score()
	player_died.emit(score,highscore)
	

func reset_game():
	hud.set_score(0)
	hud.visible = false
	ground_sprite.visible = false
	level_generator.reset_level()
	if player:
		player.queue_free()
		player = null
		level_generator.player = null
	if camera:
		camera.queue_free()
		camera.player = null
		camera = null
	level_generator.reset_generated_platform_count()  # Reset generated platform count


func save_score():
	var file = FileAccess.open(save_file_path,FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path,FileAccess.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0


func _on_pause_game():
	pause_game.emit()
