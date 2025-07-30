extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool

func _on_kick_range_body_entered(body: Node2D) -> void:
	in_kick_range = true


func _on_kick_range_body_exited(body: Node2D) -> void:
	in_kick_range = false
