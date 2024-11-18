extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# two spheres for head and tail
# body rendered by Worm_GFX
	# 1 point per tile
# worm_body = path (has points)
# Points stored in BodyParts and worm_body
	# nodes in BodyParts
	# points in worm_body

# points in worm body are 

# WormBody: Path3D
# curve points
# nodes
#- addPoint() : adds a node to children list, returns point id (index)
#- removePoint(point_id)
