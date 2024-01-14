extends Node
## GameManager : game_manager.gd
##
## Singleton that manages game environment attributes.


const GROUP_TILE: String = "tile"

const LEVELS: Dictionary = {
	1: { "rows": 2, "cols": 2 },
	2: { "rows": 3, "cols": 4 },
	3: { "rows": 4, "cols": 4 },
	4: { "rows": 4, "cols": 6 },
	5: { "rows": 5, "cols": 6 },
	6: { "rows": 6, "cols": 6 }
}


func _to_string() -> String:
	return "GameManager"


# Make sure [ImageManager.is_data_loaded] is true!
func get_level_selection(level_num: int) -> Dictionary:
	var level_data = LEVELS[level_num]
	var num_tiles = level_data.rows * level_data.cols
	var target_pairs: int = num_tiles / 2
	var selected_level_images = []
	
	ImageManager.shuffle_images()
	
	for i in range(target_pairs):
		selected_level_images.append(ImageManager.get_image(i))
		selected_level_images.append(ImageManager.get_image(i))
	
	selected_level_images.shuffle()
	
	return {
		"target_pairs": target_pairs,
		"num_cols": level_data.cols,
		"image_list": selected_level_images
	}


## This is going to destroy all "tile" nodes in the game. It's not a robust
## implementation, but will work for a lightweight game like this one.
func clear_nodes_of_group(g_name: String) -> void:
	print(_to_string(), ": Destroying all nodes belonging to group: ", g_name)
	for node in get_tree().get_nodes_in_group(g_name):
		node.queue_free()
