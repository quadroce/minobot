extends "res://scripts/projectiles/projectile_base.gd"
## Proiettile lanciato dai nemici (verdura dello Chef Vegano e del boss).

func _ready() -> void:
	super._ready()
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(5, true) # enemy_projectiles
	set_collision_mask_value(1, true) # world
	set_collision_mask_value(2, true) # player


func _on_hit(target: Node) -> void:
	if target.has_method("take_hit"):
		target.take_hit(damage, global_position)
