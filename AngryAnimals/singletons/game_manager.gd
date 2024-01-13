extends Node


## GameManager : game_manager.gd
##
## Created by right-clicking on the 'singletons' dir, and clicking
## 'Create Script'. Then, under Project Settings, select the Autoload tab.
## Then choose the game_manager.gd file, and name the Node 'GameManager'
## and finally click the [ADD] button. By default the 'Global Variable'
## checkbox will already be checked.


var main_scene: PackedScene = preload("res://main/main.tscn")


## Node Group for the "Cup" target, used for Animal collision detection.
const GROUP_CUP: String = "cup"
## Node Group for the player "Animal", used for Water Splash collision detection.
const GROUP_ANIMAL: String = "animal"


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
