extends Node2D
class_name Pen

var is_mouse_over: bool = false

var animals_in_kick_area: Array[BaseAnimal]
var animals_in_pen_enclosure: Array[BaseAnimal]
@onready var animals_count_label: Label = $AnimalsCount
@onready var animal_icon: TextureRect = $PenEnclosure/AnimalIcon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cross: Sprite2D = $Cross
@onready var tick: Sprite2D = $Tick

@export var max_animals: int
@export_enum("Sheep", "Cow", "Chicken") var animal_type: String

const ANIMAL_ICONS = {
	"Cow": preload("res://assets/graphics/animals/cow_icon.png"),
	"Sheep": preload("res://assets/graphics/animals/sheep_icon.png"),
	"Chicken": preload("res://assets/graphics/animals/chicken_icon.png")
}

@onready var kick_area_mask: TextureRect = $KickAreaMask

func _ready() -> void:
	animal_icon.texture = ANIMAL_ICONS[animal_type]
	tick.hide()

func is_full() -> bool:
	return len(animals_in_pen_enclosure) >= max_animals and not (animation_player.current_animation == "tick" and animation_player.is_playing())

func _process(_delta: float) -> void:
	var radius = Globals.pen_kick_area
	kick_area_mask.position = $KickArea/CollisionShape2D.position - Vector2(radius, radius)
	kick_area_mask.size = Vector2(radius * 2, radius * 2)	
	
	var correct_animal_count: int = 0
	for animal in animals_in_pen_enclosure:
		if animal.type == animal_type:
			correct_animal_count += 1
	if correct_animal_count > 0:
		animal_icon.hide()
	animals_count_label.text = str(correct_animal_count) + " / " + str(max_animals)
	$KickArea/CollisionShape2D.shape.set_radius(Globals.pen_kick_area)

func _on_kick_area_body_entered(body: Node2D) -> void:
	if is_full():
		return
	if body is BaseAnimal and body.type == animal_type:
		animals_in_kick_area.append(body)
		body.is_in_kick_area = true
		body.toggle_kick_icon()

func _on_kick_area_body_exited(body: Node2D) -> void:
	if is_full():
		return
	if body is BaseAnimal and body.type == animal_type:
		animals_in_kick_area.erase(body)
		body.is_in_kick_area = false
		body.toggle_kick_icon()

func _on_pen_enclosure_body_entered(body: Node2D) -> void:
	if body is BaseAnimal:
		animals_in_pen_enclosure.append(body)
		body.in_pen = true
		if body.type != animal_type:
			body.in_wrong_pen = true
			animation_player.play("cross")
			body.kick()
			await animation_player.animation_finished
			animation_player.play_backwards("cross")
			cross.hide()
		else:
			Globals.add_time(body.type, body.combo_count)
			body.toggle_kick_icon()
			Globals.current_level.animals_on_screen.erase(body)
			
			var correct_animal_count: int = 0
			for animal in animals_in_pen_enclosure:
				if animal.type == animal_type:
					correct_animal_count += 1
			if correct_animal_count == max_animals:
				animation_player.play("tick")
				#if randi_range(0, 2) == 1:
					#var spawned_item = PowerupItem.create_powerup_item(self)
					#add_child(spawned_item)
					#spawned_item.spawn(self)

func _on_pen_enclosure_body_exited(body: Node2D) -> void:
	if body is BaseAnimal:
		if body.type != animal_type:
			body.in_wrong_pen = false
		animals_in_pen_enclosure.erase(body)
		body.in_pen = false

func get_random_point():
	var pen_center = global_position
	var kick_rect = get_node("KickArea/CollisionShape2D").shape.get_rect()
	var enclosure_rect = get_node("PenEnclosure/CollisionShape2D").shape.get_rect()
	var x = randi_range(-(kick_rect.size.x / 2), kick_rect.size.x / 2)
	var y = randi_range(-(kick_rect.size.y / 2), kick_rect.size.y / 2)
	var pos = Vector2(x, y)
	while true:
		x = randi_range(-(kick_rect.size.x / 2), kick_rect.size.x / 2)
		y = randi_range(-(kick_rect.size.y / 2), kick_rect.size.y / 2)
		pos = Vector2(pen_center.x + x, pen_center.y + y)
		if not enclosure_rect.has_point(pos):
			return pos

func _on_pen_enclosure_mouse_entered() -> void:
	is_mouse_over = true

func _on_pen_enclosure_mouse_exited() -> void:
	is_mouse_over = false
