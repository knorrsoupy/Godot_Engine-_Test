extends Node
@export var coin_scene : PackedScene
@export var playtime = 25
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene

var level = 1 
var score = 0
var time_left = 0
var screensize =  Vector2.ZERO
var playing = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	pass # Replace with function body.

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_cactus()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_coins():
	for i in level + 4 :
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	$LevelSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0 :
		level +=1
		time_left +=5
		spawn_coins()
		spawn_cactus()
		_on_powerup_timer_timeout()
	pass


func _on_game_timer_timeout():
	time_left -=1
	$HUD.update_timer(time_left)
	if time_left <= 0 :
		game_over()
	pass # Replace with function body.


func _on_player_pickup(type):
	match type:
		"coin":
			score +=1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			$PowerUpSound.play()
			time_left+=5
			$HUD.update_timer(time_left)
	pass # Replace with function body.


func _on_player_hurt():
	game_over()
	pass # Replace with function body.

func game_over() :
	playing = false;
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles","queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	

func _on_hud_start_game():
	new_game()
	pass # Replace with function body.


func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize= screensize
	p.position= Vector2(randi_range(0, screensize.x),randi_range(0,screensize.y))
	pass # Replace with function body.
	
func spawn_cactus():
	for i in level:
			var c = cactus_scene.instantiate()
			add_child(c)
			c.screensize = screensize
			c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		

	
	
