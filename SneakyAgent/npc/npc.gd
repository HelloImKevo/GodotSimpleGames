class_name NPC
extends CharacterBody2D
## NPC : Non-Playable Character that uses Godot's NavigationAgent2D for pathfinding.


@export var patrol_points: NodePath

const FOV: Dictionary = {
	EnemyState.PATROLLING: 60.0,
	EnemyState.CHASING: 120.0,
	EnemyState.SEARCHING: 100.0
}

const SPEED: Dictionary = {
	EnemyState.PATROLLING: 80.0,
	EnemyState.CHASING: 220.0,
	EnemyState.SEARCHING: 140.0
}

enum EnemyState { PATROLLING, CHASING, SEARCHING }

const BULLET = preload("res://bullet/bullet.tscn")

@onready var nav_agent = $NavAgent
@onready var sprite_2d = $Sprite2D
@onready var debug_label = $DebugLabel
@onready var player_detect = $PlayerDetect
@onready var ray_cast = $PlayerDetect/RayCast
@onready var warning = $Warning
@onready var lost_sight_timer = $LostSightTimer
@onready var animation = $Animation
@onready var gasp_sound = $GaspSound
@onready var shoot_timer = $ShootTimer

var _waypoints: Array = []
var _current_wp: int = 0
var _state: EnemyState = EnemyState.PATROLLING
## Used after the NPC performs a Search, and has lost sight of the player,
## to briefly pause the NPC before returning to its normal patrol.
var _lost_sight_of_player: bool = false
var _default_sight_distance: float
var _tween: Tween

# Reference error that can be resolved by using call_deferred("set_physics_process", true)
'''
E 0:00:01:0603   npc.gd:66 @ set_label(): NavigationServer map query failed because it was made before first map synchronization.
  <C++ Error>    Condition "map_update_id == 0" is true. Returning: Vector<Vector3>()
  <C++ Source>   modules/navigation/nav_map.cpp:119 @ get_path()
  <Stack Trace>  npc.gd:66 @ set_label()
				 npc.gd:39 @ _physics_process()
'''


func _ready():
	set_physics_process(false)
	_default_sight_distance = ray_cast.target_position.y
	create_wp()
	call_deferred("late_setup")
	# call_deferred("set_temp_target")


func late_setup():
	await get_tree().physics_frame
	call_deferred("set_physics_process", true)


func _get_player_ref() -> Player:
	return get_tree().get_first_node_in_group("player")


# Unused: For testing purposes.
func set_temp_target():
	nav_agent.target_position = Vector2(2800.0, 300.0)


func create_wp() -> void:
	for c: Node2D in get_node(patrol_points).get_children():
		_waypoints.append(c.global_position)


func _physics_process(_delta):
	if Input.is_action_just_pressed("set_target"):
		# TODO: After navigation is finished, reset the Current Waypoint to the
		# closest Waypoint, using a distance_to() function.
		nav_agent.target_position = get_global_mouse_position()
	
	raycast_to_player()
	update_state()
	adjust_sight_distance()
	update_movement_destination()
	update_navigation()
	set_label()


## Get the Line of Sight angle (in degrees) from the face of the [NPC] to the [Player].
## 0 degrees = Player is directly in front of NPC.
## 90 degrees = Player is directly to the left or the right of the NPC.
## 180 degrees = Player is directly behind the NPC.
func get_los_angle_to_player() -> float:
	var direction = global_position.direction_to(_get_player_ref().global_position)
	var dot_product = direction.dot(velocity.normalized())
	# The result should be between -1.0 and 1.0, but due to quirks of physics
	# processing and frames updating, it might not be.
	if dot_product >= -1.0 and dot_product <= 1.0:
		return rad_to_deg(acos(dot_product))
	
	return 0.0


## Returns true if the [Player] is within the Field of View (Line of Sight)
## angle at the face (front) of the [NPC]. The FOV angle threshold is dynamic;
## if the [NPC] is doing a routine patrol, their FOV is shallow, but if they
## are actively chasing (pursuing) the [Player], it is a wider angle.
## Should be used in conjunction with [player_detected()].
func player_in_fov() -> bool:
	return get_los_angle_to_player() < get_fov_angle_threshold()


func get_fov_angle_threshold() -> float:
	# This is dynamic, based on whether the NPC is currently
	# doing a routine patrol or if they are chasing Player.
	return FOV[_state]


## Continually aim the RayCast2D at the [Player].
func raycast_to_player() -> void:
	player_detect.look_at(_get_player_ref().global_position)


## Detect whether the [Player] is within range of the RayCast2D,
## and whether the [NPC] vision is obstructed by a wall.
func player_detected() -> bool:
	var collider: Object = ray_cast.get_collider() # Gets first collider
	if collider != null:
		return collider.is_in_group("player")
	return false


func can_see_player() -> bool:
	return player_in_fov() and player_detected()


func update_navigation() -> void:
	# The NPC will briefly pause if they lost sight of the player.
	if _lost_sight_of_player:
		return
	
	if nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	# Normalize vector of magnitude 1.
	#velocity = global_position.direction_to(next_path_position) * SPEED[_state]
	#move_and_slide()
	var initial_velocity = global_position.direction_to(next_path_position) * SPEED[_state]
	nav_agent.set_velocity(initial_velocity)


func process_patrolling() -> void:
	if nav_agent.is_navigation_finished():
		navigate_wp()


func process_searching() -> void:
	if nav_agent.is_navigation_finished():
		set_state(EnemyState.PATROLLING)


func process_chasing() -> void:
	set_nav_to_player()


func update_movement_destination() -> void:
	match _state:
		EnemyState.PATROLLING:
			process_patrolling()
		EnemyState.SEARCHING:
			process_searching()
		EnemyState.CHASING:
			process_chasing()


func set_state(new_state: EnemyState) -> void:
	if new_state == _state:
		return
	
	if new_state == EnemyState.CHASING:
		animation.play("alert")
		warning.self_modulate = Color.FIREBRICK
		resume_chasing()
		warning.show()
		SoundManager.play_gasp(gasp_sound)
	else:
		if (_state == EnemyState.SEARCHING):
			# If the NPC is currently Searching, then it may be
			# transitioning to either Patrolling or Chasing.
			warning.hide()
			
			if new_state != EnemyState.SEARCHING:
				_lost_sight_of_player = true
				stop_confused_animation()
				_tween = get_tree().create_tween()
				TweenUtils.tween_rotate_back_and_forth(sprite_2d, _tween, 30.0)
				warning.self_modulate = Color.DODGER_BLUE
				warning.show()
				lost_sight_timer.start()
		
		if new_state == EnemyState.SEARCHING:
			# Return the Sprite to its default color.
			warning.self_modulate = Color.WHITE
			warning.show()
	
	_state = new_state


func update_state() -> void:
	var new_state = _state
	var can_see = can_see_player()
	
	if can_see:
		new_state = EnemyState.CHASING
	elif not can_see and new_state == EnemyState.CHASING:
		new_state = EnemyState.SEARCHING
	
	set_state(new_state)


func adjust_sight_distance() -> void:
	match _state:
		EnemyState.PATROLLING:
			ray_cast.target_position.y = _default_sight_distance
		EnemyState.SEARCHING:
			ray_cast.target_position.y = _default_sight_distance + 50.0
		EnemyState.CHASING:
			ray_cast.target_position.y = _default_sight_distance + 100.0


func navigate_wp() -> void:
	if _current_wp >= len(_waypoints):
		_current_wp = 0
	nav_agent.target_position = _waypoints[_current_wp]
	_current_wp += 1


func set_nav_to_player() -> void:
	nav_agent.target_position = _get_player_ref().global_position


func stop_confused_animation() -> void:
	if _tween != null:
		_tween.kill()
		_tween = null


func set_label():
	var s = "Done: %s\n" % [nav_agent.is_navigation_finished()]
	s += "P.Detected: %s Speed: %.2f\n" % [player_detected(), SPEED[_state]]
	s += "LOS Angle: %.1f\n" % [get_los_angle_to_player()]
	# s += "In FOV: %s State: %s\n" % [player_in_fov(), EnemyState.keys()[_state]]
	# s += "Reached: %s\n" % [nav_agent.is_target_reached()]
	# s += "TargetPos: %s\n" % [nav_agent.target_position]
	s += "Velocity: %s\n" % [velocity]
	debug_label.text = s


func _on_lost_sight_timer_timeout():
	resume_chasing()
	warning.hide()


func resume_chasing() -> void:
	_lost_sight_of_player = false
	stop_confused_animation()
	animation.stop()


func _on_shoot_timer_timeout():
	if _state != EnemyState.CHASING:
		return
	
	shoot()


func stop_action() -> void:
	set_physics_process(false)
	shoot_timer.stop()
	nav_agent.set_velocity(Vector2.ZERO)


func shoot() -> void:
	var target = _get_player_ref().global_position
	var b: Bullet = BULLET.instantiate()
	b.init(target, global_position)
	get_tree().root.add_child(b)
	SoundManager.play_laser(gasp_sound)


func _on_hit_area_body_entered(_body):
	SignalManager.on_game_over.emit()


func _on_nav_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
