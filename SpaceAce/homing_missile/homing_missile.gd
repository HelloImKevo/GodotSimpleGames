class_name HomingMissile
extends Area2D
## HomingMissile : A missile that slowly rotates to follow the player's position.


const ROTATION_SPEED: float = 100.0
const SPEED: float = 40.0
const SCORE: int = 5

@onready var debug_label = $DebugLabel
@onready var body = $Body

var _player_ref: Player


func _ready():
	_player_ref = get_tree().get_first_node_in_group(GameData.GROUP_PLAYER)


func _process(delta):
	turn(delta)
	# We want to move the Homing Missile parent position (including collision shape,
	# debug label, and other children) according to the amount of transformation that's
	# been applied to the Body (Sprite, Collision, and Particles).
	position += body.transform.x.normalized() * SPEED * delta
	update_debug_label()


func update_debug_label() -> void:
	if Engine.get_physics_frames() % 4 == 0:
		# To prevent a jittery label, only update once every 4 physics frames.
		debug_label.text = "Angle: %.1f \n pos: ( %.1f, %.1f )" % [
			body.rotation_degrees,
			position.x,
			position.y
		]


func get_angle_to_player() -> float:
	if not is_instance_valid(_player_ref):
		return 0.0
	
	return rad_to_deg((_player_ref.global_position - body.global_position).angle())


func get_angle_to_turn(angle_to_player: float) -> float:
	return fmod((angle_to_player - body.global_rotation_degrees + 180.0), 360.0) - 180.0


func turn(delta: float) -> void:
	var angle_to_player = get_angle_to_player()
	var angle_to_turn = get_angle_to_turn(angle_to_player)
	
	if abs(angle_to_turn) < 180.0:
		body.rotation_degrees += signf(angle_to_turn) * delta * ROTATION_SPEED
	else:
		body.rotation_degrees += signf(angle_to_turn) * -1 * delta * ROTATION_SPEED


func _on_body_area_entered(area):
	print("MISSILE - ON AREA ENTERED")
	blow_up()


func blow_up() -> void:
	ObjectMaker.create_explosion(global_position, get_tree().current_scene)
	set_process(false)
	ScoreManager.increment_score(SCORE)
	queue_free()
