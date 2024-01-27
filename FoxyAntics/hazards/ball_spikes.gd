class_name BallSpikes
extends PathFollow2D
## BallSpikes : A spinning hazard that injures the player.


@export var speed: float = 0.15


func _process(delta):
	progress_ratio = progress_ratio + (delta * speed)
