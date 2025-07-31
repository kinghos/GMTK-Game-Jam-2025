extends Node

var player_lasso_reach = 200

var pause_menu: CanvasLayer = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		toggle_pause_menu()

func toggle_pause_menu():
	if pause_menu:
		var is_visible = pause_menu.visible
		pause_menu.visible = not is_visible
		get_tree().paused = not is_visible
