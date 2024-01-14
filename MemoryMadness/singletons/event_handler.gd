extends Node
## EventHandler : event_handler.gd


func _to_string() -> String:
	return "EventHandler"


func on_level_selected(level_num: int) -> void:
	if !ImageManager.is_data_loaded():
		print(_to_string(), ": Game is still loading. Please wait ...")
		return
	
	SignalManager.on_level_selected.emit(level_num)
