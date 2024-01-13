extends Node


## ImageManager : image_manager.gd


## [
##     {"item_name": "tree", "item_texture": CompressedTexture2D},
##     {"item_name": "pear", "item_texture": CompressedTexture2D}
## ]
var _item_images: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	load_item_images()


func add_file_to_list(fn: String, path: String) -> void:
	var full_path = path + "/" + fn
	
	var image_info_dict = {
		"item_name": fn.rstrip(".png"),
		"item_texture": load(full_path)
	}
	
	_item_images.append(image_info_dict)


func load_item_images() -> void:
	print("Start Loading @ %d ms" % [Time.get_ticks_msec()])
	SignalManager.loading_game_data.emit()
	
	var path = "res://assets/glitch"
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("ERROR: ", path)
		return
	
	var file_names = dir.get_files()
	# print(file_names)
	
	for fn in file_names:
		if ".import" not in fn:
			add_file_to_list(fn, path)
	
	# OS.delay_msec(5000)
	print("Finished Loading %d images @ %d ms" % [_item_images.size(), Time.get_ticks_msec()])
	SignalManager.on_load_game_data_complete.emit()


## Experimental
## Spins up a new [Thread] that will wait for all image data to load into memory,
## and then emit the [SignalManager.on_load_game_data_complete] signal.
func _load_async() -> void:
	var thread = Thread.new()
	# Offload the load_item_images() function onto our Thread.
	thread.start(load_item_images)
