extends CharacterBody2D


class_name Player
signal died

@onready var animator = $AnimationPlayer
@onready var cshape = $CollisionShape2D
var speed = 300.0
var accelerometer_speed = 130.0
var viewport_size
var gravity = 15
var max_fall_gravity= 1000
var jump_velocity = -800
var use_accelerometer = false
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size
	var os_name = OS.get_name()
	if os_name == "Android"|| os_name == "iOS":
		use_accelerometer = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if velocity.y>0:
		if animator.current_animation != "falling":
			animator.play("falling")

	elif velocity.y <0:
		if animator.current_animation != "jump":
			animator.play("jump")

func _physics_process(_delta):
	velocity.y += gravity
	if velocity.y > max_fall_gravity:
		velocity.y = max_fall_gravity
	
	if dead == false:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
			print("Accelerometer: " + str(mobile_input))
		else:
			# this get_axis function return -1 if moveleft , 1 if move right, 0 if nothing or both keys pressed
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * speed
			else:
				#Use a negative delta value to move away.
				velocity.x = move_toward(velocity.x,0,speed)
				
	
	#Returns true if the body collided, otherwise, returns false.
	move_and_slide() #Moves the body based on velocity. If the body collides with another,
	# it will slide along the other body (by default only on floor) rather than stop immediately
	
	var margin = 20
	if  global_position.x > viewport_size.x+margin:
		global_position.x = -margin
		
	if  global_position.x < -margin:
		global_position.x =  viewport_size.x+margin

	
	
func jump():
	velocity.y = jump_velocity
	SoundFX.play("Jump")
	#MyUtility.add_log_msg("Player Jumped")


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
func die():
	if dead == false:
		dead = true
		cshape.set_deferred("disabled",true)
		died.emit()
		SoundFX.play("Fall")
