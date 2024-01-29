extends Node2D
## Level : Common Sokoban level with floors, walls, boxes and switches.


@onready var tile_map = $TileMap
@onready var player = $Player
@onready var camera_2d = $Camera2D

const FLOOR_LAYER = 0
const WALL_LAYER = 1
const TARGET_LAYER = 2
const BOX_LAYER = 3

## TileMap Atlas ID.
const SOURCE_ID = 0

const LAYER_KEY_FLOOR = "Floor"
const LAYER_KEY_WALLS = "Walls"
const LAYER_KEY_TARGETS = "Targets"
const LAYER_KEY_TARGET_BOXES = "TargetBoxes"
const LAYER_KEY_BOXES = "Boxes"

## Maps the Layer strings to their corresponding JSON + Layer ID integer key.
const LAYER_MAP = {
	LAYER_KEY_FLOOR: FLOOR_LAYER,
	LAYER_KEY_WALLS: WALL_LAYER,
	LAYER_KEY_TARGETS: TARGET_LAYER,
	LAYER_KEY_TARGET_BOXES: BOX_LAYER,
	LAYER_KEY_BOXES: BOX_LAYER
}


func _to_string() -> String:
	return "Level"


func _ready():
	setup_level()


func _process(delta):
	pass


func setup_level() -> void:
	tile_map.clear()
	var level_data = GameData.get_data_for_level("12")
	# JSON Array entries have "tiles" and "player_start".
	# Tiles has fields: Floor, Walls, Targets, TargetBoxes, Boxes
	var level_tiles = level_data.tiles
	var player_start = level_data.player_start
	
	# Build each Layer, starting with the first layer (Floor)
	for layer_name in LAYER_MAP.keys():
		add_layer_tiles(level_tiles[layer_name], layer_name)


func add_layer_tiles(layer_tiles: Array, layer_name: String) -> void:
	pass
