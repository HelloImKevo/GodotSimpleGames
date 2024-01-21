class_name Shooter
extends Node2D
## Shooter : Controller responsible for throttling projectiles and playing
## projectile sound effects.


# Speed in pixels per second.
@export var speed: float = 100.0
# Life span in seconds.
@export var life_span: float = 10.0
@export var bullet_key: ObjectMaker.BulletKey
@export var shoot_delay: float = 0.7


@onready var sound = $Sound
@onready var shoot_timer = $ShootTimer

var _can_shoot: bool = true


func shoot(direction: Vector2) -> void:
	if not _can_shoot:
		return
	
	_can_shoot = false
	SoundManager.play_sfx(sound, SoundManager.SOUND_LASER)
	ObjectMaker.create_bullet(global_position, direction,
			speed, life_span, bullet_key)
	shoot_timer.start()


func _ready():
	shoot_timer.wait_time = shoot_delay


func _on_shoot_timer_timeout():
	_can_shoot = true
