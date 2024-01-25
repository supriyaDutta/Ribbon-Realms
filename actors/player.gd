extends CharacterBody2D

@export var max_speed = 300
@export var acceleration = 500
@export var speed = 50.0
@export var jump_speed = -250.0
@export var gravity = 300
@export var friction = 500

var chain_velocity = Vector2.ZERO
const chain_pull = 150

func _input(event):
	if event.is_action_pressed("click"):
		var target = get_global_mouse_position()
		$Chain.ribbon_throw(target - global_position)
		print_debug(target)
	elif event.is_action_released("click"):
		$Chain.ribbon_released()
		print_debug("released")



func _physics_process(delta):
	var direction = player_movement(delta)
	


	
	
	move_and_slide()

#func ribbon_movement():
#	pass


func player_movement(delta): #handles jump and left-right movement
	# Gravity.
	velocity.y += gravity * delta 
	# Jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = jump_speed

	# Input direction.
	var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))

	if direction== 0 and is_on_floor():
		apply_friction(friction * delta)
	else:
		apply_movement(direction * acceleration * delta)	
	
	return direction


func apply_friction(amount):
	if velocity.length()>amount:
		velocity -= velocity.normalized() * amount	
	else:
		velocity = Vector2.ZERO

func apply_movement(amount):
	velocity.x += amount
	velocity = velocity.limit_length(max_speed)
