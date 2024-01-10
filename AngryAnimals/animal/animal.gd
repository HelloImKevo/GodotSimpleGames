extends RigidBody2D


var _dead: bool = false

# Are we in the process of dragging the animal?
var _dragging: bool = false
# When a click-and-drag event mouse click is released.
var _released: bool = false
# Animal global start position.
var _start: Vector2 = Vector2.ZERO
# Starting drag position of the mouse.
var _drag_start: Vector2 = Vector2.ZERO
# Every physics process frame, keep track of the last drag position.
var _last_dragged_position: Vector2 = Vector2.ZERO
# The amount we have dragged from the starting drag position.
var _dragged_vector: Vector2 = Vector2.ZERO
# How many seconds we have been in the air since the drag was released.
# Allows us to not start detecting collisions with things until the
# physics engine takes over and starts processing things.
var _fired_time: float = 0.0
# Record the amount we moved the mouse since the previous physics process.
# Used to play a 'stretching' sound.
var _last_drag_amount: float = 0.0


func _to_string():
	return "%s@%s" % ["Animal", get_rid()]


# Called when the node enters the scene tree for the first time.
func _ready():
	_start = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	update_debug_label()
	
	if _released == true:
		pass
	else:
		if _dragging == false:
			return
		else:
			# We are in 'dragging mode'.
			drag_it()


func update_debug_label() -> void:
	var s = "g_pos:%s" % [Utils.vec2_to_str(global_position)]
	s += "\n_dragging:%s _released:%s" % [
		_dragging,
		_released
	]
	s += "\n_start:%s _drag_start:%s _dragged_vector:%s" % [
		Utils.vec2_to_str(_start),
		Utils.vec2_to_str(_drag_start),
		Utils.vec2_to_str(_dragged_vector)
	]
	s += "\n_last_dragged_position:%s _last_drag_amount:%.2f" % [
		Utils.vec2_to_str(_last_dragged_position),
		_last_drag_amount
	]
	s += "\nang:%.2f linear:%s _fired_time:%.2f" % [
		angular_velocity,
		Utils.vec2_to_str(linear_velocity),
		_fired_time
	]
	SignalManager.on_update_debug_label.emit(s)


func _on_screen_exited():
	print("%s -> _on_screen_exited() -> die()" % [_to_string()])
	die()


func grab_it() -> void:
	_dragging = true
	_drag_start = get_global_mouse_position()
	_last_dragged_position = _drag_start


func drag_it() -> void:
	var gmp = get_global_mouse_position()
	
	# We are getting the square root of the vector distance, so it will
	# always be a positive number.
	_last_drag_amount = (_last_dragged_position - gmp).length()
	_last_dragged_position = gmp
	
	_dragged_vector = gmp - _drag_start
	global_position = _start + _dragged_vector


func die() -> void:
	if _dead == true:
		return
	
	_dead = true
	SignalManager.on_animal_died.emit()
	queue_free()


# InputEventMouseButton: button_index=1, mods=none, pressed=true, canceled=false,
# position=((149, 329)), button_mask=1, double_click=false
func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if _dragging == true or _released == true:
		return
	
	if event.is_action_pressed("drag") == true:
		print(event)
		grab_it()
