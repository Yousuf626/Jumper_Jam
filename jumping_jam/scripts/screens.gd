extends CanvasLayer

signal start_game 
signal delete_level

@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen =$GameOverScreen
@onready var console = $Debug/ConsoleLog
@onready var game_over_score_level = $GameOverScreen/Box/ScoreLabel
@onready var game_over_high_score_level = $GameOverScreen/Box/HighScoreLabel


# Called when the node enters the scene tree for the first time.

var current_screen = null
func _ready():
	#print("Console node:", console)
	#print("Is console visible at start:", console.visible)
	console.visible = false
	register_buttons()
	change_screen(title_screen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggle_console_pressed():
	console.visible = !console.visible

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button):
	SoundFX.play("Click")
	match button.name:
		"TitlePlay":
			#print("Play button pressed")
			change_screen(null)
			await (get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"PauseRetry":
			change_screen(null)
			await (get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseClose":
			change_screen(null)
			await (get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
		"PauseBack":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"GameOverBack":
			change_screen(title_screen)
			delete_level.emit()
		"GameOverRetry":
			change_screen(null)
			await (get_tree().create_timer(0.5).timeout)
			start_game.emit()


func change_screen(new_screen):
	if current_screen:
		var disapear_tween = current_screen.disappear()
		#print(disapear_tween)
		await(disapear_tween.finished)
		current_screen.visible = false
	current_screen = new_screen
	if current_screen != null:
		var appear_tween =  current_screen.appear()
		await(appear_tween.finished)
		
		get_tree().call_group("buttons","set_disabled",false)

func game_over(score,highscore):
	game_over_score_level.text = "Score: " + str(score)
	game_over_high_score_level.text = "Best: "+ str(highscore)
	change_screen(game_over_screen)
	
func pause_game():
	change_screen(pause_screen)
