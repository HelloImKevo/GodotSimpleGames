class_name NPC
extends CharacterBody2D
## NPC : Non-Playable Character that uses Godot's NavigationAgent2D for pathfinding.


const SPEED: float = 80.0

@onready var nav_agent = $NavAgent
@onready var sprite_2d = $Sprite2D
@onready var debug_label = $DebugLabel


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
	update_navigation()
	set_label()


func update_navigation() -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	sprite_2d.look_at(next_path_position)
	# Normalize vector of magnitude 1.
	velocity = global_position.direction_to(next_path_position) * SPEED
	move_and_slide()


func set_label():
	var s = "DONE: %s\n" % [nav_agent.is_navigation_finished()]
	s += "REACH: %s\n" % [nav_agent.is_target_reachable()]
	s += "REACHED: %s\n" % [nav_agent.is_target_reached()]
	s += "TARGET: %s\n" % [nav_agent.target_position]
	debug_label.text = s
