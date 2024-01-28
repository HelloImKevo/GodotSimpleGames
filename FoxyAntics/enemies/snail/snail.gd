class_name Snail
extends EnemyBase
## Snail : A basic enemy that moves back and forth along a platform.

@onready var floor_detection = $FloorDetection
@onready var animated_sprite_2d = $AnimatedSprite2D


func _to_string() -> String:
	return "Snail(%s, %s)" % [points, global_position]


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	# _enable_debug_label()


func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = speed * _facing
	
	move_and_slide()
	
	if is_on_floor():
		if is_on_wall() or !floor_detection.is_colliding():
			flip_me()
	
	_on_post_physics_process()


func flip_me() -> void:
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	# Move the RayCast2D to the opposite side of the enemy.
	floor_detection.position.x *= -1
	
	if _facing == Facing.LEFT:
		_facing = Facing.RIGHT
	else:
		_facing = Facing.LEFT
