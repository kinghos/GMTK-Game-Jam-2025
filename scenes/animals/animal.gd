extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool
@export var kick_distance: float = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_kick_range_body_entered(body: Node2D) -> void:
	if body is Player:
		in_kick_range = true
		body.animals_in_range.append(self)

func _on_kick_range_body_exited(body: Node2D) -> void:
	if body is Player:
		in_kick_range = false
		body.animals_in_range.erase(self)

func kick():
	var closest = INF
	var closest_pen: Node2D
	var diff
	
	for pen: Node2D in get_tree().get_nodes_in_group("Pens"):
		diff = global_position.distance_to(pen.global_position)
		if diff < closest:
			closest_pen = pen
			closest = diff
			
	diff = global_position - closest_pen.global_position
	diff = diff.normalized() * kick_distance
	var end_pos = global_position - diff
	var tween = create_tween()
	animation_player.play("kicked")
	tween.tween_property(self, "global_position", end_pos, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
		
