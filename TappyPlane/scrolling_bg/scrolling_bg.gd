extends ParallaxBackground


const SPEED: float = 120.0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Observe the 'On Game Over' signal.
	GameManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Scroll left (negative velocity).
	scroll_offset.x += SPEED * delta * -1


func on_game_over() -> void:
	# Stop the parallax scrolling effect.
	set_process(false)
