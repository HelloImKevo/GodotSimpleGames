extends Node2D
## Level : A common Space Ace level.

@onready var music = $Music


func _ready():
	music.volume_db = SoundManager.get_sfx_volume()
	ScoreManager.reset_score()
	SignalManager.on_player_died.connect(on_player_died)


func _process(_delta):
	if Input.is_key_pressed(KEY_Q):
		GameManager.load_main_scene()
	if Input.is_action_just_pressed("test"):
		ObjectMaker.create_powerup(Vector2(200.0, 200.0), GameData.POWERUP_TYPE.SHIELD)


func on_player_died() -> void:
	music.stop()
	for node in get_children():
		if is_instance_valid(node) and node.is_class("Node2D"):
			ObjectMaker.create_explosion(
				node.global_position,
				self
			)
			node.queue_free()
