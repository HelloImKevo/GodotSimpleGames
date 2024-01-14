class_name MemoryTile
extends TextureButton
## MemoryTile : memory_tile.gd


@onready var frame_image = $FrameImage
@onready var item_image = $ItemImage

var _item_name: String
var _can_select_me: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_selection_disabled.connect(_on_selection_disabled)
	SignalManager.on_selection_enabled.connect(_on_selection_enabled)


func get_item_name() -> String:
	return _item_name


func setup(ii_dict: Dictionary, fi: CompressedTexture2D) -> void:
	frame_image.texture = fi
	item_image.texture = ii_dict.item_texture
	_item_name = ii_dict.item_name
	reveal(false)


func reveal(r: bool) -> void:
	frame_image.visible = r
	item_image.visible = r


func _on_selection_disabled() -> void:
	_can_select_me = false


func _on_selection_enabled() -> void:
	_can_select_me = true


func _on_pressed():
	if _can_select_me:
		reveal(true)
