class_name BaseBullet
extends Area2D
## BaseBullet : Defines common behavior for bullet projectiles.


var _direction: Vector2 = Vector2.UP
var _speed: float = 200.0
var _damage: int = 10


func setup(pos: Vector2, dir: Vector2, speed: float, damage: int) -> void:
	_direction = dir
	_speed = speed
	_damage = damage
	global_position = pos


func _ready():
	pass # Replace with function body.


func _process(delta):
	position += _direction * _speed * delta


func blow_up(area: Node2D) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	blow_up(area)
