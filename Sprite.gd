extends Sprite

# how far from the center is the edge
# of the sprite?
var extents
# var vel = Vector2(400,250)
var vel
var spin
var pos
var screen_size

func _ready():
	# w/o this call, rand_range will generate same results ever time,
	# which is useful for testing, but not for prod
	# seed rng
	randomize()
	print(get_pos())
	screen_size = get_viewport_rect().size
	extents = get_texture().get_size() / 2
	# take some time and internalize this
	vel = Vector2(rand_range(100.0, 300.0), 0).rotated(rand_range(0, 2 * PI))
	spin = rand_range(-PI, PI)
	# set pos to the center of the screen
	pos = screen_size / 2
	set_pos(pos)
	
	# this tells the spirte to do something every frame
	# the _process fn determines what this is
	set_process(true)
	
	
# delta:
# how much time has passed since last frame
# around 1/60th but often a bit less b/c processor time
# allows frame rate independence
# take time and think on this so it sinks in...
# it sounds like (according to
# http://kidscancode.org/blog/2017/02/godot_101_02/)
# that multiplying something that would
# originally be in units of per frame by delta
# changes it to per second
func _process (delta):
	# clockwise
	# set_rot(get_rot() + PI * delta * -1)
	# counter clockwise
	# set_rot(get_rot() + PI * delta * 1)
	set_rot(get_rot() + spin * delta)
	pos += vel * delta
	
	if (pos.x >= (screen_size.width - extents.width)):
		# this prevents sprite from getting stuck
		# when it has already gone past the edge
		pos.x = screen_size.width - extents.width
		vel.x *= -1

	if (pos.x <= (0 + extents.width)):
		pos.x = extents.width
		vel.x *= -1

	if (pos.y >= (screen_size.height - extents.height)):
		pos.y = screen_size.height - extents.height
		vel.y *= -1
	
	if (pos.y <= (extents.height)):
		pos.y = extents.height
		vel.y *= -1

	set_pos(pos)


