class_name EnemyBasic
extends PathFollow2D
## EnemyBasic : A basic enemy that follows a PathFollow2D. There are 4 Biomechs,
## 3 Bombers, and 3 Zippers (fast enemies).


## Whether or not this enemy shoots lasers.
@export var shoots: bool = false
## Does this enemy aim at the player, or just shoot down the screen?
@export var aims_at_player: bool = false

@export var bullet_scene: PackedScene
@export var bullet_damage: int = 10
@export var bullet_speed: float = 120.0
@export var bullet_direction: Vector2 = Vector2.DOWN
@export var bullet_wait_time: float = 3.0
@export var bullet_wait_time_var: float = 0.05

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var laser_timer = $LaserTimer
@onready var booms = $Booms
@onready var health_bar = $HealthBar

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


func update_bullet_direction() -> void:
	# Guard against NPEs.
	if (not aims_at_player or not is_instance_valid(_player_ref)):
		return
	
	bullet_direction = global_position.direction_to(_player_ref.global_position)


func start_shoot_timer() -> void:
	Utils.set_and_start_timer(laser_timer, bullet_wait_time, bullet_wait_time_var)


func shoot() -> void:
	var bullet: BaseBullet = bullet_scene.instantiate()
	update_bullet_direction()
	bullet.setup(
		global_position,
		bullet_direction,
		bullet_speed,
		bullet_damage
	)
	get_tree().root.add_child(bullet)
	start_shoot_timer()


func _on_laser_timer_timeout():
	shoot()


func _on_visible_on_screen_notifier_2d_screen_entered():
	if shoots:
		start_shoot_timer()


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_process(false)
	queue_free()


func _on_area_2d_area_entered(area):
	health_bar.take_damage(20)


func _on_health_bar_died():
	# TODO: Wait for audio explosion SFX to finish playing.
	set_process(false)
	queue_free()
