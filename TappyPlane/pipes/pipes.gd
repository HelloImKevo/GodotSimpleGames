extends Node2D


const SCROLL_SPEED: float = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= SCROLL_SPEED * delta


func _on_screen_exited():
	print("Destroying pipe ...")
	# Remove this Pipe from the scene tree and destroy it.
	queue_free()
