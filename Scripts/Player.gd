extends Actor

var sprite_node
var anim_node: AnimationPlayer

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

var direction = Vector2.ZERO
var hp = 100
var canLit : bool = false
var lanternInArea

func _ready():
	sprite_node = get_node("Sprite") # Used in flipping the character when moving
	left_attack = get_node("LeftHit/Sprite/AnimationPlayer")
	right_attack = get_node("RightHit/Sprite/AnimationPlayer")
	anim_node = get_node("Sprite/AnimationPlayer")
	
	enemy_melee_left = get_node("LeftHit")
	enemy_melee_right = get_node("RightHit")
	
	invincible_timer = get_node("Timer")
	invincible_timer.set("one_shot", true)
	
	get_node("HUD_Layer/HUD/VBoxContainer/Bars/Bar/Gauge").set_value(hp)
	
	var allScene = get_parent().get_children()
	for i in allScene:
		i.connect("CanLit", self, "enterLanternArea")
		i.connect("CannotLit", self, "exitLanternArea")

func _process(delta):
	if hp <= 0:
		pass # End of the night round
		
	if Input.is_action_just_pressed("attack_melee"):
		print("attack ")
		if (sprite_node.flip_h == true): 
			print("right")
			right_attack.play("Strike")
		else:
			print("left")
			left_attack.play("Strike1")
	
	if Input.is_action_just_pressed("Use"):
		if lanternInArea != null:
			lanternInArea.playerTryLit()

func take_damage():
	if invincible_timer.get("time_left") == 0:
		print("hp down")
		hp -= 25
		invincible_timer.start(2)
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

	if velocity.x != 0:
		anim_node.play("Walking")
	else:
		anim_node.stop(1)
		anim_node.clear_caches()

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
