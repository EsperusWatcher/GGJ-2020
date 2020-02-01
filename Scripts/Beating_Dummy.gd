extends KinematicBody2D

func _start():
	get_node("DamageArea/CollisionShape2D3").set_disabled(false)

func _on_CollisionShape2D_area_entered(area):
	if (get_node("Sprite/AnimationPlayer").is_playing() == true and 
		get_node("DamageArea/CollisionShape2D3").is_disabled() == false):
			
		if (area.is_in_group("player")):
			area.take_damage()
	
	if area.is_in_group("player") and get_node("Sprite/AnimationPlayer").is_playing() == false:
		get_node("Sprite/AnimationPlayer").play("Boom")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("Sprite/AnimationPlayer").clear_caches()
	get_node("DamageArea/CollisionShape2D3").set_disabled(false)
	
