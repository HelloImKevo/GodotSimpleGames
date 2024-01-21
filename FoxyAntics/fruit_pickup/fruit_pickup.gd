class_name FruitPickup
extends Area2D
## FruitPickup : A fruit powerup that is spawned when the player kills an enemy.
## The fruit is picked at random: Banana, Cherry, Kiwi or Melon.


@onready var animated_sprite_2d = $AnimatedSprite2D

const FRUITS: Array = ["melon", "banana", "kiwi", "cherry"]
const GRAVITY: float = 180.0
const JUMP: float = -80.0
const POINTS: int = 2

var _start_y: float
var _speed_y: float = JUMP
var _stopped: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_start_y = global_position.y
	animated_sprite_2d.play(FRUITS.pick_random())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _stopped:
		return
	
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if global_position.y > _start_y:
		_stopped = true


func _on_life_timer_timeout():
	kill_me()


func kill_me() -> void:
	set_process(false)
	hide()
	queue_free()


func _on_area_entered(area):
	print("Pickup collected: %s" % [area])
	EventBus.on_pickup_collected(self)
	kill_me()
