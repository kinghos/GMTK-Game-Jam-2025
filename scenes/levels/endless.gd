extends Level

@onready var animals_parent: Node = $Animals
@onready var animal_spawn_regions: Node2D = $AnimalSpawnRegions

var animal_numbers = {
	"Chicken": 6,
	"Cow": 6,
	"Sheep": 6
}
var upper_bounds = [[-497, 2418], [-224, 216]] # [xmin, xmax], [ymin, ymax]
var lower_bounds = [[-497, 2418], [842, 1310]] # [xmin, xmax], [ymin, ymax]

var animal_scenes = {
	"Chicken": preload("res://scenes/animals/chicken.tscn"),
	"Cow": preload("res://scenes/animals/cow.tscn"),
	"Sheep": preload("res://scenes/animals/sheep.tscn")
}

func _ready() -> void:
	for i in range(Globals.endless_rounds):
		Globals.endless_mult *= 1.5
		Globals.timer_mult *= 1.2
	game_timer.stop()
	game_timer.wait_time *= Globals.timer_mult
	game_timer.start()
	print("Animals in pen %s" % (animal_numbers["Sheep"] * Globals.endless_mult))
	generate_animals()
	generate_pens()
	super()

func generate_animals():
	for animal: String in animal_numbers:
		var num_animals = int(animal_numbers[animal] * Globals.endless_mult)
		for i in range(num_animals):
			var new_animal: BaseAnimal = animal_scenes[animal].instantiate()
			new_animal.global_position = get_random_region()
			var ani_name = animal
			if ani_name != "Sheep":
				ani_name += "s"
			animals_parent.get_node(ani_name).add_child(new_animal)

func _on_overlay_powerup_selected() -> void:
	Globals.endless_rounds += 1
	super()

func generate_pens():
	var first_cow = true
	var first_chicken = true
	var first_sheep = true
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		var num_animals = int(animal_numbers["Sheep"] * Globals.endless_mult)
		pen.max_animals = num_animals / 2
		var remainder = num_animals % 2
		if remainder:
			if first_cow and pen.animal_type == "Cow":
				pen.max_animals += 1
				first_cow = false
			if first_sheep and pen.animal_type == "Sheep":
				pen.max_animals += 1
				first_sheep = false
			if first_chicken and pen.animal_type == "Chicken":
				pen.max_animals += 1
				first_chicken = false

func get_random_region():
	var regions = animal_spawn_regions.get_children()
	var weight = randf()
	var node = regions.pick_random()
	var top_left: Vector2 = node.get_node("Top").global_position
	var bottom_right: Vector2 = node.get_node("Bottom").global_position
	var random_point = Vector2(
		randi_range(top_left.x, bottom_right.x),
		randi_range(top_left.y, bottom_right.y))
	return random_point
		
	


func _on_button_pressed() -> void:
	change_to_next_level()
