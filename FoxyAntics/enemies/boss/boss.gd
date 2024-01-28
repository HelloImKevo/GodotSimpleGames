class_name Boss
extends Node2D
## Boss : An evil Ent (Tree Guy) that will become visible when the player
## approaches close enough, and then will bounce and charge attack the player.


const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"
const HIT_CONDITION: String = "parameters/conditions/on_hit"

@onready var animation_tree = $AnimationTree
@onready var visual = $Visual
@onready var hit_box = $Visual/HitBox

@export var hit_points: int = 3
@export var points: int = 5

var _invincible: bool = false
var _has_triggered: bool = false


func _to_string() -> String:
	return "Boss(%s, %s)" % [points, global_position]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_trigger_area_entered_by_player(area):
	print(_to_string(), " => Area %s entered the Boss trigger area!" % [area])
	_has_triggered = true
	if not animation_tree[TRIGGER_CONDITION]:
		animation_tree[TRIGGER_CONDITION] = true
		# Once the Boss is activated, move its hit box onto the 'enemy_hit_box' bit mask layer.
		hit_box.collision_layer = 4


func _on_hit_box_area_entered(_area):
	_take_damage()


func _take_damage() -> void:
	if not _has_triggered:
		return
	
	if _invincible:
		return
	
	_set_invincible(true)
	_tween_hit()
	_reduce_hit_points()


func _set_invincible(v: bool) -> void:
	_invincible = v
	animation_tree[HIT_CONDITION] = v


func _tween_hit() -> void:
	var tween = get_tree().create_tween()
	# The duration needs to be less than or equal to the duration of the
	# "Hit" animation.
	var duration: float = 1.0
	tween.tween_property(visual, "position", Vector2.ZERO, duration)


func _reduce_hit_points() -> void:
	hit_points -= 1
	if hit_points <= 0:
		_die()


# Note: This is almost identical to enemy_base.gd.die()
func _die():
	SignalManager.on_boss_killed.emit(points)
	ObjectMaker.spawn_entity(global_position, ObjectMaker.SceneKey.EXPLOSION)
	ObjectMaker.spawn_entity(global_position, ObjectMaker.SceneKey.PICKUP)
	set_process(false)
	queue_free()
