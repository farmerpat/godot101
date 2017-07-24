extends Node

onready var gem = preload("res://gem.tscn")
onready var gem_container = get_node("gem_container")
onready var score_label = get_node("HUD/score_label")
onready var time_label = get_node("HUD/time_label")
onready var game_timer = get_node("game_timer")

var screensize
var score = 0
var level = 1

func _ready():
	randomize();
	screensize = get_viewport().get_rect().size
	set_process(true)
	spawn_gems(10)

func _process(delta):
	time_label.set_text(str(int(game_timer.get_time_left())))
	if gem_container.get_child_count() == 0:
		level += 1
		spawn_gems(level * 10)

func spawn_gems (num):
	for i in range(num):
		var g = gem.instance()
		g.connect("gem_grabbed", self, "_on_gem_grabbed")
		gem_container.add_child(g)
		g.set_pos(Vector2(rand_range(0, screensize.width - 40),
						  rand_range(0, screensize.height - 40)))

func _on_gem_grabbed ():
	score += 10
	score_label.set_text(str(score))

func _on_game_timer_timeout():
	# freeze the player
	print("got timeout event")
	get_node("player").set_fixed_process(false)
