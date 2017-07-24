extends Area2D

onready var effect = get_node("effect")
onready var sprite = get_node("sprite")

# define a custom signal becase get_node('../..').gem_grabbed() is bad news
signal gem_grabbed

# can see available signals in the inspector for the gem node (instance of Area2D)
# we care about area_enter, since player is also and Area2D
# select the signal in inspector.
# click "connect"
# in this case, we leave it "on gem",
# and it gives us a method name of _on_gem_area_enter, dumping it right
# into the script

func _ready ():
	effect.interpolate_property(
		sprite,
		"transform/scale",
		sprite.get_scale(),
		Vector2(2.0, 2.0),
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	
	effect.interpolate_property(
		sprite,
		"visibility/opacity",
		sprite.get_opacity(),
		0,
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)


func _on_gem_area_enter (area):
	if area.get_name() == "player":
		emit_signal("gem_grabbed")
		# while the effect is completing, player could re-collide with this
		# we want to prevent that, and clear_shapes removes the collision
		# shapes from the object 
		clear_shapes()
		effect.start()

# created by effect->node->signals->tween_complete->"connect"->"dbl click gem"
func _on_effect_tween_complete( object, key ):
	queue_free()
