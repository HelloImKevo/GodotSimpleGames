extends CanvasLayer


## MasterScene : master_scene.gd


@onready var loading_widget = $MC/LoadingWidget


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.loading_game_data.connect(_on_loading_game_data)
	SignalManager.on_load_game_data_complete.connect(_on_load_game_data_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


#region: Loading Game Data Events

func _on_loading_game_data() -> void:
	loading_widget.show()


func _on_load_game_data_complete() -> void:
	loading_widget.hide()

#endregion: Loading Game Data Events
