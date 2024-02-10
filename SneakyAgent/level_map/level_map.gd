extends Node2D


@onready var pickups: Node = $Pickups
@onready var game_ui = $CanvasLayer/GameUi

var _pickups_count: int = 0
var _collected: int = 0


func _ready():
	_pickups_count = pickups.get_children().size()
	game_ui.update_score(_collected, _pickups_count)
	SignalManager.on_pickup.connect(_on_pickup)
	SignalManager.on_exit.connect(_on_exit)
	SignalManager.on_game_over.connect(_on_game_over)


func _on_pickup() -> void:
	print("_on_pickup")
	_collected += 1
	game_ui.update_score(_collected, _pickups_count)
	check_show_exit()


func check_show_exit() -> void:
	if _collected == _pickups_count:
		SignalManager.on_show_exit.emit()
		print("on_show_exit")


func stop_all_nodes() -> void:
	for n: Node in get_tree().get_nodes_in_group("bullet"):
		n.queue_free()
	
	var p: Player = get_tree().get_first_node_in_group("player")
	p.set_physics_process(false)
	
	for n: Node in get_tree().get_nodes_in_group("npc"):
		# Reminder: The shoot timer will continue to timeout.
		n.stop_action()


func _on_exit() -> void:
	stop_all_nodes()


func _on_game_over() -> void:
	stop_all_nodes()
