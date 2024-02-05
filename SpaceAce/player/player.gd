class_name Player
extends Area2D
## Player : Player spaceship that can shoot bullets and acquire powerups.


@export var bullet_scene: PackedScene
@export var speed: float = 250.0
@export var bullet_speed: float = 250.0
@export var bullet_damage: int = 10
@export var bullet_direction: Vector2 = Vector2.UP

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var shield = $Shield

const MARGIN: float = 32.0

var _upper_left: Vector2
var _lower_right: Vector2


func _ready():
	set_limits()
	SignalManager.on_powerup_hit.connect(on_powerup_hit)


func _process(delta):
	var input: Vector2 = get_input()
	global_position += input * delta * speed
	global_position = global_position.clamp(_upper_left, _lower_right)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()


func get_input() -> Vector2:
	# The get_axis function helps us determine the length / magnitude of the
	# vector for diagonal movement.
	var v = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	if v.x != 0:
		animation_player.play("turn")
		if v.x > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
	else:
		animation_player.play("fly")
	
	return v.normalized()


func set_limits() -> void:
	var vp = get_viewport_rect()
	_lower_right = Vector2(
		vp.size.x - MARGIN,
		vp.size.y - MARGIN
	)
	_upper_left = Vector2(MARGIN, MARGIN)


func shoot() -> void:
	var bullet: BaseBullet = bullet_scene.instantiate()
	bullet.setup(
		global_position,
		bullet_direction,
		bullet_speed,
		bullet_damage
	)
	get_tree().root.add_child(bullet)


func on_powerup_hit(powerup: GameData.POWERUP_TYPE) -> void:
	print("Powerup hit: ", powerup)
	if GameData.POWERUP_TYPE.SHIELD == powerup:
		shield.enable_shield()


func _on_area_entered(area):
	print("Something hit the PLAYER: %s , %s" % [area, area.get_groups()])
	if area.is_in_group(GameData.GROUP_ENEMY_SHIP):
		SignalManager.on_player_hit.emit(GameData.COLLISION_DAMAGE)
	elif area.is_in_group(GameData.GROUP_SAUCER):
		SignalManager.on_player_hit.emit(GameData.COLLISION_DAMAGE)
	elif area.is_in_group(GameData.GROUP_HOMING_MISSILE):
		SignalManager.on_player_hit.emit(GameData.MISSILE_DAMAGE)
	elif area.is_in_group(GameData.GROUP_BULLET):
		SignalManager.on_player_hit.emit(area.get_damage())
