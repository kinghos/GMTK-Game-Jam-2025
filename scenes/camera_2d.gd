extends Camera2D

func _ready() -> void:
	for bound: Marker2D in get_tree().get_nodes_in_group("CameraBounds"):
		var pos: float
		match bound.bound_type:
			"top":
				limit_top = bound.global_position.y
			"bottom":
				limit_bottom = bound.global_position.y
			"left":
				limit_left = bound.global_position.x
			"right":
				limit_right = bound.global_position.x
