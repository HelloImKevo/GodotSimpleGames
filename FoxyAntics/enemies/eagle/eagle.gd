class_name Eagle
extends EnemyBase
## Eagle : A flying enemy that periodically switches its flight direction.
## When it is above the player, it will shoot a downward projectile!

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var direction_timer = $DirectionTimer

const FLY_SPEED: Vector2 = Vector2(35.0, 15.0)

var _fly_direction: Vector2 = Vector2.ZERO


func _to_string() -> String:
	return "Eagle(%s, %s)" % [points, global_position]


func _get_additional_debug_metadata() -> String:
	return "timer=%.2f facing=%s" % [ direction_timer.time_left, _facing ]


func _ready():
	super._ready()
	_enable_debug_label()


func _physics_process(delta):
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	_on_post_physics_process()


#region: Private Functions

func _determine_flight_direction_and_flip_sprite() -> void:
	var x_dir = sign(_player_ref.global_position.x - self.global_position.x)
	if x_dir > 0:
		animated_sprite_2d.flip_h = true
		_facing = Facing.RIGHT
	else:
		animated_sprite_2d.flip_h = false
		_facing = Facing.LEFT
	
	_fly_direction = Vector2(x_dir, 1) * FLY_SPEED


func _fly_to_player() -> void:
	_determine_flight_direction_and_flip_sprite()
	direction_timer.start()

#endregion: Private Functions


#region: Node Signals

func _on_visible_on_screen():
	animated_sprite_2d.play("fly")
	_fly_to_player()


func _on_direction_timer_timeout():
	_fly_to_player()

#endregion: Node Signals
