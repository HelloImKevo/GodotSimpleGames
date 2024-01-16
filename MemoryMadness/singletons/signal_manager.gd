extends Node


## SignalManager : signal_manager.gd


signal loading_game_data
signal on_load_game_data_complete

signal on_level_selected(level_num: int)
signal on_game_exit_pressed

signal on_selection_enabled
signal on_selection_disabled

signal on_tile_selected(tile: MemoryTile)

signal on_game_over(moves: int)
