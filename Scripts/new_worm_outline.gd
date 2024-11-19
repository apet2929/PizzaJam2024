extends Node3D

# Linked list of Node3D
var segments = []
var curve = []

# Segment:
# +position
# -parent (derived from segments list)
# -index (derived from segments list)

func reset(segments):
	curve = []
	segments = []
	

func add_segment():
	# Adds a segment to the end of the worm
	var new_segment = Vector3(segments[segments.size()-1])
	segments.append(new_segment)
	curve.append(new_segment)

func remove_segment(i):
	segments.remove_at(i)
	curve.remove_at(i)

func split():
	var new_self: Node3D = self # new instance
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(segments.size()):
		process_segment(i)

func process_segment(i):
	var seg = segments[i]
	if i != 0:
		var parent = segments[i-1]
		seg.position = lerp(seg.position, parent.position, 0)
