extends Node2D

@onready var game_ui: CanvasLayer = $GameUI
@onready var animals = $Animals
@onready var sheep = animals.get_node("Sheep")

@onready var pointer_scene: PackedScene = preload("res://scenes/ui/animal_pointer.tscn")
@onready var animal_pointers = game_ui.get_node("AnimalPointers")

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu
	
	for animal_type in animals.get_children():
		for animal in animal_type.get_children():
			var pointer = pointer_scene.instantiate()
			pointer.name = animal_type.name
			pointer.animal = animal_type.name
			pointer.target = animal
			animal_pointers.add_child(pointer, true)

func _on_button_pressed() -> void:
	game_ui.trigger_powerups_menu()
