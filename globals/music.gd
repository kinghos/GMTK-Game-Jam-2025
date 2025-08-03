extends Node2D

@onready var asp: AudioStreamPlayer = $AudioStreamPlayer

func play_music(music: AudioStream):
	if asp.stream == music:
		return
	asp.stream = music
	asp.bus = "Music"
	asp.play()

func stop_music():
	asp.stop()
