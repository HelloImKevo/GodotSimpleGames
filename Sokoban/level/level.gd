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

var _moving: bool = false
var _total_moves: int = 0


func _to_string() -> String:
	return "Level"


func _ready():
	setup_level()


func _process(delta):
	handle_player_input()


func handle_player_input():
	if _moving:
		return
	
	var move_direction = Vector2i.ZERO
	
	if Input.is_action_just_pressed("right"):
		player.flip_h = false
		move_direction = Vector2i.RIGHT
	if Input.is_action_just_pressed("left"):
		player.flip_h = true
		move_direction = Vector2i.LEFT
	if Input.is_action_just_pressed("up"):
		move_direction = Vector2i.UP
	if Input.is_action_just_pressed("down"):
		move_direction = Vector2i.DOWN
	
	if move_direction != Vector2i.ZERO:
		player_move(move_direction)


func get_player_tile() -> Vector2i:
	var player_offset = player.global_position - tile_map.global_position
	return Vector2i(player_offset / GameData.TILE_SIZE)


func player_move(direction: Vector2i) -> void:
	_moving = true
	
	var player_tile = get_player_tile()
	var new_tile = player_tile + direction
	var can_move = true
	var box_seen = false
	
	print("direction: ", direction)
	print("player_tile: ", player_tile)
	print("new_tile: ", new_tile)
	
	if cell_is_wall(new_tile):
		can_move = false
	if cell_is_box(new_tile):
		box_seen = true
		can_move = box_can_move(new_tile, direction)
	
	print("can_move: ", can_move)
	
	_moving = false


#region -- TARGET CELL CHECKS --

func cell_is_wall(cell: Vector2i) -> bool:
	return cell in tile_map.get_used_cells(WALL_LAYER)


func cell_is_box(cell: Vector2i) -> bool:
	return cell in tile_map.get_used_cells(BOX_LAYER)

func cell_is_empty(cell: Vector2i) -> bool:
	return !cell_is_wall(cell) and !cell_is_box(cell)


func box_can_move(box_tile: Vector2i, direction: Vector2i) -> bool:
	var target_cell: Vector2i = box_tile + direction
	return cell_is_empty(target_cell)

#endregion -- TARGET CELL CHECKS --


#region -- LEVEL SETUP --

func setup_level() -> void:
	tile_map.clear()
	var level_data = GameData.get_data_for_level("1")
	# JSON Array entries have "tiles" and "player_start".
	# Tiles has fields: Floor, Walls, Targets, TargetBoxes, Boxes
	var level_tiles = level_data.tiles
	var player_start = level_data.player_start
	print("player_start: ", player_start)
	
	# Build each Layer, starting with the first layer (Floor)
	for layer_name in LAYER_MAP.keys():
		add_layer_tiles(level_tiles[layer_name], layer_name)
	
	place_player_on_tile(Vector2i(player_start.x, player_start.y))
	move_camera()


func add_layer_tiles(layer_tiles: Array, layer_name: String) -> void:
	for tile_coord in layer_tiles:
		add_tile(tile_coord.coord, layer_name)


func add_tile(tile_coord: Dictionary, layer_name: String) -> void:
	var layer_number = LAYER_MAP[layer_name]
	var coord_vec: Vector2i = Vector2i(tile_coord.x, tile_coord.y)
	var atlas_vec: Vector2i = get_atlas_coord_for_layer_name(layer_name)
	
	tile_map.set_cell(layer_number, coord_vec, SOURCE_ID, atlas_vec)


func place_player_on_tile(tile_coord: Vector2i) -> void:
	var new_pos = Vector2(
		tile_coord.x * GameData.TILE_SIZE,
		tile_coord.y * GameData.TILE_SIZE
	) + tile_map.global_position
	
	player.global_position = new_pos


## Position the camera in the middle of the loaded level.
func move_camera() -> void:
	# Returns a rectangle enclosing the used (non-empty) tiles of the map, including all layers.
	var tile_map_rect: Rect2i = tile_map.get_used_rect()
	
	var tile_map_start_x = tile_map_rect.position.x * GameData.TILE_SIZE
	var tile_map_end_x = tile_map_rect.size.x * GameData.TILE_SIZE + tile_map_start_x
	
	var tile_map_start_y = tile_map_rect.position.y * GameData.TILE_SIZE
	var tile_map_end_y = tile_map_rect.size.y * GameData.TILE_SIZE + tile_map_start_y
	
	var mid_x = tile_map_start_x + (tile_map_end_x - tile_map_start_x) / 2
	var mid_y = tile_map_start_y + (tile_map_end_y - tile_map_start_y) / 2
	
	camera_2d.position = Vector2(mid_x, mid_y)


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

#endregion -- LEVEL SETUP --
