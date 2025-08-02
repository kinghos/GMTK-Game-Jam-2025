extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool
var is_in_kick_area: bool
var being_kicked: bool
var being_stunned: bool
var in_pen: bool = false
var in_wrong_pen: bool = false
var combo_count: int = 1
var no_congratulation_this_kick: bool = false
var audio_dict = {
	"Cow": preload("res://assets/audio/sfx/moo.ogg"),
	"Sheep": preload("res://assets/audio/sfx/baa.ogg"),
	"Chicken": preload("res://assets/audio/sfx/cluck.ogg")
	
}


@export var speed = 75
@export_enum("Sheep", "Cow", "Chicken") var type: String

@onready var combo_counter: Label = $ComboCounter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kick_particles: CPUParticles2D = $KickParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var offscreen_pointer: Sprite2D = $OffscreenPointer
@onready var stun_timer: Timer = $StunTimer
@onready var random_movement_timer: Timer = $RandomMovementTimer
@onready var combo_animation_player: AnimationPlayer = $ComboCounter/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var direction

func _ready() -> void:
	stun_timer.wait_time = Globals.stun_time
	random_movement_timer.wait_time *= randf_range(0.8, 1.2)
	_on_random_movement_timer_timeout()
	random_movement_timer.start()
	audio_stream_player.stream.set_stream(0, audio_dict[type])
	
	

func _process(_delta: float) -> void:
	if is_in_kick_area:
		show_kick_icon()
	else:
		hide_kick_icon()
	if combo_count > Globals.max_combo:
		Globals.max_combo = combo_count
	if in_wrong_pen:
		no_congratulation_this_kick = true

func _physics_process(_delta: float) -> void:
	if being_stunned or being_kicked:
		return
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	# disable collision with other animals when in pen
	if in_pen:
		set_collision_mask_value(2, false)
	
	velocity = direction * speed
	
	# Bounce off collisions
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		
		if collider:
			_on_random_movement_timer_timeout()
	
	move_and_slide()

func _on_kick_range_body_entered(body: Node2D) -> void:
	if body is Player:
		in_kick_range = true
		body.animals_in_range.append(self)

func _on_kick_range_body_exited(body: Node2D) -> void:
	if body is Player:
		in_kick_range = false
		body.animals_in_range.erase(self)

func show_kick_icon():
	$KickIcon.visible = true

func hide_kick_icon():
	$KickIcon.visible = false

func kick():
	if in_pen and not in_wrong_pen:
		return
	being_kicked = true
	
	var end_pos: Vector2
	if in_wrong_pen:
		for pen: Pen in get_tree().get_nodes_in_group("Pens"):
			if self in pen.animals_in_pen_enclosure:
				end_pos = pen.get_random_point()
	else:
		var closest = INF
		var closest_pen: Pen
		var diff
		for pen: Pen in get_tree().get_nodes_in_group("Pens"):
			diff = global_position.distance_to(pen.global_position)
			if diff < closest and pen.animal_type == type and !pen.is_full() and self in pen.animals_in_kick_area:
				closest_pen = pen
				closest = diff
		
		if !closest_pen:
			return
		end_pos = closest_pen.global_position
	
	animation_player.play("kicked")
	audio_stream_player.play()
	kick_particles.emitting = true
	collision_shape_2d.set_deferred("disabled", true)
	animated_sprite_2d.animation = "idle"
	if combo_count > 1:
		combo_count += 1
		combo_counter.text = "x%s" % combo_count
		show_combo_count()
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	if combo_count > 1 and not no_congratulation_this_kick:
		combo_counter.text = Globals.cowboy_congratulations.pick_random()
		show_combo_count()
	animated_sprite_2d.animation = "walk"
	collision_shape_2d.disabled = false
	being_kicked = false
	if combo_animation_player.is_playing():
		await combo_animation_player.animation_finished

func stun(index: int = 1):
	if in_pen:
		return
	being_stunned = true
	
	var tween = create_tween()
	var diff = Globals.player.global_position - global_position
	var length = diff.length()
	var mult = Globals.STUN_MULTS[type]
	diff = diff.normalized() * pow(mult, index) * length
	var end_pos = global_position + diff
	
	tween.tween_property(self, "global_position", end_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	kick_particles.emitting = true
	audio_stream_player.play()
	animated_sprite_2d.animation = "stun"
	animation_player.play("stun")
	
	await tween.finished
	stun_timer.start()

func show_combo_count():
	if combo_animation_player.is_playing():
		combo_animation_player.stop()
	combo_animation_player.play("update counter")

func _on_stun_timer_timeout() -> void:	
	animation_player.stop()
	animated_sprite_2d.animation = "walk"
	#collision_shape_2d.disabled = false
	being_stunned = false
	if not being_kicked:
		combo_count = 0
		no_congratulation_this_kick = false

func _on_random_movement_timer_timeout() -> void:
	for i in 50: # 50 attempts before giving up
		direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		if not test_move(global_transform, direction * 10):
			break


func _on_screen_entered() -> void:
	if Globals.current_level:
		Globals.current_level.animals_on_screen.append(self)

func _on_screen_exited() -> void:
	Globals.current_level.animals_on_screen.erase(self)
