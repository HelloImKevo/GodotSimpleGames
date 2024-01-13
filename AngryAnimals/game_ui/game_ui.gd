extends CanvasLayer


@onready var level_label = $MC/VB/HB/LevelLabel
@onready var attempts_label = $MC/VB/AttemptsLabel
@onready var vb_2 = $MC/VB2
@onready var music = $Music


# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = "Level %s" % ScoreManager.get_level_selected()
	on_attempt_made()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if vb_2.visible and Input.is_key_pressed(KEY_SPACE) == true:
		GameManager.load_main_scene()


func on_attempt_made() -> void:
	attempts_label.text = "Attempts %s" % ScoreManager.get_attempts()


func on_game_over() -> void:
	vb_2.show()
	music.play()
