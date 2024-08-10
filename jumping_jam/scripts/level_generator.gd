extends Node2D
@onready var platform_parent = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")

# variable for platform levels
var start_platform_y
var y_distance_btw_platform = 100
var platform_num = 10
var viewport_size
var generated_platform_count = 0
var player:Player = null


func setup(_player: Player):
	if _player:
		player = _player
# Called when the node enters the scene tree for the first time.
func _ready():
	
	generated_platform_count = 0
	#Generate Platform
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_distance_btw_platform *2)
	
func start_generation():
	generate_level(start_platform_y,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player:
			var py  = player.global_position.y
			var end_of_level_pos = start_platform_y - (generated_platform_count * y_distance_btw_platform)
			var threshold =  end_of_level_pos + (y_distance_btw_platform * 6)
			
			if py <= threshold:
				generate_level(end_of_level_pos, false)



func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform

func generate_level(start_y: float, generate_ground: bool):
	print("generate_level called")
	viewport_size = get_viewport_rect().size
	var platform_width = 136
	if generate_ground == true:
		
		var platform_count = (viewport_size.x / platform_width ) + 2
		var platform_y_offset = 64
		
		
		for i in range(platform_count):
			var plat_location = Vector2(i * platform_width ,viewport_size.y - platform_y_offset)
			create_platform(plat_location)
	
	
	# generate rest of platform
	for i in range(platform_num):
		var max_x_position = viewport_size.x - platform_width
		var random_x = randf_range(0.0,max_x_position)
		var location: Vector2 = Vector2.ZERO
		location.x = random_x
		location.y = start_y - (y_distance_btw_platform * i)
		
		create_platform(location)
		generated_platform_count +=1
		
	print(generated_platform_count)

func reset_level():
	for platform in platform_parent.get_children():
		platform.queue_free()
func reset_generated_platform_count():
	generated_platform_count = 0
