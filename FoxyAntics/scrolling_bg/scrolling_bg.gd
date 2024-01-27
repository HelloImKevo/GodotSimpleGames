extends ParallaxBackground
## ScrollingBg : Parallax background that supports different level themes.


@export_range(1, 4) var level_number: int
@export var mirror_x: float = 1440.0
@export var sprite_offset: Vector2 = Vector2(0.0, -540.0)
@export var sprite_scale: Vector2 = Vector2(0.75, 0.75)

const BG_FILES: Dictionary = {
	1: [
		preload("res://assets/backgrounds/game_background_1/layers/sky.png"),
		preload("res://assets/backgrounds/game_background_1/layers/clouds_1.png"),
		preload("res://assets/backgrounds/game_background_1/layers/clouds_2.png"),
		preload("res://assets/backgrounds/game_background_1/layers/clouds_3.png"),
		preload("res://assets/backgrounds/game_background_1/layers/clouds_4.png"),
		preload("res://assets/backgrounds/game_background_1/layers/rocks_1.png"),
		preload("res://assets/backgrounds/game_background_1/layers/rocks_2.png")
	],
	2: [
		preload("res://assets/backgrounds/game_background_2/layers/sky.png"),
		preload("res://assets/backgrounds/game_background_2/layers/birds.png"),
		preload("res://assets/backgrounds/game_background_2/layers/clouds_1.png"),
		preload("res://assets/backgrounds/game_background_2/layers/clouds_2.png"),
		preload("res://assets/backgrounds/game_background_2/layers/clouds_3.png"),
		preload("res://assets/backgrounds/game_background_2/layers/pines.png"),
		preload("res://assets/backgrounds/game_background_2/layers/rocks_1.png"),
		preload("res://assets/backgrounds/game_background_2/layers/rocks_2.png"),
		preload("res://assets/backgrounds/game_background_2/layers/rocks_3.png")
	],
	3: [
		preload("res://assets/backgrounds/game_background_3/layers/sky.png"),
		preload("res://assets/backgrounds/game_background_3/layers/clouds_1.png"),
		preload("res://assets/backgrounds/game_background_3/layers/clouds_2.png"),
		preload("res://assets/backgrounds/game_background_3/layers/rocks.png"),
		preload("res://assets/backgrounds/game_background_3/layers/ground_1.png"),
		preload("res://assets/backgrounds/game_background_3/layers/ground_3.png"),
		preload("res://assets/backgrounds/game_background_3/layers/ground_2.png"),
		preload("res://assets/backgrounds/game_background_3/layers/plant.png")
	],
	4: [
		preload("res://assets/backgrounds/game_background_4/layers/sky.png"),
		preload("res://assets/backgrounds/game_background_4/layers/clouds_1.png"),
		preload("res://assets/backgrounds/game_background_4/layers/clouds_2.png"),
		preload("res://assets/backgrounds/game_background_4/layers/ground.png"),
		preload("res://assets/backgrounds/game_background_4/layers/rocks.png")
	]
}


func _ready():
	add_backgrounds()


func get_increment() -> float:
	return 1.0 / BG_FILES[level_number].size()


func get_sprite(t: Texture2D) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = t
	sprite.scale = sprite_scale
	sprite.offset = sprite_offset
	return sprite


func add_layer(t: Texture2D, time_offset: float) -> void:
	var sprite = get_sprite(t)
	
	var par_layer = ParallaxLayer.new()
	par_layer.motion_mirroring = Vector2(mirror_x, 0.0)
	par_layer.motion_scale = Vector2(time_offset, 1.0)
	par_layer.add_child(sprite)
	
	# Add the Parallax Layer as a child to the [ParallaxBackground].
	add_child(par_layer)


func add_backgrounds() -> void:
	var inc: float = get_increment()
	var time_offset = inc
	var files_list: Array = BG_FILES[level_number]

	for index in range(files_list.size()):
		var bg_file = files_list[index]
		if index == 0:
			add_layer(bg_file, 0.1)
		else:
			add_layer(bg_file, time_offset)
			time_offset += inc
