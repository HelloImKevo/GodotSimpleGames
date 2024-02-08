class_name NPC
extends CharacterBody2D
## NPC : Non-Playable Character that uses Godot's NavigationAgent2D for pathfinding.


@export var patrol_points: NodePath

const SPEED: float = 250.0

@onready var nav_agent = $NavAgent
@onready var sprite_2d = $Sprite2D
@onready var debug_label = $DebugLabel
@onready var player_detect = $PlayerDetect
@onready var ray_cast = $PlayerDetect/RayCast

var _waypoints: Array = []
var _current_wp: int = 0
var _player_ref: Player

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
	create_wp()
	_player_ref = get_tree().get_first_node_in_group("player")
	call_deferred("set_physics_process", true)
	# call_deferred("set_temp_target")


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
	update_navigation()
	process_patrolling()
	set_label()


func raycast_to_player() -> void:
	player_detect.look_at(_player_ref.global_position)


func player_detected() -> bool:
	var collider: Object = ray_cast.get_collider() # Gets first collider
	if collider != null:
		return collider.is_in_group("player")
	return false


func update_navigation() -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	# Normalize vector of magnitude 1.
	velocity = global_position.direction_to(next_path_position) * SPEED
	move_and_slide()


func process_patrolling() -> void:
	if nav_agent.is_navigation_finished():
		navigate_wp()


func navigate_wp() -> void:
	if _current_wp >= len(_waypoints):
		_current_wp = 0
	nav_agent.target_position = _waypoints[_current_wp]
	_current_wp += 1


func set_label():
	var s = "Done: %s\n" % [nav_agent.is_navigation_finished()]
	s += "P.Detected: %s\n" % [player_detected()]
	s += "Reached: %s\n" % [nav_agent.is_target_reached()]
	s += "TargetPos: %s\n" % [nav_agent.target_position]
	debug_label.text = s
