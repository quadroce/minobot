extends Node2D
## Ripete una texture di sfondo in orizzontale per coprire una zona del
## livello, invece di stirarla su tutta la larghezza (che la sgranerebbe).
## Scala minima necessaria per raggiungere target_height + filtro lineare,
## cosi' lo sfondo resta nitido anche se non e' pixel art 1:1.

@export var texture: Texture2D
@export var zone_width: float = 900.0
@export var target_height: float = 240.0


func _ready() -> void:
	if texture == null:
		return
	var scale_factor := target_height / texture.get_height()
	var tile_width := texture.get_width() * scale_factor
	var tile_count := int(ceil(zone_width / tile_width)) + 1
	var start_x := -zone_width / 2.0
	for i in range(tile_count):
		var tile := Sprite2D.new()
		tile.texture = texture
		tile.centered = false
		tile.scale = Vector2(scale_factor, scale_factor)
		tile.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		tile.position = Vector2(start_x + i * tile_width, 0.0)
		add_child(tile)
