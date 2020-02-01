extends Node

func _ready():
	root.remove_child(level)
	level.call_deferred("free")
	
	var level = root.get_node("Level")
	
	var next_level_resource = load("res://path/to/scene.tscn")
	var next_level = next_level_resource.instance()
	root.add_child(next_level)
	
func _process(delta):
	pass
