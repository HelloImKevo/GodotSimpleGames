extends Node
## SignalManager : signal_manager.gd
##
## Singleton with signals that can be observed by game entities.

## Fired when an enemy is killed by a projectile.
signal on_enemy_killed(points: int, enemy_position: Vector2)
signal on_pickup_hit(points: int)
signal on_boss_killed(points: int)


func _to_string() -> String:
	return "SignalManager"
