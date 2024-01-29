extends Node2D
## Level : Common Sokoban level with floors, walls, boxes and switches.


func _to_string() -> String:
	return "Level"


func _ready():
	var d = GameData.get_data_for_level("10")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
