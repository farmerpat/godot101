extends Node

# got path by right-clicking on Sprite.tscn in the FileSystem
# pane and selecting 'Copy Path'
onready var sprite = preload("res://Sprite.tscn")

func _ready():
#	var s = sprite.instance()
#	add_child(s)

	for i in range(300):
		var s = sprite.instance();
		add_child(s)
