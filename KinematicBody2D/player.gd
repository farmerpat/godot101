extends KinematicBody2D

const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500
const GRAVITY = 2000
const JUMP_SPEED = -1000
const MIN_JUMP = -500

onready var sprite = get_node("sprite")
onready var ground_ray = get_node("ground_ray") 
var acc = Vector2()
var vel = Vector2()

var anim = "idle"

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_up") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED

	if event.is_action_released("ui_up"):
		if vel.y < MIN_JUMP:
			vel.y = MIN_JUMP

func _fixed_process(delta):
	acc.y = GRAVITY
	acc.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	acc.x *= ACCEL
	
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta

	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	
	# if collision occurs on move, the object will stop moving,
	# and there is still a portion of the movement left over
	# we remedy this by leveraging the "collision normal"
	# in the case of our player landing on a platform,
	# the collision normal vector is a normalized vector
	# pointing in the opposite direction of the collision
	# (e.g. perpendicular to the platform we landed on)
	# (e.g. [0,-1]
	# in this case, the move function will return
	# the unused portion of the movement vector
	# for instance, our player is colliding with ground,
	# so when we try to move, say, right, the resulting
	# vector is trying to move him down (past the ground),
	# and to the right.  It can't complete the movement
	# see http://kidscancode.org/blog/2017/04/godot_101_09/
	# 14:16 for an explanation 
	var unused_motion = move(vel * delta)
	
	if is_colliding():
		var collision_normal = get_collision_normal()
		var motion = collision_normal.slide(unused_motion)
		
		# because otherwise, the velocity vector
		# keeps grown as we continue colliding with the ground
		vel = collision_normal.slide(vel)
		move(motion)

	if abs(vel.x) < 10:
		vel.x = 0

	# set animation
	if vel.x == 0:
		anim = "idle"
	else:
		anim = "running"

	if vel.x > 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)

	sprite.play(anim)