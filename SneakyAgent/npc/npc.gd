class_name NPC
extends CharacterBody2D
## NPC : Non-Playable Character that uses Godot's NavigationAgent2D for pathfinding.


@onready var nav_agent = $NavAgent
@onready var sprite_2d = $Sprite2D
@onready var debug_label = $DebugLabel


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
	set_label()


func set_label():
	var s = "DONE: %s\n" % [nav_agent.is_navigation_finished()]
	s += "REACH: %s\n" % [nav_agent.is_target_reachable()]
	s += "REACHED: %s\n" % [nav_agent.is_target_reached()]
	s += "TARGET: %s\n" % [nav_agent.target_position]
	debug_label.text = s
