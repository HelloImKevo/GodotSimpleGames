extends Control
## GameOver : Game Over overlay UI that shows the High Score.


@onready var timer = $Timer
@onready var score_label = $VB/ScoreLabel
@onready var press_shoot_label = $VB/PressShootLabel

var _can_shoot: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	SignalManager.on_player_died.connect(on_player_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _can_shoot and Input.is_action_just_pressed("shoot"):
		GameManager.load_main_scene()


func on_player_died() -> void:
	show()
	timer.start()
	score_label.text = "Score: %s (Best: %s)" % [
		ScoreManager.get_score(),
		ScoreManager.get_high_score()
	]


func _on_timer_timeout():
	press_shoot_label.show()
	_can_shoot = true
