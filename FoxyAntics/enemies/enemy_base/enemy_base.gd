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

var _speed: float = 30.0
var _gravity: float = 800.0
var _facing: Facing = default_facing
var _player_ref: Player
var _dying: bool = false


func _to_string() -> String:
	return "EnemyBase(%s, %s)" % [points, global_position]


# Called when the node enters the scene tree for the first time.
func _ready():
	_player_ref = get_tree().get_nodes_in_group(GameManager.GROUP_PLAYER)[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_fallen_off()


func _fallen_off() -> void:
	if global_position.y > OFF_SCREEN_KILL_ME:
		# Hasta la vista, baby: Mark this enemy as ready to be destroyed.
		queue_free()


func die():
	if _dying:
		true
	
	_dying = true
	EventBus.on_enemy_hit(self)
	# Stop processing physics for this enemy.
	set_physics_process(false)
	hide()
	# TODO: Play the 'death' animation.
	queue_free()


func _on_screen_entered():
	pass # Replace with function body.


func _on_screen_exited():
	pass # Replace with function body.
