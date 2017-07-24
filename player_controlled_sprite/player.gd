extends Area2D

# causes var to be available in inspector under Speed Variables
export var speed = 400
var vel = Vector2()
var screensize
var extents

func _ready():
	# so we can run something every frame
	set_fixed_process(true)
	screensize = get_viewport_rect().size
	#extents = get_node("sprite").get_texture().get_size() / 4
	# above was from video, this was in post, and makes way more sense
	# why divide by 4 above instead of by 2 ala test1?
	extents = get_node("collision").get_shape().get_extents()
	set_pos(screensize / 2)

func _fixed_process(delta):
	var input = Vector2(0,0)
	# Input.is_action_pressed returns 0 or 1
	input.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	input.y = Input.is_action_pressed("ui_down") - Input.is_action_pressed("ui_up")
	vel = input.normalized() * speed
	var pos = get_pos() + vel * delta
	#pos.x = clamp(pos.x, 0, screensize.width)
	#pos.y = clamp(pos.y, 0, screensize.height)
	pos.x = clamp(pos.x, extents.width, screensize.width - extents.width)
	pos.y = clamp(pos.y, extents.height, screensize.height - extents.height)
	set_pos(pos) 