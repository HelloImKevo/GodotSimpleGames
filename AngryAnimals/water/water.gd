extends Area2D


## Water : water.gd
##
## A region of water at the bottom edge of the main scene. Causes the [Animal]
## to respawn when it lands in the water.


@onready var splash_sound = $SplashSound


func _on_body_entered(body):
	if body.is_in_group(GameManager.GROUP_ANIMAL):
		splash_sound.play()
