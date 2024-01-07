extends CharacterBody2D


signal on_plane_died


@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D


const GRAVITY: float = 1900.0
const POWER: float = -400.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	fly()
	
	move_and_slide()
	
	if is_on_floor() == true:
		die()


func fly() -> void:
	if Input.is_action_just_pressed("fly") == true:
		velocity.y = POWER
		animation_player.play("fly")


func die() -> void:
	animated_sprite_2d.stop()
	# Notify observers that the Plane has died.
	on_plane_died.emit()
	# Stop physics engine for the Plane.
	set_physics_process(false)
