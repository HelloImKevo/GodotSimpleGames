class_name Saucer
extends PathFollow2D
## Saucer : Large spinning enemy.


const SPEED: float = 0.08
const SHOOT_PROGRESS: float = 0.02
const FIRE_OFFSETS = [0.25, 0.5, 0.75]
const BOOM_DELAY: float = 0.2
const HIT_DAMAGE: int = 40

@onready var sound = $Sound
@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var health_bar = $HealthBar
@onready var booms = $Booms

var missile_scene: PackedScene = preload("res://homing_missile/homing_missile.tscn")

var _shooting: bool = false
var _shots_fired: int = 0


func _ready():
	sound.volume_db = SoundManager.get_sfx_volume()
	progress_ratio = 0.0


func _process(delta):
	if not _shooting:
		move_along_path(delta)
		try_shoot()


func move_along_path(delta: float) -> void:
	progress_ratio += SPEED * delta


func update_shots_fired() -> void:
	_shots_fired += 1
	if _shots_fired >= len(FIRE_OFFSETS):
		_shots_fired = 0


func try_shoot() -> void:
	if abs(progress_ratio - FIRE_OFFSETS[_shots_fired]) < SHOOT_PROGRESS:
		state_machine.travel("shoot")
		update_shots_fired()


func set_shooting(v: bool) -> void:
	_shooting = v


func shoot() -> void:
	var missile: HomingMissile = missile_scene.instantiate()
	get_tree().root.add_child(missile)
	missile.global_position = global_position


func die() -> void:
	queue_free()


func make_booms() -> void:
	for b in booms.get_children():
		ObjectMaker.create_boom(b.global_position)
		await get_tree().create_timer(BOOM_DELAY).timeout


func _on_health_bar_died():
	# We only want to observe this event once. After the enemy has died,
	# subsequent signals will be ignored.
	health_bar.disconnect("died", _on_health_bar_died)
	state_machine.travel("death")


func _on_area_2d_area_entered(area):
	health_bar.take_damage(HIT_DAMAGE)
