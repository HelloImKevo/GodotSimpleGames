class_name Pickup
extends Area2D


@onready var animation = $Animation
@onready var sound = $Sound


func play_sound() -> void:
	sound.stream = SoundManager.get_random_pickup_sound()
	sound.play()


func _on_body_entered(_body):
	# Prevent multiple signals from being emitted.
	set_deferred("monitoring", false)
	SignalManager.on_pickup.emit()
	animation.play("vanish")
	play_sound()


func _on_sound_finished():
	queue_free()
