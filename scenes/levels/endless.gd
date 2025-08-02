extends Level

@onready var animals_parent: Node = $Animals

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
	super()
	print("Animals in pen %s" % (animal_numbers["Sheep"] * Globals.endless_mult))
	generate_animals()

func generate_animals():
	for animal: String in animal_numbers:
		var num_animals = int(animal_numbers[animal] * Globals.endless_mult)
		for i in range(num_animals):
			var new_animal: BaseAnimal = animal_scenes[animal].instantiate()
			if randi() % 2 == 0:
				new_animal.global_position = Vector2(randi_range(upper_bounds[0][0], upper_bounds[0][1]), randi_range(upper_bounds[1][0], upper_bounds[1][1]))
			else:
				new_animal.global_position = Vector2(randi_range(lower_bounds[0][0], lower_bounds[0][1]), randi_range(lower_bounds[1][0], lower_bounds[1][1]))
			var ani_name = animal
			if ani_name != "Sheep":
				ani_name += "s"
			animals_parent.get_node(ani_name).add_child(new_animal)

func _on_overlay_powerup_selected() -> void:
	Globals.endless_mult *= 1.5
	super()
