extends Node
## GameData : Responsible for loading  the Level Data JSON.


const LEVEL_DATA_PATH: String = "res://data/level_data.json"
const TILE_SIZE: int = 32

var _level_data: Dictionary = {}


func _to_string() -> String:
	return "GameData"


func _ready():
	load_level_data()


func load_level_data() -> void:
	var file = FileAccess.open(LEVEL_DATA_PATH, FileAccess.READ)
	_level_data = JSON.parse_string(file.get_as_text())
	pass


func get_data_for_level(level_num: String) -> Dictionary:
	return _level_data[level_num]
