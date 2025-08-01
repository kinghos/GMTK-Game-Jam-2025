extends Node2D
class_name Pen

var is_mouse_over: bool = false

var animals_in_kick_area: Array[BaseAnimal]
var animals_in_pen_enclosure: Array[BaseAnimal]
@onready var animals_count_label: Label = $AnimalsCount
@onready var animal_icon: TextureRect = $PenEnclosure/AnimalIcon

@export var max_animals: int
@export_enum("Sheep", "Cow", "Chicken") var animal_type: String

const ANIMAL_ICONS = {
	"Cow": preload("res://assets/graphics/animals/cow_icon.png"),
	"Sheep": preload("res://assets/graphics/animals/sheep_icon.png"),
	"Chicken": preload("res://assets/graphics/animals/chicken_icon.png")
}

func _draw():
	draw_circle($KickArea/CollisionShape2D.position, Globals.pen_kick_area, Color.RED, false, 2.0, true)

func _ready() -> void:
	animal_icon.texture = ANIMAL_ICONS[animal_type]

func is_full() -> bool:
	return len(animals_in_pen_enclosure) >= max_animals

func _process(_delta: float) -> void:
	var correct_animal_count: int = 0
	for animal in animals_in_pen_enclosure:
		if animal.type == animal_type:
			correct_animal_count += 1
	animals_count_label.text = str(correct_animal_count) + " / " + str(max_animals)
	$KickArea/CollisionShape2D.shape.set_radius(Globals.pen_kick_area)

func _on_kick_area_body_entered(body: Node2D) -> void:
	if body is BaseAnimal and body.type == animal_type:
		animals_in_kick_area.append(body)
		body.is_in_kick_area = true
		body.toggle_kick_icon()

func _on_kick_area_body_exited(body: Node2D) -> void:
	if body is BaseAnimal and body.type == animal_type:
		animals_in_kick_area.erase(body)
		body.is_in_kick_area = true
		body.toggle_kick_icon()

func _on_pen_enclosure_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.append(body)
		body.in_pen = true
		if body.type != animal_type:
			body.in_wrong_pen = true
			body.kick()
		else:
			body.toggle_kick_icon()

func _on_pen_enclosure_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		if body.type != animal_type:
			body.in_wrong_pen = false
		animals_in_pen_enclosure.erase(body)
		body.in_pen = false

func _on_pen_enclosure_mouse_entered() -> void:
	is_mouse_over = true

func _on_pen_enclosure_mouse_exited() -> void:
	is_mouse_over = false
