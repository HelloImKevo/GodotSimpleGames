class_name Player
extends CharacterBody2D
## Player : player.gd
##
## The player-controlled Fox character. Can run and jump.


const RUN_SPEED = 250.0
# How far off the bottom of the screen the player can fall before dying.
const FALLEN_OFF: float = 150.0
# Velocity applied in the upward direction (gravitational velocity
# is applied as a downward constant).
const JUMP_VELOCITY = -340.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0.0, -150.0)
const TERMINAL_VELOCITY = 400.0
# Defines an invincibility window (iFrames).
const HURT_TIME: float = 0.3
const ACCELERATION: float = 30.0
# How much the player gets slowed down when hit by an enemy.
const STUN_AMOUNT: float = 150.0

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

var _state: PlayerState = PlayerState.IDLE

@onready var sprite_2d = $Sprite2D
@onready var platform_jump_detection = $PlatformJumpDetection
@onready var animation_player = $AnimationPlayer
@onready var animation_player_invincible = $AnimationPlayerInvincible
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer
@onready var shooter = $Shooter
@onready var invincible_timer = $InvincibleTimer
@onready var hurt_timer = $HurtTimer
@onready var hit_box = $HitBox

# Get the gravity from the project settings to be synced with RigidBody nodes.
# Default value of 980 (9.8 m/s^2).
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hit_points: int = 5
var _invincible: bool = false
var _recently_on_floor: bool = false


func _to_string():
	return "%s@%s" % ["Player_Fox", get_rid()]


func _ready():
	print(_to_string(), " Gravity: %s" % [gravity])
	SignalManager.on_pickup_hit.connect(_on_pickup_hit)


func _physics_process(delta):
	_check_fallen_off()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		_recently_on_floor = true
	
	# Interpret player input before process
	_handle_movement_input()
	_handle_other_input()
	
	move_and_slide()
	
	# Change state after the physics engine is done processing.
	_calculate_states()
	# _update_debug_label()


func _update_debug_label() -> void:
	debug_label.text = "HP=%s invinc=%s\nfloored=%s state=%s\nvel.x=%.1f vel.y=%.1f" % [
		hit_points,
		_invincible,
		is_on_floor(),
		PlayerState.keys()[_state],
		velocity.x,
		velocity.y
	]


func _handle_movement_input() -> void:
	if _state == PlayerState.HURT:
		# Player cannot be controlled for the brief hurt window.
		return
	
	# Handle directional movement.
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACCELERATION, _get_run_speed() * -1)
		sprite_2d.flip_h = true
		if platform_jump_detection.position.x < 0:
			platform_jump_detection.position.x *= -1
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACCELERATION, _get_run_speed())
		sprite_2d.flip_h = false
		if platform_jump_detection.position.x > 0:
			platform_jump_detection.position.x *= -1
	else:
		# Quickly decelerate the player (instead of coming to an abrupt stop).
		# Example values: 150, 90, 54, 32.4, 19.4, 11.6, 7.0, 2.5, 0.54, 0.33
		var linear_interp: float = lerpf(velocity.x, 0.0, 0.4)
		# Once we've slowed down, we need to come to a full stop to trigger
		# the "Idle" animation.
		if abs(linear_interp) < 5.0:
			linear_interp = 0.0
		velocity.x = linear_interp
	
	# Handle jump.
	if (
		Input.is_action_just_pressed("jump")
		and (is_on_floor() or (_recently_on_floor and platform_jump_detection.is_colliding()))
	):
		velocity.y = JUMP_VELOCITY
		SoundManager.play_sfx(sound_player, SoundManager.SOUND_JUMP)
		_recently_on_floor = false
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, TERMINAL_VELOCITY)


func _handle_other_input() -> void:
	if Input.is_action_just_pressed("shoot"):
		_shoot()


func _shoot() -> void:
	var direction: Vector2
	if sprite_2d.flip_h:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	shooter.shoot(direction)


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
			_apply_hurt_jump()


## Determine whether to play the "Land" sound effect.
## Could also be used to reset the number of double jumps.
func _did_just_land(new_state: PlayerState) -> bool:
	if _state == PlayerState.FALL:
		return new_state == PlayerState.IDLE or new_state == PlayerState.RUN
	
	return false


func _check_fallen_off() -> void:
	if global_position.y < FALLEN_OFF:
		return
	
	hit_points = 1
	_set_state(PlayerState.HURT)
	_apply_hit()


func _apply_hit() -> void:
	if _invincible:
		return
	
	hit_points -= 1
	
	SoundManager.play_sfx(sound_player, SoundManager.SOUND_DAMAGE)
	
	if hit_points <= 0:
		EventBus.on_player_hit(0)
		EventBus.on_game_over()
		set_physics_process(false)
		return
	
	_go_invincible()
	_set_state(PlayerState.HURT)


func _apply_hurt_jump() -> void:
	# Stun the player by slowing them down a little bit.
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	EventBus.on_player_hit(hit_points)


func _go_invincible() -> void:
	_invincible = true
	animation_player_invincible.play("invincible")
	invincible_timer.start()


func _get_run_speed() -> float:
	if _invincible:
		return RUN_SPEED - 100.0
	else:
		return RUN_SPEED


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


func _on_pickup_hit(points: int) -> void:
	print(_to_string(), " => _on_pickup_hit : points=%s" % [points])
	SoundManager.play_sfx(sound_player, SoundManager.SOUND_PICKUP)


func _retake_damage() -> void:
	for area in hit_box.get_overlapping_areas():
		if area.is_in_group("Dangers"):
			_apply_hit()
			break
	return


#region: Node Signals

func _on_hit_box_area_entered(area):
	print("Player HitBox: ", area)
	_apply_hit()


func _on_invincible_timer_timeout():
	_invincible = false
	animation_player_invincible.stop()
	_retake_damage()


func _on_hurt_timer_timeout():
	_set_state(PlayerState.IDLE)

#endregion: Node Signals
