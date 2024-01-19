extends Node
## SoundManager : sound_manager.gd
##
## Singleton that manages playing sounds. This is where sound volumes (dB)
## can be managed.

const SOUND_LASER = "laser"
const SOUND_CHECKPOINT = "checkpoint"
const SOUND_DAMAGE = "damage"
const SOUND_KILL = "kill"
const SOUND_GAMEOVER = "gameover1"
const SOUND_IMPACT = "impact"
const SOUND_LAND = "land"
const SOUND_MUSIC1 = "music1"
const SOUND_MUSIC2 = "music2"
const SOUND_PICKUP = "pickup"
const SOUND_BOSS_ARRIVE = "boss_arrive"
const SOUND_JUMP = "jump"
const SOUND_WIN = "win"

const PREFIX = "res://assets/sound/"

var SOUNDS = {
	SOUND_CHECKPOINT: preload(PREFIX + "checkpoint.wav"),
	SOUND_DAMAGE: preload(PREFIX + "damage.wav"),
	SOUND_KILL: preload(PREFIX + "pickup5.ogg"),
	SOUND_GAMEOVER: preload(PREFIX + "game_over.ogg"),
	SOUND_IMPACT: preload(PREFIX + "impact.wav"),
	SOUND_JUMP: preload(PREFIX + "jump.wav"),
	SOUND_LAND: preload(PREFIX + "land.wav"),
	SOUND_LASER: preload(PREFIX + "laser.wav"),
	SOUND_MUSIC1: preload(PREFIX + "Farm Frolics.ogg"),
	SOUND_MUSIC2: preload(PREFIX + "Flowing Rocks.ogg"),
	SOUND_PICKUP: preload(PREFIX + "pickup5.ogg"),
	SOUND_BOSS_ARRIVE: preload(PREFIX + "boss_arrive.wav"),
	SOUND_WIN: preload(PREFIX + "you_win.ogg")
}

# Default volume (in decibels) for music.
var _music_volume: float = -20.0
# Default volume (in decibels) for UI and sound effects.
var _ui_volume: float = -20.0
# Volume for sound effects that are very quiet.
var _amp_volume: float = -5.0


func play_music(player: AudioStreamPlayer, key: String) -> void:
	if !SOUNDS.has(key):
		return
	
	_play(player, key, _music_volume)


func play_sfx(player: AudioStreamPlayer2D, key: String) -> void:
	if !SOUNDS.has(key):
		return
	
	var volume: float
	if key == SOUND_LAND:
		volume = _amp_volume
	else:
		volume = _ui_volume
	_play(player, key, volume)


func _play(player: Node, key: String, volume: float) -> void:
	assert((player is AudioStreamPlayer) or (player is AudioStreamPlayer2D))
	player.stop()
	player.set_volume_db(volume)
	player.stream = SOUNDS[key]
	player.play()
