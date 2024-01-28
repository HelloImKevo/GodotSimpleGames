extends CanvasLayer
## Main : Main menu screen. Press 'jump' to start the first level.


@onready var label_high_score = $VBoxContainer/LabelHighScore


func _ready():
	# TranslationServer.set_locale("es")
	
	# Note, as long as the text value for these controls matches the KEY
	# in the translations CSV file, Godot does this automatically. Just
	# showing this here for reference purposes.
	# Resume game at default x1 speed.
	GameManager.resume_game()
	label_high_score.text = tr("HIGH_SCORE") + str(ScoreManager._high_score)


func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()
