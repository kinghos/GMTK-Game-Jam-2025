extends Level

@onready var animals_parent: Node = $Animals

var animal_numbers = {
	"Chicken": 12,
	"Cow": 12,
	"Sheep": 12,
}
var upper_bounds = [[-497, 2418], [-224, 216]] # [xmin, xmax], [ymin, ymax]
var lower_bounds = [[-497, 2418], [842, 1310]] # [xmin, xmax], [ymin, ymax]

var animal_scenes = {
	"Chicken": preload("res://scenes/animals/chicken.tscn"),
	"Cow": preload("res://scenes/animals/cow.tscn"),
	"Sheep": preload("res://scenes/animals/sheep.tscn")
}

var scaling_mult = 1.5

func _ready() -> void:
	super()
	generate_animals()

func generate_animals():
	for animal: String in animal_numbers:
		for i in range(animal_numbers[animal]):
			var new_animal: BaseAnimal = animal_scenes[animal].instantiate()
			if randi() % 2 == 0:
				new_animal.global_position = Vector2(randi_range(upper_bounds[0][0], upper_bounds[0][1]), randi_range(upper_bounds[1][0], upper_bounds[1][1]))
			else:
				new_animal.global_position = Vector2(randi_range(lower_bounds[0][0], lower_bounds[0][1]), randi_range(lower_bounds[1][0], lower_bounds[1][1]))
			var ani_name = animal
			if ani_name != "Sheep":
				ani_name += "s"
			animals_parent.get_node(ani_name).add_child(new_animal)
