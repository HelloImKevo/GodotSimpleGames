extends Node2D
## WaveManagerRes : Collection of Paths to spawn enemies.


var wave_list: WaveListResource = preload("res://wave_resources/wave_list.tres")

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

@onready var paths = $Paths
@onready var spawn_timer = $SpawnTimer

var _paths_list: Array = []
var _wave_count: int = 0
var _last_path_index: int = -1

var logger = LogStream.new(_to_string(), LogStream.LogLevel.DEBUG)


func _to_string() -> String:
	return "WaveManagerRes"


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
		wave_list.speed_factor *= 1.05
		wave_list.wave_gap *= 0.95
		logger.warn("update_speeds(): _wave_count: %s _speed_factor: %.2f _wave_gap: %.2f" % [
			_wave_count, wave_list.speed_factor, wave_list.wave_gap
		])


func start_spawn_timer() -> void:
	spawn_timer.wait_time = wave_list.wave_gap
	spawn_timer.start()


func get_random_path_index() -> int:
	var index = randi_range(0, len(_paths_list) - 1)
	while index == _last_path_index:
		index = randi_range(0, len(_paths_list) - 1)
	_last_path_index = index
	return index


func spawn_wave() -> void:
	var path = _paths_list[get_random_path_index()]
	var wave_res: WaveResource = wave_list.get_next_wave()
	var enemy_type = wave_res.enemy_type
	var anim = ANIM_FRAMES[enemy_type].pick_random()
	
	for num in range(randi_range(wave_res.min, wave_res.max)):
		path.add_child(create_enemy(wave_res.speed * wave_list.speed_factor, anim, enemy_type))
		# Use a coroutine to suspend execution of current function.
		# We need a 1-second pause between each enemy, so they don't spawn on
		# top of each other.
		await get_tree().create_timer(wave_res.gap).timeout
	
	logger.info("spawn_wave() spawned, waiting: %.2f" % [wave_list.wave_gap])
	_wave_count += 1
	await get_tree().create_timer(wave_list.wave_gap).timeout
	update_speeds()
	start_spawn_timer()


func _on_spawn_timer_timeout():
	spawn_wave()
