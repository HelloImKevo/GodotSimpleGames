extends Node


## DataHelper : data_helper.gd
##
## Used for data persistence, like saving and retrieving high score data.


const filepath: String = "user://save_game.dat"


func save(json: String) -> void:
	print("Save data ... ", json)
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(json)
	file.close()


func load() -> String:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		return ""
	
	var content = file.get_as_text()
	file.close()
	print("Load data ... ", content)
	return content
