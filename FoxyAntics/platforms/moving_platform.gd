extends AnimatableBody2D
## Checkpoint : An animated checkpoint flag that unfurls when the player
## defeats the [Boss].


# Point 1 (starting point).
@export var p1: Marker2D
# Point 2 (ending point).
@export var p2: Marker2D
@export var speed: float = 50.0

var _time_to_move: float = 0.0
# Reference to our tween that gets added to the [Tree]. We can use
# an 'exit tree' function to clean up resources.
var _tween: Tween


# Virtual Override
func _ready():
	set_time_to_move()
	set_moving()


# Virtual Override
func _exit_tree() -> void:
	_tween.kill()


func set_time_to_move() -> void:
	var delta = p1.global_position.distance_to(p2.global_position)
	_time_to_move = delta / speed


func set_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "global_position", p1.global_position, _time_to_move)
	_tween.tween_property(self, "global_position", p2.global_position, _time_to_move)
