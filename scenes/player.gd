extends CharacterBody2D
class_name Player

@export var speed = 400

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var lasso_start: Marker2D = $LassoStart

var animals_in_range: Array[BaseAnimal]

func _ready() -> void:
	Globals.player = self

func _process(_delta: float) -> void:
	if get_global_mouse_position().x > global_position.x:
		if animated_sprite_2d.flip_h:
			lasso_start.position = Vector2(26, 16)
		else:
			lasso_start.position = Vector2(22, 12)
	if get_global_mouse_position().x < global_position.x:
		if animated_sprite_2d.flip_h:
			lasso_start.position = Vector2(-18, 12)
		else:
			lasso_start.position = Vector2(-22, 16)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	velocity = speed * direction
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Kick"):
		for animal in animals_in_range:
			if !animal.being_kicked and animal.being_stunned:
				animal.stun_timer.stop()
				animal._on_stun_timer_timeout()
				animal.kick()
