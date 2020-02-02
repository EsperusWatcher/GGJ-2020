extends KinematicBody2D

signal death

var player
var velocity = 100

enum states {CHILL, WARNING}
var state

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
	
func _ready():
	player = get_parent().get_parent().get_node("Player")
	state = states.WARNING
	
func _physics_process(delta):
	if state == states.WARNING:
		var direction : Vector2 = (player.position - (get_parent().position + position)).normalized() * velocity
		move_and_slide(direction)
	if state == states.CHILL:
		var angle = velocity * delta
		print(angle)
		var direction : Vector2 = Vector2(sin(angle), cos(angle)) * 20
		move_and_slide(direction)

func takeDamage():
	emit_signal("death")
	queue_free()
	
