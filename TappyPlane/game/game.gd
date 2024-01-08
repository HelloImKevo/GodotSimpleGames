extends Node2D


@export var pipes_scene: PackedScene


@onready var pipes_holder = $PipesHolder
@onready var spawn_u = $SpawnU
@onready var spawn_l = $SpawnL
@onready var spawn_timer = $SpawnTimer


# Audio
@onready var engine_sound = $EngineSound
@onready var game_over_sound = $GameOverSound



# Called when the node enters the scene tree for the first time.
func _ready():
	# Reset current score to zero!
	GameManager.set_score(0)
	GameManager.on_game_over.connect(on_game_over)
	spawn_pipes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Spawn a new set of vertical pipes (an upper pipe and a lower pipe)
# at a random Y-axis coordinate, slightly off-screen on the right side.
func spawn_pipes() -> void:
	var y_pos = randf_range(spawn_u.position.y, spawn_l.position.y)
	var new_pipes = pipes_scene.instantiate()
	
	new_pipes.position = Vector2(spawn_l.position.x, y_pos)
	pipes_holder.add_child(new_pipes)


# Invoked every 1.2 seconds.
func _on_spawn_timer_timeout():
	print("Timer: Spawning pipes ...")
	spawn_pipes()


func stop_pipes() -> void:
	print_debug("Stopping pipe creation ...")
	
	spawn_timer.stop()
	for pipe in pipes_holder.get_children():
		# Enables of disables processing of a Node.
		pipe.set_process(false)


# Signal invoked when the Plane has died (from plane_cb).
func on_game_over():
	stop_pipes()
	# Stop the looping Plane Engine sound.
	engine_sound.stop()
	# Play the 'Game Over' jingle.
	game_over_sound.play()
