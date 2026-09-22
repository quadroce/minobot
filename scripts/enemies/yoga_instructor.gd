extends "res://scripts/enemies/enemy_base.gd"
## Istruttore di Yoga: fermo, emette un'aura che rallenta Minobot finche'
## resta nel raggio. Nessun danno diretto a contatto.

@onready var _aura_area: Area2D = $AuraArea


func _ready() -> void:
	super._ready()
	patrols = false
	damage_to_player = 0
	_aura_area.collision_layer = 0
	_aura_area.collision_mask = 0
	_aura_area.set_collision_mask_value(2, true) # player
	_aura_area.body_entered.connect(_on_aura_body_entered)
	_aura_area.body_exited.connect(_on_aura_body_exited)


func _update_behavior(_delta: float) -> void:
	velocity.x = 0.0


func _on_aura_body_entered(body: Node2D) -> void:
	if body.has_method("set_in_slow_aura"):
		body.set_in_slow_aura(true)


func _on_aura_body_exited(body: Node2D) -> void:
	if body.has_method("set_in_slow_aura"):
		body.set_in_slow_aura(false)


func _die() -> void:
	# Rilascia l'aura anche se l'istruttore viene eliminato mentre
	# Minobot e' ancora al suo interno.
	for body in _aura_area.get_overlapping_bodies():
		if body.has_method("set_in_slow_aura"):
			body.set_in_slow_aura(false)
	super._die()
