extends Node2D
class_name Pen

var animals_in_area: Array[BaseAnimal]

func _on_instant_kick_area_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		print("animal entered")
		animals_in_area.append(body)


func _on_instant_kick_area_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		print("animal left")
		animals_in_area.erase(body)
