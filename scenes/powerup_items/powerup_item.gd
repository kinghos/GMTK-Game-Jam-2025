extends Area2D

class_name PowerupItem

enum POWERUP_ITEM_TYPE {
	SPEED
}

const POWERUP_ITEM_ICONS = {
	POWERUP_ITEM_TYPE.SPEED: preload("res://assets/graphics/powerups/items/speed.png")
}

var type: POWERUP_ITEM_TYPE
@onready var sprite = $Sprite2D

static func create_powerup_item(pen: Pen) -> PowerupItem:
	var powerup_item_scene: PackedScene = load("res://scenes/powerup_items/powerup_item.tscn")
	var new_powerup_item: PowerupItem = powerup_item_scene.instantiate()
	new_powerup_item.name = "Powerup Item"
	new_powerup_item.type = POWERUP_ITEM_TYPE.keys()[randi() % POWERUP_ITEM_TYPE.size()]
	new_powerup_item.global_position = pen.global_position
	return new_powerup_item

func _ready():
	sprite.texture = POWERUP_ITEM_ICONS[type]

func spawn(pen: Pen):
	var spawn_pos = pen.get_random_point()
	var tween = create_tween()
	tween.tween_property(self, "global_position", spawn_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
