extends RigidBody2D


var _dead: bool = false


func _to_string():
	return "%s@%s" % ["Animal", get_rid()]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_debug_label()


func update_debug_label() -> void:
	var s = "g_pos:%s" % [Utils.vec2_to_str(global_position)]
	s += "\nang:%.2f linear:%s" % [
		angular_velocity,
		Utils.vec2_to_str(linear_velocity)
	]
	SignalManager.on_update_debug_label.emit(s)


func _on_screen_exited():
	print("%s -> _on_screen_exited() -> die()" % [_to_string()])
	die()


func die() -> void:
	if _dead == true:
		return
	
	_dead = true
	SignalManager.on_animal_died.emit()
	queue_free()
