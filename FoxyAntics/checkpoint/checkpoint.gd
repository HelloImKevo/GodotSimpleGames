extends Area2D
## Checkpoint : An animated checkpoint flag that unfurls when the player
## defeats the [Boss].


const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var animation_tree = $AnimationTree
@onready var sound = $Sound


func _ready():
	SignalManager.on_boss_killed.connect(_on_boss_killed)


func _on_boss_killed(_points: int) -> void:
	# Play the "unfurl flag" animation from the start.
	animation_tree[TRIGGER_CONDITION] = true
	# Start listening for (detecting) collisions with the Player.
	# The Checkpoint is "reached" once the Player collides with the
	# flag, after the Boss has been killed.
	monitoring = true
	SoundManager.play_sfx(sound, SoundManager.SOUND_WIN)


func _on_area_entered(_area):
	EventBus.on_level_complete(GameManager.get_current_level())
