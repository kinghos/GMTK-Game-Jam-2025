extends CharacterBody2D
class_name Player


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var lasso_start: Marker2D = $LassoStart
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera_2d: Camera2D = $Camera2D

var animals_in_range: Array[BaseAnimal]
var already_zooming: bool = false

func _ready() -> void:
	Globals.player = self
	rotation = 0

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

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	velocity = Globals.player_speed * direction
	if !(animated_sprite_2d.animation == "kick" and animated_sprite_2d.is_playing()):
		if velocity != Vector2.ZERO:
			animated_sprite_2d.play("run")
			if !animation_player.is_playing():
				animation_player.play("run"	)
		else:
			animated_sprite_2d.play("idle")
			animation_player.play("RESET")
			animation_player.stop()
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Kick"):
		for animal in animals_in_range:
			if !animal.being_kicked and animal.is_in_kick_area:
				animated_sprite_2d.play("kick")
				animal.being_kicked = true  # necessary so that combo count doesn't reset, since it would only be set to true in kick() AFTER the stun timer timeout
				animal.stun_timer.stop()
				animal._on_stun_timer_timeout()
				animal.kick()
				audio_stream_player.play()

func interpolate_back_to_player():
	var zoom_out_camera = Globals.current_level.get_node("ZoomOutCamera")
	
	var duration = 1.0
	var elapsed = 0.0
	var start_pos = zoom_out_camera.global_position
	
	while elapsed < duration:
		var t = elapsed / duration
		zoom_out_camera.global_position = start_pos.lerp(Globals.player.global_position, t)
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	zoom_out_camera.global_position = Globals.player.global_position

func zoom_out():
	already_zooming = true
	
	var zoom_out_camera = Globals.current_level.get_node("ZoomOutCamera")
	zoom_out_camera.global_position = camera_2d.global_position
	zoom_out_camera.zoom = camera_2d.zoom
	zoom_out_camera.enabled = true
	camera_2d.enabled = false
	
	var zoom_out_camera_level = Globals.current_level.zoom_out_camera_level

	var zoom_tween = create_tween()
	var position_tween = create_tween()
	zoom_tween.tween_property(zoom_out_camera, "zoom", Vector2(zoom_out_camera_level, zoom_out_camera_level), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	position_tween.tween_property(zoom_out_camera, "global_position", Vector2(960, 540), 1)
	
	await zoom_tween.finished
	await position_tween.finished
	await get_tree().create_timer(2).timeout
	
	var zoom_in_tween = create_tween()
	zoom_in_tween.tween_property(zoom_out_camera, "zoom", Vector2(2, 2), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	interpolate_back_to_player()
	
	await zoom_in_tween.finished
	
	zoom_out_camera.enabled = false
	camera_2d.enabled = true
	
	already_zooming = false
