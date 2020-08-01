extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 15
const FRICTION = 10

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

var joy_x
var joy_y
var joy_vector

func _physics_process(_delta):
	
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	input_vector = joy_override(input_vector)
	
	if input_vector != Vector2.ZERO:
#		if velocity.length() > 0.8 * MAX_SPEED:
#			velocity = input_vector.normalized() * MAX_SPEED # snappy when fast
#		else:
		velocity += input_vector.clamped(1) * ACCELERATION # sluggish when slow
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	velocity = move_and_slide(velocity)

func joy_override(original_vector):
	joy_x = Input.get_joy_axis(0, 0)
	joy_y = Input.get_joy_axis(0, 1)
	
	joy_vector = Vector2(joy_x, joy_y) 
	if joy_vector.length() < 0.4: # deadzone
		joy_vector = Vector2.ZERO
		
	if joy_vector != Vector2.ZERO:
		return joy_vector

	return original_vector
