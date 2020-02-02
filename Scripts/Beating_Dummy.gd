extends KinematicBody2D

signal death

var player
var velocity = 800

enum states {CHILL = 0, WARNING = 1, ATTACK = 2}
var state
var angle : float = 0
export var rotateSpeed : int = 2
export var radiusPlayer: int  = 1000
export var radiusLantern: int  = 150


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
	angle = get_parent().position.angle_to(self.global_position)
	get_parent().connect("warning", self, "setWarning")
	
	
func _physics_process(delta):
	if state == states.ATTACK:
		var direction : Vector2 = (player.position - self.global_position).normalized() * velocity
		move_and_slide(direction)
	if state == states.WARNING:
		angle += rotateSpeed * delta
		var offset : Vector2 = Vector2(sin(angle), cos(angle)) * radiusPlayer
		offset += player.position
		self.set_global_position(offset)
	if state == states.CHILL:
		angle += rotateSpeed * delta
		var offset : Vector2 = Vector2(sin(angle), cos(angle)) * radiusLantern
		self.position = (offset)
	

func takeDamage():
	emit_signal("death")
	queue_free()
	
func setWarning():
	if state == states.CHILL:
		state = states.WARNING
