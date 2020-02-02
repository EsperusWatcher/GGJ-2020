extends Area2D

func _ready():
	pass # Replace with function body.

func take_damage():
	get_parent().takeDamage()
