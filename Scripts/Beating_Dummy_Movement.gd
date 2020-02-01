extends KinematicBody2D

signal death

var player
var velocity = 100

func _ready():
	player = get_parent().get_parent().get_node("Player")
	pass # Replace with function body.

func _process(delta):
	pass
	
func _physics_process(delta):
	var direction = (player.position - (get_parent().position + position)).normalized() * velocity
	move_and_slide(direction)

func takeDamage():
	emit_signal("death")
