## If you need this to run again, uncomment the @tool annotation.
#@tool
class_name ImageFileMaker
extends Node


@export var image_resource: ImageFilesList


func _ready():
	load_item_images()


func load_item_images() -> void:
	if Engine.is_editor_hint():
		var path = "res://assets/glitch"
		var dir = DirAccess.open(path)
		
		if dir == null:
			print("ERROR: ", path)
			return
		
		image_resource.file_names.clear()
		
		var file_names = dir.get_files()
		
		for fn in file_names:
			if ".import" not in fn:
				image_resource.file_names.append(path + "/" + fn)
		
		ResourceSaver.save(image_resource)
