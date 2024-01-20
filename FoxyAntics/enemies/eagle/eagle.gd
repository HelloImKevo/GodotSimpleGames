class_name Eagle
extends EnemyBase
## Eagle : A flying enemy that periodically switches its flight direction.
## When it is above the player, it will shoot a downward projectile!

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var direction_timer = $DirectionTimer


func _to_string() -> String:
	return "Eagle(%s, %s)" % [points, global_position]


func _get_additional_debug_metadata() -> String:
	return "timer=%.2f facing=%s" % [ direction_timer.time_left, _facing ]


func _ready():
	super._ready()
	_enable_debug_label()


func _physics_process(delta):
	super._physics_process(delta)
	
	move_and_slide()
	_flip_me()
	_on_post_physics_process()


#region: Private Functions

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

func _on_screen_entered():
	animated_sprite_2d.play("fly")


func _on_screen_exited():
	pass # Replace with function body.

#endregion: Node Signals
