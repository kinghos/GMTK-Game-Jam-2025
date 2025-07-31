extends Node2D
class_name Pen

var animals_in_auto_kick_area: Array[BaseAnimal]
var animals_in_pen_enclosure: Array[BaseAnimal]

func _on_instant_kick_area_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_auto_kick_area.append(body)


func _on_instant_kick_area_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_auto_kick_area.erase(body)


func _on_pen_enclosure_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.append(body)


func _on_pen_enclosure_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.erase(body)
		
