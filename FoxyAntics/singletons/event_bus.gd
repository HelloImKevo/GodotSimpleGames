extends Node
## EventBus : event_bus.gd
##
## Gateway for handling incoming events and determining when and where
## to relay them as outgoing messages and signals.

const _enabled = true


func _to_string() -> String:
	return "EventBus"


## Invoke when an enemy was killed by a player projectile.
func on_enemy_killed(enemy: EnemyBase) -> void:
	print(_to_string(), " => on_enemy_killed: %s" % [enemy])
	SignalManager.on_enemy_killed.emit(enemy.points, enemy.global_position)


func on_pickup_collected(pickup: FruitPickup) -> void:
	print(_to_string(), " => on_pickup_collected: %s" % [pickup])
	SignalManager.on_pickup_hit.emit(pickup.POINTS)


func on_player_hit(remaining_hit_points: int) -> void:
	print(_to_string(), " => on_player_hit => remaining_hit_points: %s" % [remaining_hit_points])
	SignalManager.on_player_hit.emit(remaining_hit_points)


func on_level_complete(level: int) -> void:
	print(_to_string(), " => on_level_complete: %s" % [level])
	SignalManager.on_level_complete.emit(level)


func on_game_over() -> void:
	print(_to_string(), " => on_game_over")
	SignalManager.on_game_over.emit()


func emit_global_event(msg: String) -> void:
	if _enabled:
		print(_to_string(), " => Received a global event: %s" % [msg])
	
	pass
