extends Node
## SignalManager : Manages signals, of course.


signal on_powerup_hit(powerup: GameData.POWERUP_TYPE)
signal on_player_hit(dmg: int)
signal on_player_health_bonus(v: int)
signal on_player_died
signal on_score_updated(v: int)
