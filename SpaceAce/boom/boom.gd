extends AnimatedSprite2D
## Boom : Spawned when ships blow up. A big ship can have multiple booms.


@onready var sound = $Sound


func _ready():
	SoundManager.play_explosion_random(sound)


func _on_animation_finished():
	queue_free()
