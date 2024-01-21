class_name Frog
extends EnemyBase
## Frog : A basic enemy that periodically jumps along a platform.
## It can also land on moving platforms!

const JUMP_VELOCITY: Vector2 = Vector2(150.0, -200.0)
# Random jump time interval between 2.5 seconds and 5.0 seconds.
const JUMP_WAIT_RANGE: Vector2 = Vector2(2.5, 5.0)

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

var _jump_allowed: bool = false
# Is the player on the screen?
var _seen_player: bool = false


func _to_string() -> String:
	return "Frog(%s, %s)" % [points, global_position]


func _get_additional_debug_metadata() -> String:
	# TODO: Enum keys lookup like Facing.keys()[_facing] doesn't appear to work
	# for custom value enums in Godot 4.2.1
	return "timer=%.2f facing=%s" % [ jump_timer.time_left, _facing ]


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	start_timer()
	_enable_debug_label()


func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = 0.0
		# In Godot, if the requested animation is already playing,
		# this is effectively a no-op.
		animated_sprite_2d.play("idle")
	
	_apply_jump()
	move_and_slide()
	_flip_me()
	_on_post_physics_process()


func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_WAIT_RANGE.x, JUMP_WAIT_RANGE.y)
	jump_timer.start()


#region: Private Functions

func _apply_jump() -> void:
	if !is_on_floor():
		return
	
	if !_seen_player or !_jump_allowed:
		return

	velocity = JUMP_VELOCITY
	if animated_sprite_2d.flip_h == false:
		# Make the frog jump in the direction the sprite is facing
		# (which should always be "towards the player").
		velocity.x *= -1
	
	_jump_allowed = false
	animated_sprite_2d.play("jump")
	start_timer()


func _flip_me() -> void:
	# The frog always jumps towards the player.
	if (
		_player_ref.global_position.x > global_position.x
		and
		!animated_sprite_2d.flip_h
	):
		animated_sprite_2d.flip_h = true
		_facing = Facing.RIGHT
	elif (
		_player_ref.global_position.x < global_position.x
		and
		animated_sprite_2d.flip_h
	):
		animated_sprite_2d.flip_h = false
		_facing = Facing.LEFT

#endregion: Private Functions


#region: Node Signals

func _on_jump_timer_timeout():
	_jump_allowed = true


func _on_visible_on_screen():
	_seen_player = true


func _on_not_visible_on_screen():
	pass # Replace with function body.

#endregion: Node Signals
