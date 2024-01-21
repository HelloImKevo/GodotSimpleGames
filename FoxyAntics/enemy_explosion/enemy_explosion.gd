class_name EnemyExplosion
extends AnimatedSprite2D
## EnemyExplosion : A simple animation and sound effect that get destroyed
## when the animation is finished.


func _on_animation_finished():
	queue_free()
