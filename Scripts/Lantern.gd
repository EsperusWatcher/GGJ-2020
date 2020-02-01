extends StaticBody2D

signal CanLit(lantern)
signal CannotLit

const enemyInst = preload("res://Scenes/Beating_Dummy.tscn")
const extinctLantern = preload("res://Textures/Test_textures/Test_Extinct_lantern.png")
const litLantern = preload("res://Textures/Test_textures/Test_Lit_lantern.png")

var spawnTimer : Timer 
var shield : int = 100
var spawnRate : float = 4
var countOfEnemiesInOneTime : int = 5
var spawnPosition : int = 1
var countOfChildOnStart : int = 0
var corrupted : bool = true
var isLit : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	countOfChildOnStart = get_child_count()
	spawnTimer = get_node("SpawnTimer")
	spawnTimer.wait_time = spawnRate
	spawnTimer.start()
	pass # Replace with function body.


func _process(delta):
	if(corrupted):
		spawnNewEnemies(delta)
	pass


func spawnNewEnemies(delta) :
	if (spawnTimer.time_left == 0 ) : 
		if(get_child_count() < countOfEnemiesInOneTime + countOfChildOnStart):
			var enemy = enemyInst.instance()
			enemy.connect("death", self, "enemyDeath")
			var spawnerName : String = "SpawnPosition" + str(spawnPosition)
			var position : Vector2 = get_node(spawnerName).position
			enemy.position = position
			spawnPosition += 1
			if(spawnPosition > 4):
				spawnPosition = 1
			self.add_child(enemy)
		spawnTimer.start()

func enemyDeath():
	decreaseCorrupt(50)
	pass

func decreaseCorrupt(count : int) :
	shield -= count
	if(shield <= 0):
		 becomeUnCorrupt()
		
func becomeUnCorrupt():
	corrupted = false
	var sprite : Sprite = get_node("Sprite")
	sprite.set_texture(extinctLantern)

func _on_LitLatternArea_area_entered(area):
	if area.is_in_group("player") : 
		print("CAN LIT")
		emit_signal("CanLit", self)

func lit():
	isLit = true
	var sprite : Sprite = get_node("Sprite")
	sprite.set_texture(litLantern)

func _on_LitLatternArea_area_exited(area):
	emit_signal("CannotLit")