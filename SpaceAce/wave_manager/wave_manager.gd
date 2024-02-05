extends Node2D
## WaveManager : Collection of Paths to spawn enemies.


const ANIM_FRAMES: Dictionary = {
	GameData.ENEMY_TYPE.ZIPPER: ["zipper_1", "zipper_2", "zipper_3"],
	GameData.ENEMY_TYPE.BIO: ["biomech_1", "biomech_2", "biomech_3", "biomech_4"],
	GameData.ENEMY_TYPE.BOMBER: ["bomber_1", "bomber_2", "bomber_3"]
}

const ENEMY_SCENES: Dictionary = {
	GameData.ENEMY_TYPE.ZIPPER: preload("res://enemies/enemy_zipper.tscn"),
	GameData.ENEMY_TYPE.BIO: preload("res://enemies/enemy_bio.tscn"),
	GameData.ENEMY_TYPE.BOMBER: preload("res://enemies/enemy_bomber.tscn")
}

const ENEMY_DATA = {
	GameData.ENEMY_TYPE.ZIPPER: { "speed": 0.10, "gap": 0.6, "min": 6, "max": 10},
	GameData.ENEMY_TYPE.BIO: { "speed": 0.08, "gap": 0.7, "min": 6, "max": 8},
	GameData.ENEMY_TYPE.BOMBER: { "speed": 0.07, "gap": 1.0, "min": 2, "max": 4}
}

@onready var paths = $Paths
@onready var spawn_timer = $SpawnTimer

var _paths_list: Array = []
var _speed_factor: float = 1.0
var _wave_count: int = 0
var _last_path_index: int = -1
var _wave_gap: float = 6.0


# Called when the node enters the scene tree for the first time.
func _ready():
	_paths_list = paths.get_children()
	spawn_wave()


func create_enemy(speed: float, anim_name: String, enemy_type: GameData.ENEMY_TYPE) -> EnemyBasic:
	var new_en: EnemyBasic = ENEMY_SCENES[enemy_type].instantiate()
	new_en.setup(speed, anim_name)
	return new_en


func update_speeds() -> void:
	if _wave_count % len(_paths_list) == 0 and _wave_count != 0:
		_speed_factor *= 1.05
		_wave_gap *= 0.95
		print("update_speeds(): _wave_count: %s _speed_factor: %.2f _wave_gap: %.2f" % [
			_wave_count, _speed_factor, _wave_gap
		])


func start_spawn_timer() -> void:
	spawn_timer.wait_time = _wave_gap
	spawn_timer.start()


func get_random_path_index() -> int:
	var index = randi_range(0, len(_paths_list) - 1)
	while index == _last_path_index:
		index = randi_range(0, len(_paths_list) - 1)
	_last_path_index = index
	return index


func spawn_wave() -> void:
	var path = _paths_list[get_random_path_index()]
	var enemy_type: GameData.ENEMY_TYPE = GameData.ENEMY_TYPE.values().pick_random()
	var anim = ANIM_FRAMES[enemy_type].pick_random()
	var spawn_data = ENEMY_DATA[enemy_type]
	
	for num in range(4):
		path.add_child(create_enemy(spawn_data.speed * _speed_factor, anim, enemy_type))
		# Use a coroutine to suspend execution of current function.
		# We need a 1-second pause between each enemy, so they don't spawn on
		# top of each other.
		await get_tree().create_timer(spawn_data.gap).timeout
	
	print("spawn_wave() spawned, waiting: %.2f" % [_wave_gap])
	_wave_count += 1
	await get_tree().create_timer(_wave_gap).timeout
	update_speeds()
	start_spawn_timer()


func _on_spawn_timer_timeout():
	spawn_wave()
