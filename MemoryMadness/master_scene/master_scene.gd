extends CanvasLayer


## MasterScene : master_scene.gd


@onready var main_screen = $MainScreen
@onready var game_screen = $GameScreen
@onready var music = $Music
@onready var loading_widget = $LoadingWidget


func _ready():
	SignalManager.loading_game_data.connect(_on_loading_game_data)
	SignalManager.on_load_game_data_complete.connect(_on_load_game_data_complete)
	
	# Get our Main Menu music to start playing by default.
	_on_game_exit_pressed()
	
	SignalManager.on_game_exit_pressed.connect(_on_game_exit_pressed)
	SignalManager.on_level_selected.connect(_on_level_selected)


func show_game(s: bool) -> void:
	game_screen.visible = s
	main_screen.visible = !s


func _on_game_exit_pressed() -> void:
	show_game(false)
	SoundManager.play_music(music, SoundManager.SOUND_MAIN_MENU)


func _on_level_selected(level_num: int) -> void:
	show_game(true)
	SoundManager.play_music(music, SoundManager.SOUND_IN_GAME)


#region: Loading Game Data Events

func _on_loading_game_data() -> void:
	loading_widget.show()


func _on_load_game_data_complete() -> void:
	loading_widget.hide()

#endregion: Loading Game Data Events
