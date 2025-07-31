extends Node2D
class_name Pen

var animals_in_auto_kick_area: Array[BaseAnimal]
var animals_in_pen_enclosure: Array[BaseAnimal]
@export var max_animals: int
@onready var animals_count_label: Label = $AnimalsCount

func _process(delta: float) -> void:
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
		
