extends Control
## GameScreen : game_screen.gd


@export var mem_tile_scene: PackedScene


@onready var tile_container = $HB/MCLeft/TileContainer

## Used for translation / localization / internationalization demonstration:
## https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
@onready var label_moves = $HB/MCRight/VB/HB/Label
@onready var label_pairs = $HB/MCRight/VB/HB2/Label

# The actual score values earned by the player.
@onready var moves_label = $HB/MCRight/VB/HB/MovesLabel
@onready var pairs_label = $HB/MCRight/VB/HB2/PairsLabel


@onready var label_exit_btn = $HB/MCRight/VB/ExitButton/Label
@onready var sound = $Sound

@onready var scorer: Scorer = $Scorer


# Called when the node enters the scene tree for the first time.
func _ready():
	# TranslationServer.set_locale("es")
	
	# Note, as long as the text value for these controls matches the KEY
	# in the translations CSV file, Godot does this automatically. Just
	# showing this here for reference purposes.
	label_moves.text = tr("MOVES")
	label_pairs.text = tr("PAIRS")
	label_exit_btn.text = tr("EXIT")
	
	SignalManager.on_level_selected.connect(_on_level_selected)


func _process(delta):
	moves_label.text = scorer.get_moves_made_str()
	pairs_label.text = scorer.get_pairs_made_str()


func _on_level_selected(level_num: int) -> void:
	var level_selection = GameManager.get_level_selection(level_num)
	var frame_image = ImageManager.get_random_frame_image()
	
	tile_container.columns = level_selection.num_cols
	
	for ii_dict in level_selection.image_list:
		_add_memory_tile(ii_dict, frame_image)
	
	scorer.clear_new_game(level_selection.target_pairs)


func _add_memory_tile(ii_dict: Dictionary, frame_image: CompressedTexture2D) -> void:
	var new_tile: MemoryTile = mem_tile_scene.instantiate()
	tile_container.add_child(new_tile)
	new_tile.setup(ii_dict, frame_image)


func _on_exit_button_pressed():
	SoundManager.play_button_click(sound)
	SignalManager.on_game_exit_pressed.emit()
