extends Node
## SignalManager : signal_manager.gd
##
## Singleton with signals that can be observed by game entities.

## Fired when an enemy is hit by a projectile.
signal on_enemy_hit(points: int, enemy_position: Vector2)


func _to_string() -> String:
	return "SignalManager"
