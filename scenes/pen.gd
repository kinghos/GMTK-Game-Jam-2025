extends Node2D
class_name Pen

var is_mouse_over: bool = false

var animals_in_auto_kick_area: Array[BaseAnimal]
var animals_in_pen_enclosure: Array[BaseAnimal]
@onready var animals_count_label: Label = $AnimalsCount
@onready var animal_icon: TextureRect = $PenEnclosure/AnimalIcon

@export var max_animals: int
@export_enum("Sheep", "Cow", "Chicken") var animal_type: String

const ANIMAL_ICONS = {
	"Cow": preload("res://assets/graphics/sprites/cow_icon.png"),
	"Sheep": preload("res://assets/graphics/sprites/sheep_icon.png"),
	"Chicken": preload("res://assets/graphics/sprites/sheep_icon.png")
}

func _ready() -> void:
	animal_icon.texture = ANIMAL_ICONS[animal_type]

func is_full() -> bool:
	return len(animals_in_pen_enclosure) >= max_animals

func _process(_delta: float) -> void:
	animals_count_label.text = str(len(animals_in_pen_enclosure)) + " / " + str(max_animals)

func _on_instant_kick_area_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_auto_kick_area.append(body)

func _on_instant_kick_area_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_auto_kick_area.erase(body)

func _on_pen_enclosure_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.append(body)
		body.in_pen = true

func _on_pen_enclosure_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.erase(body)
		body.in_pen = false

func _on_pen_enclosure_mouse_entered() -> void:
	is_mouse_over = true

func _on_pen_enclosure_mouse_exited() -> void:
	is_mouse_over = false
