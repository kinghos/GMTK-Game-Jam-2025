extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool
var being_kicked: bool
var being_stunned: bool
var target: Vector2
var need_to_change_target = false
var changed_target_last_time = false

@export var speed = 75

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kick_particles: CPUParticles2D = $KickParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var stun_timer: Timer = $StunTimer
@onready var random_movement_timer: Timer = $RandomMovementTimer

func _ready() -> void:
	stun_timer.wait_time = Globals.stun_time
	_on_random_movement_timer_timeout()
	random_movement_timer.start()

func _physics_process(delta: float) -> void:
	print(name, " ", target)
	if being_stunned or being_kicked:
		return
	
	velocity = position.direction_to(target) * speed
	move_and_slide()
	
	# Bounce off pens and other sheep
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider:
			var current = collider
			while current:
				if current.is_in_group("Pens") or current.is_in_group("Animals"):
					print("TBA: bounce somehow")
					#var normal = collision.get_normal()
					#velocity = velocity.bounce(normal)
					#target = global_position + velocity.normalized() * 100
					break
				current = current.get_parent()
			if current:
				break

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
	var closest_pen: Node2D
	var diff
	
	for pen: Node2D in get_tree().get_nodes_in_group("Pens"):
		diff = global_position.distance_to(pen.global_position)
		if diff < closest:
			closest_pen = pen
			closest = diff
			
	diff = global_position - closest_pen.global_position
	diff = diff.normalized() * Globals.kick_distance
	var end_pos = global_position - diff
	
	animation_player.play("kicked")
	kick_particles.emitting = true
	animated_sprite_2d.animation = "idle"
	collision_shape_2d.disabled = true
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	animated_sprite_2d.animation = "walk"
	collision_shape_2d.disabled = false
	being_kicked = false
	
func stun():
	being_stunned = true
	animation_player.play("stun")
	kick_particles.emitting = true
	animated_sprite_2d.animation = "idle"
	collision_shape_2d.disabled = true
	stun_timer.start()
	

func _on_stun_timer_timeout() -> void:	
	animation_player.stop()
	animated_sprite_2d.animation = "walk"
	collision_shape_2d.disabled = false
	being_stunned = false

# okay my thought process behind this was that it should change target if it hasn't reached it in 2 timeouts
func _on_random_movement_timer_timeout() -> void:
	if not changed_target_last_time:
		need_to_change_target = true
	var rect = get_viewport().get_visible_rect()
	# and here, if the distance of the target is more than 100, it won't reach it before the end of the timeout and look jank
	# maybe need to adjust the value of 100 to enable that
	while not target or position.distance_to(target) < 100 or need_to_change_target:
		target = rect.position + Vector2(
			randf_range(0, rect.size.x),
			randf_range(0, rect.size.y)
		)
		changed_target_last_time = true
		need_to_change_target = false
