extends Camera2D

func _ready() -> void:
	for bound: Marker2D in get_tree().get_nodes_in_group("CameraBounds"):
		var pos: float
		match bound.bound_type:
			"top":
				pos = bound.global_position.y
				limit_top = pos
			"bottom":
				pos = bound.global_position.y
				limit_bottom = pos
			"left":
				pos = bound.global_position.x
				limit_left = pos
			"right":
				pos = bound.global_position.x
				limit_right = pos
