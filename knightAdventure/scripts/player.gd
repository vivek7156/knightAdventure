extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_rolling = false 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")

	# Get the input direction : -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip sprite
	if direction > 0 :
		animated_sprite_2d.flip_h = false
	elif direction < 0 :
		animated_sprite_2d.flip_h = true
	
	#Roll
	if Input.is_action_pressed("roll") and is_on_floor():
		is_rolling=true
	else:
		is_rolling=false	
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif is_rolling:
			animated_sprite_2d.play("roll")
		else:
			animated_sprite_2d.play("run")	
	else:
		animated_sprite_2d.play("jump")			
		
		# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
