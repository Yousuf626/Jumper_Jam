extends Control

@onready var topbar = $TopBar
@onready var score_lable = $TopBar/ScoreLable
@onready var topbar_bg = $TopBarBG

signal paused_game
func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top = (safe_area_top/screen_scale)
		
		
		topbar.position.y += safe_area_top
		
		var margin = 10
		topbar_bg.size.y += safe_area_top + margin 
		
		MyUtility.add_log_msg("Safe area : "+str(safe_area))
		MyUtility.add_log_msg("Window Size  : "+str(DisplayServer.window_get_size()))
		MyUtility.add_log_msg("safe_area_top : "+str(safe_area_top))
		MyUtility.add_log_msg("TopBar position : "+str(topbar.position))
func _on_pause_btn_pressed():
	SoundFX.play("Click")
	paused_game.emit()
	#get_tree().paused = !get_tree().paused 

func set_score(new_score):
	#print(new_score)
	score_lable.text = str(new_score)
