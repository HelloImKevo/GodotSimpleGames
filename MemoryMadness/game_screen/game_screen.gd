extends Control
## GameScreen : game_screen.gd


@onready var label_moves = $HB/MCRight/VB/HB/Label
@onready var label_pairs = $HB/MCRight/VB/HB2/Label
@onready var label_exit_btn = $HB/MCRight/VB/ExitButton/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	# TranslationServer.set_locale("es")
	
	# Note, as long as the text value for these controls matches the KEY
	# in the translations CSV file, Godot does this automatically. Just
	# showing this here for reference purposes.
	label_moves.text = tr("MOVES")
	label_pairs.text = tr("PAIRS")
	label_exit_btn.text = tr("EXIT")
