extends Node2D

onready var tilemap = $TileMap
onready var scoretimer = $Timer
onready var tiletimer = $Timer2
onready var barriertimer = $Timer3
onready var scorelabel = $HBoxContainer/Label
onready var highscorelabel = $HBoxContainer/Label2
onready var restart = $HBoxContainer/Button
onready var player = $Player
onready var play_audio = $AudioStreamPlayer
onready var pressed = $AudioStreamPlayer2
onready var hit = $AudioStreamPlayer3
onready var kite = $Path2D/PathFollow2D
onready var particles = $Path2D/PathFollow2D/Particles2D
onready var stringend = $Kitestop
onready var kiteanimator = $Path2D/PathFollow2D/AnimationPlayer
var already_grounded = false
var level = 1
var score = 0
var nextile = 33
var alive = true
var highscore = 0

func _ready():
	highscorelabel.text = "High " + str(highscore)

func _draw():
	if player.dead == false:
		draw_line(stringend.position, player.position, Color( 0.96, 0.96, 0.86, 1 ))

func _process(delta):
	if alive == true:
		tilemap.position.x -= level + 2
		if abs(tilemap.position.x/18):
			add_tile()
		scorelabel.text = str(score)
	if player.dead:
		kite.offset += delta * 100
	if kite.unit_offset >= 1 and already_grounded == false:
		particles.emitting = true
		kiteanimator.play("Idle")
		already_grounded = true
	if player.jumping == true:
		update()

func _on_Player_dead():
	hit.play()
	restart.visible = true
	restart.disabled = false
	alive = false
	scoretimer.stop()
	tiletimer.stop()
	barriertimer.stop()
	if score > highscore:
		highscore = score
	highscorelabel.text = "High " + str(highscore)
	play_audio.volume_db = -10
	update()

func _on_Timer_timeout():
	score += 1
	if score >= level*100:
		level += 1

func _on_Timer2_timeout():
	nextile += 1
	tilemap.set_cell(nextile, 14, 1)
	tilemap.set_cell(nextile, 15, 0)
	tilemap.set_cell(nextile, 16, 0)
	tilemap.set_cell(-1, 14, -1)
	tilemap.set_cell(-1, 15, -1)
	tilemap.set_cell(-1, 16, -1)

func _on_Timer3_timeout():
	randomize()
	var obstacle = rand_range(0,2)
	var pit = true if obstacle > 1 else false
	if pit == false:
		tilemap.set_cell(nextile, 13, 3)
		tilemap.set_cell(nextile, 12, 2)
	elif pit == true:
		tilemap.set_cell(nextile, 14, 4)
		tilemap.set_cell(nextile, 15, -1)
		tilemap.set_cell(nextile, 16, -1)
		tilemap.set_cell(nextile-1, 14, 4)
		tilemap.set_cell(nextile-1, 15, -1)
		tilemap.set_cell(nextile-1, 16, -1)
		tilemap.set_cell(nextile+1, 14, 4)
		nextile += 1
	tilemap.update_dirty_quadrants()

func _on_Button_pressed():
	pressed.play()
	restart()

func restart():
	tilemap.clear()
	nextile = 0
	tilemap.position = Vector2(0,0)
	for x in range(0, 33):
		tilemap.set_cell(nextile, 14, 1)
		tilemap.set_cell(nextile, 15, 0)
		tilemap.set_cell(nextile, 16, 0)
		nextile += 1
	nextile -= 1
	score = 0
	level = 1
	restart.visible = false
	restart.disabled = true
	play_audio.volume_db = 0
	alive = true
	player.dead = false
	kite.offset = 228
	kiteanimator.play("flying")
	already_grounded = false
	player.animatior.play("Run")
	player.update()
	scoretimer.start()
	barriertimer.start()
	tiletimer.start()
	update()

func add_tile():
	nextile += 1
	tilemap.set_cell(nextile, 14, 1)
	tilemap.set_cell(nextile, 15, 0)
	tilemap.set_cell(nextile, 16, 0)
	tilemap.set_cell(-1, 14, -1)
	tilemap.set_cell(-1, 15, -1)
	tilemap.set_cell(-1, 16, -1)
