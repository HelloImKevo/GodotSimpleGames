extends Node
## SoundManager : Manages playing sound effects and music.


const DOOR_OPEN_SOUND = preload("res://assets/sounds/misc/sci-fi-door.wav")
const POWER_UP_DEPLOY = preload("res://assets/sounds/powerup/power_up_deploy.wav")

const POWER_UP_SOUNDS: Dictionary = {
	GameData.POWERUP_TYPE.HEALTH: preload("res://assets/sounds/powerup/health_16.wav"),
	GameData.POWERUP_TYPE.SHIELD: preload("res://assets/sounds/powerup/shield_18.wav")
}

var EXPLOSION_SOUNDS: Array = []
var LASER_SOUNDS: Array = []

# Default volume (in decibels) for music.
var _music_volume: float = -20.0
# Default volume (in decibels) for UI and sound effects.
var _sfx_volume: float = -20.0


func make_explosion_sound(file_num: int) -> String:
	return "res://assets/sounds/explosions/sfx_exp_medium%s.wav" % file_num


func make_laser_sound(file_num: int) -> String:
	return "res://assets/sounds/lasers/sfx_wpn_laser%s.wav" % file_num


func _ready():
	for i in range(1, 14):
		EXPLOSION_SOUNDS.append(load(make_explosion_sound(i)))
		
	for i in range(1, 13):
		LASER_SOUNDS.append(load(make_laser_sound(i)))


func get_random_sound_from_list(sound_list: Array):
	return sound_list.pick_random()


func play_explosion_random(audio: AudioStreamPlayer2D):
	play_random_sound_from_list(audio, EXPLOSION_SOUNDS)


func play_laser_random(audio: AudioStreamPlayer2D):
	play_random_sound_from_list(audio, LASER_SOUNDS)


func get_sound(file_num: int, sound_list: Array):
	return sound_list[file_num - 1]


func play_random_sound_from_list(audio: AudioStreamPlayer2D, sound_list: Array):
	audio.volume_db = _sfx_volume
	audio.stream = get_random_sound_from_list(sound_list)
	audio.play()


func play_power_up_sound(pu_type: GameData.POWERUP_TYPE, audio: AudioStreamPlayer2D):
	audio.volume_db = _sfx_volume
	audio.stream = POWER_UP_SOUNDS[pu_type]
	audio.play()


func play_powerup_deploy_sound(audio: AudioStreamPlayer2D):
	audio.volume_db = _sfx_volume
	audio.stream = POWER_UP_DEPLOY
	audio.play()
