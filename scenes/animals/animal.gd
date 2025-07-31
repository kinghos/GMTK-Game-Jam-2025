extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool
var being_kicked: bool
var being_stunned: bool
var target: Vector2
var need_to_change_target = false
var changed_target_last_time = false
var in_pen: bool = false

@export var speed = 75
var direction

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kick_particles: CPUParticles2D = $KickParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var offscreen_pointer: Sprite2D = $OffscreenPointer
@onready var stun_timer: Timer = $StunTimer
@onready var random_movement_timer: Timer = $RandomMovementTimer

func _ready() -> void:
	stun_timer.wait_time = Globals.stun_time
	random_movement_timer.wait_time *= randf_range(0.8, 1.2)
	_on_random_movement_timer_timeout()
	random_movement_timer.start()

func _physics_process(delta: float) -> void:
	if being_stunned or being_kicked:
		return
	
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

func kick():
	being_kicked = true
	var closest = INF
	var closest_pen: Pen
	var diff
	
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		diff = global_position.distance_to(pen.global_position)
		if diff < closest:
			closest_pen = pen
			closest = diff
	
	var end_pos: Vector2
	var is_pen_full = len(closest_pen.animals_in_pen_enclosure) == closest_pen.max_animals
	if in_pen or is_pen_full:
		being_kicked = false
		return
	if self in closest_pen.animals_in_auto_kick_area:
		end_pos = closest_pen.global_position
	else:
		diff = global_position - closest_pen.global_position
		diff = diff.normalized() * Globals.kick_distance
		end_pos = global_position - diff
	
	animation_player.play("kicked")
	kick_particles.emitting = true
	collision_shape_2d.disabled = true
	animated_sprite_2d.animation = "idle"
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	animated_sprite_2d.animation = "walk"
	collision_shape_2d.disabled = false
	being_kicked = false
	
func stun(index: int):
	if in_pen:
		return
	being_stunned = true
	
	var tween = create_tween()
	var diff = Globals.player.global_position - global_position
	var length = diff.length()
	diff = diff.normalized() * pow(0.8, index) * length
	var end_pos = global_position + diff
	
	tween.tween_property(self, "global_position", end_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	kick_particles.emitting = true
	animated_sprite_2d.animation = "idle"
	
	await tween.finished
	stun_timer.start()
	animated_sprite_2d.play("stun")
	animation_player.play("stun")
	

func _on_stun_timer_timeout() -> void:	
	animation_player.stop()
	animated_sprite_2d.animation = "walk"
	#collision_shape_2d.disabled = false
	being_stunned = false

# okay my thought process behind this was that it should change target if it hasn't reached it in 2 timeouts
func _on_random_movement_timer_timeout() -> void:
	#if not changed_target_last_time:
		#need_to_change_target = true
	#var rect = get_viewport().get_visible_rect()
	## and here, if the distance of the target is more than 100, it won't reach it before the end of the timeout and look jank
	## maybe need to adjust the value of 100 to enable that
	#while not target or position.distance_to(target) < 100 or need_to_change_target:
		#target = rect.position + Vector2(
			#randf_range(0, rect.size.x),
			#randf_range(0, rect.size.y)
		#)
		#changed_target_last_time = true
		#need_to_change_target = false
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
