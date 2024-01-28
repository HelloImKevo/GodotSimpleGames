class_name HUD
extends Control
## HUD : The game Heads-Up Display with score and remaining hit points.


@onready var color_rect = $ColorRect
@onready var vb_level_complete = $ColorRect/VB_LevelComplete
@onready var vb_game_over = $ColorRect/VB_GameOver
@onready var hb_hearts = $MC/HB/HB_Hearts

var _hearts: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	_hearts = hb_hearts.get_children()
	SignalManager.on_level_complete.connect(_on_level_complete)
	SignalManager.on_game_over.connect(_on_game_over)
	SignalManager.on_player_hit.connect(_on_player_hit)


func _process(_delta):
	if vb_level_complete.visible:
		if Input.is_action_just_pressed("jump"):
			GameManager.load_next_level_scene()
	
	if vb_game_over.visible:
		if Input.is_action_just_pressed("jump"):
			GameManager.load_main_scene()


func show_hud() -> void:
	GameManager.pause_game()
	color_rect.visible = true


func _on_player_hit(hit_points: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = hit_points > life


func _on_level_complete(_level: int) -> void:
	vb_level_complete.visible = true
	show_hud()


func _on_game_over() -> void:
	vb_game_over.visible = true
	show_hud()
