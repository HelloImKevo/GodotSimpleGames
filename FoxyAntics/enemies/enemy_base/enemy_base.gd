class_name EnemyBase
extends CharacterBody2D
## EnemyBase : enemy_base.gd
##
## The base (abstract) enemy class. Defines properties common to all enemies.

enum Facing { LEFT = -1, RIGHT = 1 }

## We'll call queue_free() once this enemy is way off-screen.
const OFF_SCREEN_KILL_ME: float = 1000.0

## Which direction does the enemy sprite need to be flipped?
@export var default_facing: Facing = Facing.LEFT
## How many points does the player earn when killing this enemy?
@export var points: int = 1
# How fast does this enemy move?
@export var speed: float = 30.0
# How many Hit Points (HP) does this enemy have?
@export var hit_points: int = 5

@onready var debug_label = $DebugLabel

var _gravity: float = 800.0
var _facing: Facing = default_facing
var _player_ref: Player
var _dying: bool = false

# Used to ensure inheritance integrity.
var _internal_ready_called: bool = false


#region: Subclass Overrides

func _to_string() -> String:
	return "EnemyBase(%s, %s)" % [points, global_position]


# Called when the node enters the scene tree for the first time.
func _ready():
	_internal_ready_called = true
	_player_ref = get_tree().get_nodes_in_group(GameManager.GROUP_PLAYER)[0]


func _physics_process(_delta):
	assert(_internal_ready_called, "Subclasses must invoke super._ready()")
	_fallen_off()


func _get_additional_debug_metadata() -> String:
	return ""

#endregion: Subclass Overrides


#region: Internal / Protected Functions

func _enable_debug_label() -> void:
	debug_label.show()


func _update_debug_label(msg: String) -> void:
	if debug_label.is_visible_in_tree():
		debug_label.text = msg


func _get_default_debug_string() -> String:
	return "hp=%s dist=%.2f\nvel.x=%.1f vel.y=%.1f\n%s" % [
		hit_points,
		get_distance_to_player(),
		velocity.x,
		velocity.y,
		_get_additional_debug_metadata()
	]


func _on_post_physics_process() -> void:
	_update_debug_label(_get_default_debug_string())


func _fallen_off() -> void:
	if global_position.y > OFF_SCREEN_KILL_ME:
		print(_to_string(), " => This enemy went way-off screen. Queuing it for destruction.")
		# Hasta la vista, baby: Mark this enemy as ready to be destroyed.
		queue_free()


func _on_hit_by_bullet() -> void:
	hit_points -= 1
	if hit_points <= 0:
		die()

#endregion: Internal / Protected Functions


#region: Public Functions

func die():
	if _dying:
		return
	
	_dying = true
	EventBus.on_enemy_hit(self)
	ObjectMaker.create_explosion(global_position)
	# Stop processing physics for this enemy.
	set_physics_process(false)
	hide()
	# TODO: Play the 'death' animation.
	queue_free()


func get_distance_to_player() -> float:
	if not _player_ref:
		return 0.0
	
	var my_position: Vector2 = position
	var player_position: Vector2 = _player_ref.position
	return my_position.distance_to(player_position)

#endregion: Public Functions


#region: Node Signals

func _on_visible_on_screen():
	pass # Replace with function body.


func _on_not_visible_on_screen():
	pass # Replace with function body.


func _on_enemy_hit_box_area_entered(_area):
	_on_hit_by_bullet()

#endregion: Node Signals
