class_name GameUi
extends Control


@onready var score_label = $MC/ScoreLabel
@onready var exit_label = $MC/ExitLabel
@onready var time_label = $MC/TimeLabel
@onready var game_over = $GameOver
@onready var game_over_label = $GameOver/GameOverLabel

var _time: float = 0.0
var _game_over: bool = false


func _ready():
	SignalManager.on_show_exit.connect(_on_show_exit)
	SignalManager.on_exit.connect(_on_exit)
	SignalManager.on_game_over.connect(_on_game_over)


func _on_show_exit() -> void:
	exit_label.show()


func _on_exit() -> void:
	set_process(false)
	game_over.show()
	game_over_label.text = "Well done! You took: %.1f seconds" % _time
	await get_tree().create_timer(3.0).timeout
	GameManager.load_main_scene()


func _on_game_over() -> void:
	if not _game_over:
		_game_over = true
		game_over.show()
		game_over_label.text = "YOU LOSE! Press Space"


func _process(delta):
	if not _game_over:
		_time += delta
		time_label.text = "%.1fs" % _time
	elif Input.is_action_just_pressed("press_space"):
		GameManager.load_main_scene()


func update_score(actual: int, target: int) -> void:
	score_label.text = "%s / %s" % [actual, target]
