extends Area2D
class_name Pickup
## Collezionabile raccolto a contatto con Minobot. Il tipo determina
## l'effetto applicato tramite Game (autoload); riusato per birra, salame,
## palla da rugby e Grana Padano cambiando solo "kind" nella scena.

enum Kind { BEER, SALAMI, RUGBY_BALL, GRANA_PADANO }

@export var kind: Kind = Kind.BEER
@export var score_value: int = 10


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true) # player
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("take_hit"):
		return
	match kind:
		Kind.BEER:
			Game.activate_speed_boost()
		Kind.SALAMI:
			Game.add_ammo(&"salami", 1)
		Kind.RUGBY_BALL:
			pass # il pickup vale solo punteggio, la palla resta un'arma illimitata
		Kind.GRANA_PADANO:
			Game.add_ammo(&"grana", 1)
	Game.add_score(score_value)
	queue_free()
