class_name Player
extends CharacterBody2D
## Player : player.gd
##
## The player-controlled Fox character. Can run and jump.


const RUN_SPEED = 300.0
# Velocity applied in the upward direction (gravitational velocity
# is applied as a downward constant).
const JUMP_VELOCITY = -300.0
const TERMINAL_VELOCITY = 400.0
# Defines an invincibility window (iFrames).
const HURT_TIME: float = 0.3

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
# Default value of 980 (9.8 m/s^2).
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _to_string():
	return "%s@%s" % ["Player_Fox", get_rid()]


func _ready():
	print(_to_string(), " Gravity: %s" % [gravity])


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	_handle_movement_input()

	move_and_slide()


func _handle_movement_input() -> void:
	velocity.x = 0
	
	# Handle directional movement.
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, TERMINAL_VELOCITY)


# Unused. For reference purposes.
func _default_godot_2d_input() -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * RUN_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
