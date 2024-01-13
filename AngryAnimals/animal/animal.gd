extends RigidBody2D


## Animal : animal.gd
##
## An [Animal] that can be launched with an impulse, and land inside
## of a [Cup] target. It can also fall into the [Water] and die.


@onready var stretch_sound = $StretchSound
@onready var launch_sound = $LaunchSound
@onready var collision_sound = $CollisionSound
@onready var arrow_sprite = $ArrowSprite


const DRAG_LIMIT_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIMIT_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULTIPLIER: float = 25.0
# Sort of a hack for the theoretical max impulse.
const IMPULSE_MAX: float = 1200.0
const FRICTION_MULTIPLIER: float = 0.15
# A bit of a hack to pause physics processing of detected collisions
# for a brief moment after launching the animal.
const FIRE_DELAY: float = 0.25
# Small tolerance threshold to detect whether our Angular and Linear velocity
# is "close enough" to zero for the RigidBody2D.
const STOPPED_TOLERANCE: float = 0.1


var _dead: bool = false
# Used by coroutine: Are we in the process of dying?
var _dying: bool = false

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
var _arrow_scale_x: float = 0.0
# Record the amount we moved the mouse since the previous physics process.
# Used to play a 'stretching' sound.
var _last_drag_amount: float = 0.0
var _last_collision_count: int = 0


func _to_string():
	return "%s@%s" % ["Animal", get_rid()]


# Called when the node enters the scene tree for the first time.
func _ready():
	_start = global_position
	_arrow_scale_x = arrow_sprite.scale.x
	arrow_sprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_debug_label()
	
	if _released == true:
		_fired_time += delta
		if _fired_time > FIRE_DELAY:
			play_collision()
			decelerate_if_on_target()
			check_on_target()
	else:
		if _dragging == false:
			return
		else:
			if Input.is_action_just_released("drag") == true:
				release_it()
			else:
				# We are in 'dragging mode'.
				drag_it()


func update_debug_label() -> void:
	var s = "g_pos:%s contacts:%s" % [
		Utils.vec2_to_str(global_position),
		get_contact_count()
	]
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


func scale_arrow() -> void:
	var imp_len = get_impulse().length()
	var percent = imp_len / IMPULSE_MAX
	
	arrow_sprite.scale.x = (_arrow_scale_x * percent) + _arrow_scale_x
	arrow_sprite.rotation = (_start - global_position).angle()


func stopped_rolling() -> bool:
	if get_contact_count() > 0:
		if (
			abs(linear_velocity.y) < STOPPED_TOLERANCE
			and abs(angular_velocity) < STOPPED_TOLERANCE
		):
			return true
	
	return false


## If the [Animal] is touching a [Cup] target, apply a small amount of deceleration
## on the X-axis to simulate higher friction.
func decelerate_if_on_target() -> void:
	if stopped_rolling():
		return
	
	if get_contact_count() > 0:
		# Produce a small amount of X linear velocity in the reverse direction.
		var rate_of_deceleration = linear_velocity.x * -1 * FRICTION_MULTIPLIER
		print("Animal Decelerating : velocity.x:%.3f rate_of_deceleration:%.3f" % [linear_velocity.x, rate_of_deceleration])
		linear_velocity.x += rate_of_deceleration


# Detect whether the Animal has stopped rolling and whether it
# is inside of a "Cup" target.
func check_on_target() -> void:
	if !stopped_rolling():
		return
	
	var cb: Array[Node2D] = get_colliding_bodies()
	if cb.size() == 0:
		return
	
	var cup: Node2D = cb[0]
	
	if cup.is_in_group(GameManager.GROUP_CUP):
		cup.die()
		die_async()


func play_collision() -> void:
	if (
		_last_collision_count == 0
		and get_contact_count() > 0
		and !collision_sound.playing
	):
		collision_sound.play()
	
	_last_collision_count = get_contact_count()


func grab_it() -> void:
	_dragging = true
	_drag_start = get_global_mouse_position()
	_last_dragged_position = _drag_start
	arrow_sprite.show()


func drag_it() -> void:
	var gmp = get_global_mouse_position()
	
	# We are getting the square root of the vector distance, so it will
	# always be a positive number.
	_last_drag_amount = (_last_dragged_position - gmp).length()
	_last_dragged_position = gmp
	
	if _last_drag_amount > 0 and stretch_sound.playing == false:
		stretch_sound.play()
	
	_dragged_vector = gmp - _drag_start
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIMIT_MIN.x,
		DRAG_LIMIT_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIMIT_MIN.y,
		DRAG_LIMIT_MAX.y
	)
	global_position = _start + _dragged_vector
	scale_arrow()


func release_it() -> void:
	_dragging = false
	_released = true
	freeze = false
	apply_central_impulse(get_impulse())
	stretch_sound.stop()
	launch_sound.play()
	ScoreManager.attempt_made()
	arrow_sprite.hide()


func get_impulse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULTIPLIER


# Coroutine that will pause briefly before making the Animal die.
func die_async() -> void:
	if _dying:
		return
	
	print("Animal landed in a Cup -> die()")
	_dying = true
	await get_tree().create_timer(0.3).timeout
	die()


# In order to fix this error:
# level.gd:30 @ on_animal_died(): Condition "!is_inside_tree()" is true. Returning: false
# You need to make sure the 'VisibleOnScreenEnabler2D' is positioned at the bottom
# of the Animal Node hierarchy.
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
		# print(_to_string(), " ", event)
		grab_it()
