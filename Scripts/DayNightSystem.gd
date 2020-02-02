extends Node

signal nightEnd
signal dayEnd

var nightTimer : Timer
var dayTimer : Timer
var isNight : bool
var timerLabel : Label # label to change timer on screen

# Called when the node enters the scene tree for the first time.
func _ready():
	nightTimer = get_node("nightTimer")
	nightTimer.wait_time = 120
	nightTimer.one_shot = true
	
	dayTimer = get_node("dayTimer")
	dayTimer.wait_time = 3
	dayTimer.one_shot = true
	
	isNight = false

func _process(delta):
	if isNight :
		nightCheck()
		printTimeLeft(nightTimer)
	else:
		dayCheck()
		printTimeLeft(dayTimer)


func nightCheck():
	if nightTimer.time_left <= 0:
		emit_signal("nightEnd")
	
func dayCheck():
	if dayTimer.time_left <= 0:
		emit_signal("dayEnd")

func startNight():
	isNight = true
	nightTimer.start()

func startDay():
	isNight = false
	dayTimer.start()

func printTimeLeft(timer : Timer):
	timerLabel.set_text(str(int(timer.time_left)))

func setHUDlabel(newlabel : Label):
	timerLabel = newlabel
