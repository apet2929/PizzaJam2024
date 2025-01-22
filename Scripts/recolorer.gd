extends Node


@export var targets: Array[MeshInstance3D] = []
@export var override_mesh_texture = false

var default_materials = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(targets.size()):
		var base_mat = targets[i].get_surface_override_material(0)
		default_materials.append(base_mat)
	
	set_color(get_parent().color)

func set_color(new_color_enum) -> void:
	
	for i in range(targets.size()):
		if new_color_enum == Colors.COLOR.DEFAULT:
			targets[i].set_surface_override_material(0, default_materials[i])
			continue
		
		# Copy material to avoid modifying other instances' materials
		var base_mat = default_materials[i]
		var new_mat = ResourceLoader.load(base_mat.resource_path, "StandardMaterial3D", ResourceLoader.CACHE_MODE_IGNORE)
		
		var overrides = get_parent().get("COLOR_OVERRIDES")
		var new_color = Colors.colors[new_color_enum]
		print("Setting color: ", new_color_enum)
		print(new_color)
		if overrides != null:
			new_color = overrides.get(new_color_enum, new_color)
		
		new_mat.albedo_color = new_color
		if override_mesh_texture:
			new_mat.albedo_texture = null
		
		targets[i].set_surface_override_material(0, new_mat)
