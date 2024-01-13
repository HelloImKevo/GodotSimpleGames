extends Node2D


var animal_scene: PackedScene = preload("res://animal/animal.tscn")


@onready var debug_label = $PContainer/MContainer/DebugVBox/DebugLabel
@onready var animal_start = $AnimalStart


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_update_debug_label.connect(on_update_debug_label)
	SignalManager.on_animal_died.connect(on_animal_died)
	on_animal_died()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_key_pressed(KEY_Q) == true:
		GameManager.load_main_scene()


func on_update_debug_label(text: String) -> void:
	debug_label.text = text


func on_animal_died() -> void:
	var animal = animal_scene.instantiate()
	animal.global_position = animal_start.global_position
	add_child(animal)
