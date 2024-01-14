extends Node
## GameManager : game_manager.gd
##
## Singleton that manages game environment attributes.


const LEVELS: Dictionary = {
	1: { "rows": 2, "cols": 2 },
	2: { "rows": 3, "cols": 4 },
	3: { "rows": 4, "cols": 4 },
	4: { "rows": 4, "cols": 6 },
	5: { "rows": 5, "cols": 6 },
	6: { "rows": 6, "cols": 6 }
}


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
