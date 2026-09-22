extends CharacterBody2D
class_name EnemyBase
## Base per tutti i nemici. Gestisce vita, gravita', pattuglia (avanti e
## indietro entro patrol_distance dal punto di partenza, inversione anche se
## urta un muro) e danno a contatto col giocatore. Le sottoclassi possono
## sovrascrivere _update_behavior() per comportamenti custom (carica,
## attacco a distanza, aura, ecc.).

@export var max_health: int = 1
@export var move_speed: float = 40.0
@export var damage_to_player: int = 1
@export var score_reward: int = 100
@export var patrols: bool = true
@export var patrol_distance: float = 80.0

var health: int
var direction: int = -1
var is_dead: bool = false
var _patrol_origin_x: float = 0.0

@onready var sprite: Sprite2D = $Sprite
@onready var _hit_area: Area2D = $HitArea
@onready var _wall_ray: RayCast2D = $WallRay


func _ready() -> void:
	health = max_health
	_patrol_origin_x = global_position.x
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(3, true) # enemies
	set_collision_mask_value(1, true) # world
	_hit_area.collision_layer = 0
	_hit_area.collision_mask = 0
	_hit_area.set_collision_mask_value(2, true) # player
	_hit_area.body_entered.connect(_on_hit_area_body_entered)


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if not is_on_floor():
		velocity.y += _get_gravity() * delta
	_update_behavior(delta)
	move_and_slide()


func _get_gravity() -> float:
	return ProjectSettings.get_setting("physics/2d/default_gravity", 900.0)


## Comportamento di default: pattuglia. Le sottoclassi lo sovrascrivono
## (e possono comunque chiamare _patrol() quando serve tornare al pattern base).
func _update_behavior(delta: float) -> void:
	if patrols:
		_patrol(delta)
	else:
		velocity.x = 0.0


func _patrol(_delta: float) -> void:
	velocity.x = direction * move_speed
	var traveled := global_position.x - _patrol_origin_x
	var reached_bound := (direction > 0 and traveled >= patrol_distance) or (direction < 0 and traveled <= -patrol_distance)
	if _wall_ray.is_colliding() or reached_bound:
		_face(-direction)


## Imposta la direzione e riorienta sprite + raycast del muro (il raycast
## resta fisso in locale, va ribaltato a mano ogni volta che la direzione
## cambia).
func _face(new_direction: int) -> void:
	direction = new_direction
	sprite.scale.x = abs(sprite.scale.x) * direction
	_wall_ray.target_position.x = abs(_wall_ray.target_position.x) * direction


func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	if health <= 0:
		_die()


func _die() -> void:
	is_dead = true
	Game.add_score(score_reward)
	queue_free()


func _on_hit_area_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.has_method("take_hit"):
		body.take_hit(damage_to_player, global_position)
