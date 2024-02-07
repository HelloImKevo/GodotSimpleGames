class_name Player
extends CharacterBody2D
## Player : Survivor character controlled by the user.


const SPEED: float = 180.0


func _to_string() -> String:
	return "Player"


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	get_input()
	move_and_slide()
	# TODO: Figure out how to retain the last velocity angle based on player
	# input, so the sprite rotation doesn't reset to zero when there's no input.
	rotation = velocity.angle()
	print("velocity: ", velocity, " angle: ", velocity.angle())


func get_input() -> void:
	var new_velocity = Vector2.ZERO
	# Primarily used for joystick movement.
	new_velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	new_velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = new_velocity.normalized() * SPEED
