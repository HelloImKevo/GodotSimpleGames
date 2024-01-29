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
	for tile_coord in layer_tiles:
		add_tile(tile_coord.coord, layer_name)


func add_tile(tile_coord: Dictionary, layer_name: String) -> void:
	var layer_number = LAYER_MAP[layer_name]
	var coord_vec: Vector2i = Vector2i(tile_coord.x, tile_coord.y)
	var atlas_vec: Vector2i = get_atlas_coord_for_layer_name(layer_name)
	
	tile_map.set_cell(layer_number, coord_vec, SOURCE_ID, atlas_vec)


func get_atlas_coord_for_layer_name(layer_name: String) -> Vector2i:
	match layer_name:
		LAYER_KEY_FLOOR:
			# Return a random floor tile (each one has a subtle variation).
			return Vector2i(randi_range(3, 8), 0)
		
		LAYER_KEY_WALLS:
			return Vector2i(2, 0)
		
		LAYER_KEY_TARGETS:
			return Vector2i(9, 0)
		
		LAYER_KEY_TARGET_BOXES:
			return Vector2i(0, 0)
		
		LAYER_KEY_BOXES:
			return Vector2i(1, 0)
	
	return Vector2i.ZERO
