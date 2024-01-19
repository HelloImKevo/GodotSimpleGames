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

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

var _state: PlayerState = PlayerState.IDLE

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer

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
	
	# Interpret player input before process
	_handle_movement_input()
	
	move_and_slide()
	
	# Change state after the physics engine is done processing.
	_calculate_states()
	_update_debug_label()


func _update_debug_label() -> void:
	debug_label.text = "floored=%s state=%s\nvel.x=%.1f vel.y=%.1f" % [
		is_on_floor(),
		PlayerState.keys()[_state],
		velocity.x,
		velocity.y
	]


func _handle_movement_input() -> void:
	velocity.x = 0
	
	# Handle directional movement.
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		SoundManager.play_sfx(sound_player, SoundManager.SOUND_JUMP)
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, TERMINAL_VELOCITY)


func _calculate_states() -> void:
	if _state == PlayerState.HURT:
		# Player cannot be controlled for the brief invulnerable window.
		return
	
	if is_on_floor():
		if velocity.x == 0:
			_set_state(PlayerState.IDLE)
		else:
			_set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			# Player is falling.
			_set_state(PlayerState.FALL)
		else:
			_set_state(PlayerState.JUMP)


func _set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if _did_just_land(new_state):
		SoundManager.play_sfx(sound_player, SoundManager.SOUND_LAND)
	
	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.RUN:
			animation_player.play("run")
		PlayerState.JUMP:
			animation_player.play("jump")
		PlayerState.FALL:
			animation_player.play("fall")
		PlayerState.HURT:
			animation_player.play("hurt")


func _did_just_land(new_state: PlayerState) -> bool:
	if _state == PlayerState.FALL:
		return new_state == PlayerState.IDLE or new_state == PlayerState.RUN
	
	return false


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
