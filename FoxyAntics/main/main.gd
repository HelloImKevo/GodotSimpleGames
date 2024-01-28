extends CanvasLayer
## Main : Main menu screen. Press 'jump' to start the first level.


@onready var label_high_score = $VBoxContainer/LabelHighScore
@onready var chk_english = $VB2/RadioButtons/ChkEnglish
@onready var chk_spanish = $VB2/RadioButtons/ChkSpanish


func _ready():
	# TODO: Figure out how to reload current scene when translations
	# are changed (most games just say "Changes will take effect next
	# time you start the game").
	# TODO: Figure out a more efficient way to un-toggle radio buttons.
	var locale: String = TranslationServer.get_locale()
	print("Current locale: ", locale)
	if locale == "en":
		chk_english.set_pressed_no_signal(true)
		chk_spanish.set_pressed_no_signal(false)
	elif locale == "es":
		chk_english.set_pressed_no_signal(false)
		chk_spanish.set_pressed_no_signal(true)
	
	# Note, as long as the text value for these controls matches the KEY
	# in the translations CSV file, Godot does this automatically. Just
	# showing this here for reference purposes.
	# Resume game at default x1 speed.
	GameManager.resume_game()
	ScoreManager.reset_score()
	label_high_score.text = tr("HIGH_SCORE") + str(ScoreManager._high_score)


func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()


func _on_chk_english_pressed():
	print("English")
	TranslationServer.set_locale("en")


func _on_chk_spanish_pressed():
	print("Spanish")
	TranslationServer.set_locale("es")
