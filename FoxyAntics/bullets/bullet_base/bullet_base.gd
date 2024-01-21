class_name BulletBase
extends Area2D
## BulletBase : The base (abstract) bullet projectile class.

var _direction: Vector2 = Vector2.RIGHT
# How long does this bullet last before it is automatically destroyed.
var _life_span: float = 20.0
# How long has this bullet been alive?
var _life_time: float = 0.0


#region: Private / Internal Functions

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	_check_expired(delta)
	position += _direction * delta * 20.0


func _check_expired(delta: float) -> void:
	_life_time += delta
	
	if _life_time > _life_span:
		queue_free()

#endregion: Private / Internal Functions


#region: Public Functions

## Movement direction for the projectile (typically Vector2.LEFT / RIGHT / UP / DOWN),
## how long the bullet should last, and the speed of the projectile as pixels per second.
func setup(dir: Vector2, life_span: float, speed: float) -> void:
	# The magnitude of the vector in an X and Y is the square root of 1^2 + 1^2.
	_direction = dir.normalized() * speed
	_life_span = life_span

#endregion: Public Functions


func _on_area_entered(area):
	# When the bullet hits anything it is supposed to collide with,
	# it will immediate die (garbage collection).
	queue_free()
