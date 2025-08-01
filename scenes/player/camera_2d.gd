extends Camera2D

func _ready() -> void:
	for bound: Marker2D in get_tree().get_nodes_in_group("CameraBounds"):
		match bound.bound_type:
			"top":
				limit_top = int(bound.global_position.y)
			"bottom":
				limit_bottom = int(bound.global_position.y)
			"left":
				limit_left = int(bound.global_position.x)
			"right":
				limit_right = int(bound.global_position.x)
