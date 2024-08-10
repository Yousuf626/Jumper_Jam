extends Area2D
class_name  Platform
#we have 2 option 
# option 1 godot build in layer
# option 2 programming
# Load the Player class

# Load the Player class
const player = preload("res://scripts/player.gd")

func _on_body_entered(body):
	if body is player:
		if body.velocity.y > 0:
			body.jump()
			
