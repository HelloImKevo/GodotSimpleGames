class_name Powerup
extends Area2D
## Powerup : A collectible that can be picked up by the player for a bonus.


const SPEED: float = 100.0

@onready var sprite_2d = $Sprite2D
@onready var sound = $Sound

var _powerup_type: GameData.POWERUP_TYPE = GameData.POWERUP_TYPE.HEALTH


func _ready():
	set_powerup_type(_powerup_type)
	sprite_2d.texture = GameData.POWER_UPS[_powerup_type]
	SoundManager.play_powerup_deploy_sound(sound)


func _process(delta):
	position.y += SPEED * delta


func set_powerup_type(pu: GameData.POWERUP_TYPE) -> void:
	_powerup_type = pu


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(_area):
	SignalManager.on_powerup_hit.emit(_powerup_type)
	queue_free()
