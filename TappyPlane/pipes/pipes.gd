extends Node2D


const SCROLL_SPEED: float = 120.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Pipe created ... %s (%s, %s)" % [name, position.x, position.y])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= SCROLL_SPEED * delta


func player_scored() -> void:
	GameManager.increment_score()


func _on_screen_exited():
	print("Destroying pipe ...")
	# Remove this Pipe from the scene tree and destroy it.
	queue_free()


func _on_pipe_body_entered(body):
	if body.is_in_group(GameManager.GROUP_PLANE) == true:
		# If this pipe collides with the Plane, trigger the 'On Dead'
		# event and trigger the Game Over scene.
		print_debug("Plane has collided with %s - invoking die()" % [name])
		body.die()


func _on_laser_body_entered(body):
	if body.is_in_group(GameManager.GROUP_PLANE) == true:
		print_debug("Plane has collided with a Laser - invoking player_scored()")
		player_scored()
