extends Actor

var sprite_node
var anim_player: AnimationPlayer
var idle_sprite: Sprite
var walk_sprite: Sprite
var atk_sprite: Sprite
var BG_sprite: Sprite
var top_layer: CanvasLayer

const end_game = preload("res://Textures/death2.png")

# to detect collisions with enemies
var enemy_collision_detector: CollisionObject2D

var invincible_timer: Timer

# b r u h
# pretty sure this can be made as one block
# but ehm..
var left_attack: AnimationPlayer # to play attack animation
var right_attack: AnimationPlayer
var enemy_melee_right: Area2D # to detect if enemy is in range of melee attack
var enemy_melee_left: Area2D

var atk_progress = false

var direction = Vector2.ZERO
var hp = 100
var canLit : bool = false
var lanternInArea

func _ready():
	sprite_node = get_node("Light2D/IdleSprite") # Used in flipping the character when moving
	left_attack = get_node("LeftHit/Sprite/AnimationPlayer")
	right_attack = get_node("RightHit/Sprite/AnimationPlayer")
	anim_player = get_node("Light2D/IdleSprite/AnimPlayer")
	
	walk_sprite = get_node("Light2D/WalkingSprite")
	idle_sprite = get_node("Light2D/IdleSprite")
	atk_sprite = get_node("Light2D/AttackSprite")
	
	enemy_melee_left = get_node("LeftHit")
	enemy_melee_right = get_node("RightHit")
	
	invincible_timer = get_node("Timer")
	invincible_timer.set("one_shot", true)
	
	top_layer = get_node("BG_Layer")
	BG_sprite = get_node("BG_Layer/Sprite")
	
	atk_sprite.hide()
	
	get_node("HUD_Layer/HUD/VBoxContainer/Bars/Bar/Gauge").set_value(hp)
	
	var allScene = get_parent().get_children()
	for i in allScene: # Here will be errors in terminal because we try to connect to all of object and nam pohui esli ne srabotalo
		i.connect("CanLit", self, "enterLanternArea")
		i.connect("CannotLit", self, "exitLanternArea")

func _process(delta):
	if hp <= 0:
		pass # End of the night round
		
	if Input.is_action_just_pressed("attack_melee"):
		print("attack ")
		walk_sprite.hide()
		idle_sprite.hide()
		atk_sprite.show()
		anim_player.play("Attack")
		atk_progress = true
		if (sprite_node.flip_h == true): 
			print("right")
			atk_sprite.set_flip_h(true)
		else:
			print("left")
			atk_sprite.set_flip_h(false)
	
	if Input.is_action_just_pressed("Use"):
		if lanternInArea != null:
			lanternInArea.playerTryLit()
	
	if (!anim_player.is_playing()):
		atk_sprite.hide()
		idle_sprite.show()
		atk_progress = false

func take_damage():
	if invincible_timer.get("time_left") == 0:
		print("hp down")
		hp -= 10
		if hp <= 0:
			BG_sprite.set_texture(end_game)
			top_layer.set("layer", 100)
		invincible_timer.start(1.5)
	else:
		print("invincible")
	get_node("HUD_Layer/HUD/VBoxContainer/Bars/Bar/Gauge").set_value(hp)	

func _physics_process(delta):
	var direction = get_direction()
	
	if direction.x > 0:
		sprite_node.set_flip_h(true)
	elif direction.x < 0:
		sprite_node.set_flip_h(false)
		
	velocity = calculate_move_velocity(velocity, speed, direction)

	if velocity.x != 0 and atk_progress == false:
		sprite_node = get_node("Light2D/WalkingSprite")
		walk_sprite.show()
		idle_sprite.hide()
		anim_player.play("Walking")
	elif atk_progress == false:
		sprite_node = get_node("Light2D/IdleSprite")		
		walk_sprite.hide()
		idle_sprite.show()
		anim_player.play("Idle")
		
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("move_jump") and is_on_floor() else 0.0
	)

# froms a vector2 of current movement
func calculate_move_velocity(
		linear_velocity: Vector2,
		speed: Vector2,
		direction: Vector2) -> Vector2:
	var out_velocity = linear_velocity
	out_velocity.x = speed.x * direction.x 
	out_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out_velocity.y = speed.y * direction.y
	
	return out_velocity

# detects if enemy is in the range of left hit area
func _on_LeftHit_area_entered(area):
	if (not area.is_in_group("Neutral")):
		if area.is_in_group("hit"):
			print("hit")
			area.take_damage()

# detects if enemy is in the range of right hit area
func _on_RightHit_area_entered(area):
	if (not area.is_in_group("Neutral")): 
		if area.is_in_group("hit"):
			print("hit")
			area.take_damage()

func enterLanternArea(lantern):
	lanternInArea = lantern
	canLit = true

func exitLanternArea():
	lanternInArea = null
	canLit = false
