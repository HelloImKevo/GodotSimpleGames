extends Node2D
## Explosion : Animated explosion with a sound effect.


@onready var sound = $Sound


func _ready():
	SoundManager.play_explosion_random(sound)


func _on_animation_player_animation_finished(_anim_name):
	queue_free()
