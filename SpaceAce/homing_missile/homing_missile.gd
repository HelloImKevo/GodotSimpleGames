class_name HomingMissile
extends Area2D
## HomingMissile : A missile that slowly rotates to follow the player's position.


@onready var debug_label = $DebugLabel
@onready var body = $Body


func _ready():
	pass # Replace with function body.


func _process(delta):
	body.rotation_degrees += 10 * delta
	debug_label.text = "Angle: %.2f" % [body.rotation_degrees]
