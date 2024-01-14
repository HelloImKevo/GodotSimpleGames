extends Node


## ImageManager : image_manager.gd


const FRAME_IMAGES: Array = [
	preload("res://assets/frames/blue_frame.png"),
	preload("res://assets/frames/red_frame.png"),
	preload("res://assets/frames/yellow_frame.png"),
	preload("res://assets/frames/green_frame.png")
]
const LOAD_DELAY: float = 4.0


## [
##     {"item_name": "tree", "item_texture": CompressedTexture2D},
##     {"item_name": "pear", "item_texture": CompressedTexture2D}
## ]
var _item_images: Array = []
var _is_data_loaded: bool = false


func is_data_loaded() -> bool:
	return _is_data_loaded


func get_random_item_image() -> Dictionary:
	return _item_images.pick_random()


func get_image(index: int) -> Dictionary:
	assert(is_data_loaded())
	return _item_images[index]


func get_random_frame_image() -> CompressedTexture2D:
	return FRAME_IMAGES.pick_random()


func shuffle_images() -> void:
	_item_images.shuffle()


func _to_string() -> String:
	return "ImageManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_async()
	print(_to_string(), " _ready() -> Loading images ...")


## Experimental: This hasn't been heavily tested.
## Spins up a Coroutine that will wait for all image data to load into memory,
## and then emit the [SignalManager.on_load_game_data_complete] signal.
func _load_async() -> void:
	print("Start Loading @ %d ms" % [Time.get_ticks_msec()])
	SignalManager.loading_game_data.emit()
	await get_tree().create_timer(LOAD_DELAY).timeout
	_load_item_images()


func _load_item_images() -> void:
	var path = "res://assets/glitch"
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("ERROR: ", path)
		return
	
	var file_names = dir.get_files()
	# print(file_names)
	
	for fn in file_names:
		if ".import" not in fn:
			_add_file_to_list(fn, path)
	
	# OS.delay_msec(5000)
	print("Finished Loading %d images @ %d ms" % [_item_images.size(), Time.get_ticks_msec()])
	_is_data_loaded = true
	SignalManager.on_load_game_data_complete.emit()


func _add_file_to_list(fn: String, path: String) -> void:
	var full_path = path + "/" + fn
	
	var image_info_dict = {
		"item_name": fn.rstrip(".png"),
		"item_texture": load(full_path)
	}
	
	_item_images.append(image_info_dict)
