extends Level

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

func generate_animals():
	for animal: String in animal_numbers:
		var new_animal: BaseAnimal = animal_scenes[animal].instantiate()
		new_animal.global_position = Vector2(randi_range(upper_bounds[0][0], upper_bounds[0][1]), randi_range(upper_bounds[1][0], upper_bounds[1][1]))
		
