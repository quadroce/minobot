extends "res://scripts/projectiles/projectile_base.gd"
## Proiettile lanciato da Minobot (palla da rugby / salame / Grana Padano).
## Le tre armi condividono questo script: cambiano solo i valori esportati
## impostati nella relativa scena.

func _ready() -> void:
	super._ready()
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(4, true) # player_projectiles
	set_collision_mask_value(1, true) # world
	set_collision_mask_value(3, true) # enemies


func _on_hit(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
