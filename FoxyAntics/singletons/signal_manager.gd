extends Node
## SignalManager : signal_manager.gd
##
## Singleton with signals that can be observed by game entities.

## Fired when an enemy is killed by a projectile.
signal on_enemy_killed(points: int, enemy_position: Vector2)
signal on_pickup_hit(points: int)
signal on_boss_killed(points: int)
signal on_player_hit(remaining_hit_points: int)
signal on_level_complete(level: int)
signal on_game_over
signal on_score_updated


func _to_string() -> String:
	return "SignalManager"
