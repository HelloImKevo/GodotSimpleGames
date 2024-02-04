class_name Saucer
extends PathFollow2D
## Saucer : Large spinning enemy.


const SPEED: float = 0.05


func _ready():
	progress_ratio = 0.0


func _process(delta):
	progress_ratio += SPEED * delta
