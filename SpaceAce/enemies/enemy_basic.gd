class_name EnemyBasic
extends PathFollow2D
## EnemyBasic : A basic enemy that follows a PathFollow2D. There are 4 Biomechs,
## 3 Bombers, and 3 Zippers (fast enemies).


## Whether or not this enemy shoots lasers.
@export var shoots: bool = false
## Does this enemy aim at the player, or just shoot down the screen?
@export var aims_at_player: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var laser_timer = $LaserTimer
@onready var booms = $Booms

var _player_ref: Player
var _speed: float = 0.0
var _can_shoot: bool = false
var _dead: bool = false
var _anim_string: String


func setup(speed: float, anim_name: String) -> void:
	_speed = speed
	_anim_string = anim_name


func _ready():
	_player_ref = get_tree().get_first_node_in_group(GameData.GROUP_PLAYER)
	if not _player_ref:
		queue_free()
		return
	
	animated_sprite_2d.play(_anim_string)


func _process(delta):
	progress_ratio += _speed * delta
	
	if progress_ratio > 0.99:
		queue_free()


func _on_laser_timer_timeout():
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_process(false)
	queue_free()


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
