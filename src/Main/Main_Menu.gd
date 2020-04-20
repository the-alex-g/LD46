extends Node

onready var resume = $Resume
onready var pause_audio = $AudioStreamPlayer
onready var instrux = $credits
onready var main = $Main
var visible = true
var disabled = false

func _ready():
	main.kiteanimator.play("flying")
	if main.highscore == 0:
		resume.text = "Play"
	get_tree().paused = true
	pause_audio.play()
	main.play_audio.stop()

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().paused = true
		visible = true
		disabled = false
		toggle_menu()
		pause_audio.play()
		main.play_audio.stop()

func _on_Resume_pressed():
	main.pressed.play()
	get_tree().paused = false
	visible = false
	disabled = true
	toggle_menu()
	main.play_audio.play()
	pause_audio.stop()
	if resume.text == "Play":
		resume.text = "Resume"

func toggle_menu():
	resume.visible = visible
	resume.disabled = disabled
	instrux.visible = visible
