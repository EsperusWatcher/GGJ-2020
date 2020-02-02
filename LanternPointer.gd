extends Node2D

var target_position: Vector2
var player_position: Vector2
var arrow

func _ready():
	player_position = get_parent().get_parent().get("position")
	target_position = get_parent().get_parent().get_parent().get_node("Lantern").get("position")
	arrow = get_node(".")
	
func _process(delta):
	var pointing_vector = target_position - player_position
	arrow.look_at(pointing_vector)
