extends Node
## ObjectMaker : Factory responsible for instantiating and spawning projectiles.


enum BulletKey { PLAYER, ENEMY }

const BULLETS: Dictionary = {
	BulletKey.PLAYER: preload("res://bullets/bullet_player/bullet_player.tscn"),
	BulletKey.ENEMY: preload("res://bullets/bullet_enemy/bullet_enemy.tscn")
}

const EXPLOSION_SCENE: PackedScene = preload("res://enemy_explosion/enemy_explosion.tscn")


## Instantiate a new [BulletBase] with a starting position, direction and speed.
func create_bullet(start_pos: Vector2, dir: Vector2,
		speed: float, life_span: float, key: BulletKey) -> void:
	var new_bullet: BulletBase = BULLETS[key].instantiate()
	new_bullet.setup(dir, speed, life_span)
	new_bullet.global_position = start_pos
	_call_add_child(new_bullet)


## Instantiate a new [EnemyExplosion] with a starting position. It will automatically
## play its animation and sound effect, and then be destroyed.
func create_explosion(start_pos: Vector2) -> void:
	var new_explosion: EnemyExplosion = EXPLOSION_SCENE.instantiate()
	new_explosion.global_position = start_pos
	_call_add_child(new_explosion)


func _call_add_child(child_to_add: Node) -> void:
	call_deferred("_add_child_deferred", child_to_add)


func _add_child_deferred(child_to_add: Node) -> void:
	get_tree().root.add_child(child_to_add)
