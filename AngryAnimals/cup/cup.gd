extends StaticBody2D


## Cup : cup.gd
##
## A container target that the [Animal] can land inside of.


@onready var animation_player = $AnimationPlayer
@onready var vanish_sound = $VanishSound


var _dying: bool = false


func die() -> void:
	if _dying:
		return
	
	_dying = true
	vanish_sound.play()
	animation_player.play("vanish")


func _on_vanish_sound_finished():
	SignalManager.on_cup_destroyed.emit()
	# When the sound is finished, mark this Cup ready for destruction (garbage collection).
	queue_free()
