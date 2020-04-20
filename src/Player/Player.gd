extends Area2D

onready var animatior = $AnimationPlayer
onready var jumper = $Tween
onready var string = $Kitestart
var jumping = false
var Position
var dead = false
signal dead

func _ready():
	Position = position
	animatior.play("Run")

func _process(delta):
	if Input.is_action_pressed("jump"):
		if jumping == false and dead == false:
			jumper.interpolate_property(self, "position", Position,  Vector2(Position.x, Position.y-80), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			jumper.start()
			jumping = true
		

func _on_Tween_tween_all_completed():
	if jumping == true:
		jumper.interpolate_property(self, "position", null, Position, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
		jumper.start()
		yield(get_tree().create_timer(0.4), "timeout")
		jumping = false

func _on_Player_body_entered(body):
	update()
	animatior.play("Sad")
	emit_signal("dead")
	dead = true
