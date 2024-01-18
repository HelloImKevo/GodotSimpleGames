extends Node2D


@onready var player_cam = $PlayerCam
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	# Anchor the 2D camera viewport to the player's position.
	# We want all the physics processing to be calculated before
	# the camera starts moving around.
	player_cam.position = player.position
