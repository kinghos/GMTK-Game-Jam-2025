extends Node2D

@onready var asp: AudioStreamPlayer = $AudioStreamPlayer

func play_music(music: AudioStream, volume = 0.0):
	if asp.stream == music:
		return
	asp.stream = music
	asp.volume_db = volume
	asp.play()
