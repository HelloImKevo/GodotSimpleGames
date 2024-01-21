extends Node
## EventBus : event_bus.gd
##
## Gateway for handling incoming events and determining when and where
## to relay them as outgoing messages and signals.

const _enabled = true


func _to_string() -> String:
	return "EventBus"


## Invoke when an enemy was hit by a player projectile.
func on_enemy_hit(enemy: EnemyBase) -> void:
	print(_to_string(), " => on_enemy_hit: %s" % [enemy])
	SignalManager.on_enemy_hit.emit(enemy.points, enemy.global_position)


func emit_global_event(msg: String) -> void:
	if _enabled:
		print(_to_string(), " => Received a global event: %s" % [msg])
	
	pass