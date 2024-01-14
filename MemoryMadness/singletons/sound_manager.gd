extends Node
## SoundManager : sound_manager.gd
##
## Singleton that manages playing sounds. This is where sound volumes (dB)
## could be managed.


const SOUND_MAIN_MENU = "main"
const SOUND_IN_GAME = "ingame"
const SOUND_SUCCESS = "success"
const SOUND_GAME_OVER = "gameover"
const SOUND_SELECT_TILE = "tile"
const SOUND_SELECT_BUTTON = "button"

const PREFIX = "res://assets/sounds/"

const SOUNDS = {
	SOUND_MAIN_MENU: preload(PREFIX + "bgm_action_3.mp3"),
	SOUND_IN_GAME: preload(PREFIX + "bgm_action_4.mp3"),
	SOUND_SUCCESS: preload(PREFIX + "sfx_sounds_fanfare3.wav"),
	SOUND_GAME_OVER: preload(PREFIX + "sfx_sounds_powerup12.wav"),
	SOUND_SELECT_TILE: preload(PREFIX + "sfx_sounds_impact1.wav"),
	SOUND_SELECT_BUTTON: preload(PREFIX + "sfx_sounds_impact7.wav")
}


# Default volume (in decibels) for UI effects.
var _ui_volume: float = -20.0
var _music_volume: float = -20.0


func play_music(player: AudioStreamPlayer, key: String) -> void:
	player.set_volume_db(_music_volume)
	_play_sound(player, key)


func play_button_click(player: AudioStreamPlayer) -> void:
	player.set_volume_db(_ui_volume)
	_play_sound(player, SOUND_SELECT_BUTTON)


func play_tile_click(player: AudioStreamPlayer) -> void:
	player.set_volume_db(_ui_volume)
	_play_sound(player, SOUND_SELECT_TILE)


func _play_sound(player: AudioStreamPlayer, key: String) -> void:
	if !SOUNDS.has(key):
		return
	
	player.stop()
	player.stream = SOUNDS[key]
	player.play()
