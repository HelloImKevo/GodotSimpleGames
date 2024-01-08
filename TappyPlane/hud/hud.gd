extends Control


@onready var score_label = $MC/ScoreLabel
@onready var message_label = $MC2/MessageLabel
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.on_score_updated.connect(on_score_updated)


func on_score_updated() -> void:
	var score: int = GameManager.get_score()
	score_label.text = str(score)
	
	if (score % 30 == 0) == true:
		_show_message("Awesome!")
	elif (score % 20 == 0) == true:
		_show_message("Well done!")
	elif (score % 10 == 0) == true:
		_show_message("Good job!")


func _show_message(msg: String) -> void:
	message_label.text = msg
	message_label.show()
	timer.start()


func _on_timer_timeout():
	# Hide the message after it is shown briefly.
	message_label.hide()
