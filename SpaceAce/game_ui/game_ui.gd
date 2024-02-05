extends Control
## GameUi : Main game User Interface with the player's Health Bar and Score.


@onready var health_bar = $ColorRect/MC/HB/HealthBar
@onready var score_label = $ColorRect/MC/HB/ScoreLabel


func _ready():
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_player_health_bonus.connect(on_player_health_bonus)
	SignalManager.on_score_updated.connect(on_score_updated)


func _on_health_bar_died():
	SignalManager.on_player_died.emit()
	# Later on, we'll pause the game and show the score.
	GameManager.load_main_scene()


func on_player_hit(dmg: int) -> void:
	health_bar.take_damage(dmg)


func on_player_health_bonus(v: int) -> void:
	health_bar.incr_value(v)


func on_score_updated(v: int) -> void:
	score_label.text = "%06d" % v
