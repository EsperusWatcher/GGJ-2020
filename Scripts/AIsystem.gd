extends Node

var enemysInAttack = [] # All minios that attack
var nowInAttack = 0  # how much minions in attack RIGHT NOW 
export var attackAtTheSameTimeCount = 1 # How much CAN attack at same time
var active : bool = false

var dayNightSystem

func _ready():
	dayNightSystem = get_parent().get_node("DayNightSystem")
	dayNightSystem.connect("nightEnd", self, "nightEnd")
	dayNightSystem.connect("dayEnd", self, "dayEnd")


func _process(delta):
	if active:
		if nowInAttack < attackAtTheSameTimeCount and enemysInAttack.size() > nowInAttack:
			newMinionGoAttack()

func addNewEnemy(enemy):
	enemysInAttack.append(enemy)
	enemy.connect("death", self, "minionDeath")

func minionDeath():
	if active:
		nowInAttack = nowInAttack - 1
		newMinionGoAttack()

func newMinionGoAttack():
	for i in enemysInAttack:
		if is_instance_valid(i) :
			if i is KinematicBody2D:
				if i.state == i.states.WARNING:
					i.state = i.states.ATTACK
					nowInAttack = nowInAttack + 1
					pass


func nightEnd():
	active = false
	enemysInAttack.clear()
	nowInAttack = 0
	
func dayEnd():
	active = true
