extends CharacterBody2D
class_name BaseAnimal

var in_kick_range: bool
var being_kicked: bool
var being_stunned: bool

@export var kick_distance: float = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kick_particles: CPUParticles2D = $KickParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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
	diff = diff.normalized() * kick_distance
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
	
	await animation_player.animation_finished
	animated_sprite_2d.animation = "walk"
	collision_shape_2d.disabled = false
	being_stunned = false
