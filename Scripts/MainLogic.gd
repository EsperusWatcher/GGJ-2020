extends Node

var playerInst = preload("res://Scenes/Player.tscn")

var dayNightSystem
var player
var lanterns = []
var HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	dayNightSystem = get_node("DayNightSystem")
	dayNightSystem.connect("nightEnd", self, "dayStart")
	dayNightSystem.connect("dayEnd", self, "nightStart")
	player = get_node("Player")
	HUD = player.get_node("HUD_Layer/HUD")
	for i in get_children():
		if i is StaticBody2D:
			lanterns.append(i)
	dayNightSystem.setHUDlabel(HUD.get_node("VBoxContainer/Timer/time"))
	dayStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func nightStart():
	corruptAllLanterns()
	showMiniMap()
	#while Input.is_action_just_pressed("Use"): # Waiting for skip minimap
	hideMiniMap()
	dayNightSystem.startNight()
	player.speed = Vector2(3000.0, 4000.0)
	
func dayStart():
	litAllLanterns()
	player.speed = Vector2(0, 0)
	player.position = playerInst.instance().position
	dayNightSystem.startDay()
	# corruptNewLantern()
	regenLanternShield()
	

func corruptNewLantern(): #LEGACY
	var corruptedLanterns = []
	for i in lanterns: # make all extinct lantern - corrupted
			if i.corruptState == i.corruptStates.EXTINCT:
				i.corrupt() 
			if i.corruptState == i.corruptStates.CORRUPT:
				corruptedLanterns.append(i)
		
	if(corruptedLanterns.size() == 0): # if no corrupted lanterns - create random one
		randomize() # Make REALLY random number
		var index = randi() % lanterns.size()
		lanterns[index].corrupt()
	else: # if at least 1 lantern is corrupted - make neigbour lantern extinct
		for i in range(lanterns.size()): # Tranform Lit lattern near with corrupted - to extinct
			if(lanterns[i].corruptState == lanterns[i].corruptStates.CORRUPT):
				var j = i
				if i - 1 < 0:
					j = lanterns.size() - 1
				else:
					j = j - 1
				if lanterns[j].corruptState == lanterns[j].corruptStates.LIT:
					lanterns[j].extinct()
				
				j = i
				if i + 1 > lanterns.size() - 1:
					j = 0
				else:
					j = j + 1
				if lanterns[j].corruptState == lanterns[j].corruptStates.LIT:
					lanterns[j].extinct()

func corruptAllLanterns():
	for i in lanterns:
		i.corrupt()
		
func litAllLanterns():
	for i in lanterns:
		i.lit()

func regenLanternShield():
	for i in lanterns:
		i.shield = i.maxShield

func showMiniMap():
	pass
	
func hideMiniMap():
	pass
	
