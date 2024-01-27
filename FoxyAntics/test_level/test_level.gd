extends Node2D
## LevelBase : level_base.gd
##
## Base level for testing 2D physics and interations with player character.


@onready var player_cam = $PlayerCam
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.resume_game()


func _process(_delta):
	# Anchor the 2D camera viewport to the player's position.
	# We want all the physics processing to be calculated before
	# the camera starts moving around.
	player_cam.position = player.position


## Unused: Add to _process() for testing purposes.
func _debug_fast_level_transitions() -> void:
	if Input.is_action_just_pressed("left"):
		GameManager.load_main_scene()
	
	if Input.is_action_just_pressed("right"):
		GameManager.load_next_level_scene()
