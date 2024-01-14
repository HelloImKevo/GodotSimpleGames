extends TextureRect


## FrontSprite : front_sprite.gd


const SCALE_SMALL: Vector2 = Vector2(0.1, 0.1)
const SCALE_NORMAL: Vector2 = Vector2(1.0, 1.0)
const SPIN_TIME_RANGE: Vector2 = Vector2(1.0, 2.0)
const SCALE_TIME: float = 0.5


var initial_animation: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	_run_initial_animation()
	SignalManager.on_load_game_data_complete.connect(_on_load_game_data_complete)


func _run_initial_animation() -> void:
	initial_animation = get_tree().create_tween()
	initial_animation.set_loops()
	# This will produce sort of a "wiggle" effect.
	var radians: float = 0.6
	var duration: float = 0.4
	initial_animation.tween_property(self, "rotation", -radians, duration)
	initial_animation.tween_property(self, "rotation", radians, duration)


#############################
## Post-Load Functionality ##
#############################


func _on_load_game_data_complete() -> void:
	assert(ImageManager.is_data_loaded() == true)
	_run_me()


## Recursive: Infinitely re-creates a local tween for handling a randomized animation.
func _run_me() -> void:
	if initial_animation != null:
		initial_animation.kill()
		initial_animation = null
	
	var tween: Tween = get_tree().create_tween()
	# Using this approach will set static (fixed) properties for the Tween
	# instance, negating the effect of the "get random value" functions.
	# Alternatively, could come up with some "Tween Provider" construct.
	# tween.set_loops()
	tween.tween_callback(_set_random_image)
	tween.tween_property(self, "scale", SCALE_NORMAL, SCALE_TIME)
	tween.tween_property(self, "rotation",
		_get_random_rotation(),
		_get_random_spin_time())
	tween.tween_property(self, "rotation",
		_get_random_rotation(),
		_get_random_spin_time())
	tween.tween_property(self, "scale", SCALE_SMALL, SCALE_TIME)
	tween.tween_callback(_run_me)


func _set_random_image() -> void:
	texture = ImageManager.get_random_item_image().item_texture


func _get_random_spin_time() -> float:
	return randf_range(SPIN_TIME_RANGE.x, SPIN_TIME_RANGE.y)


func _get_random_rotation() -> float:
	return deg_to_rad(randf_range(-360, 360))
