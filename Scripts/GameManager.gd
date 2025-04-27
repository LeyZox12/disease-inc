extends Node

var registry = ItemRegistry.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cube = Mesh.new()
	cube = BoxMesh.new()
	registry.register_item(
		preload("res://Assets/multiple_slot_item_3.png"),
		[Vector2(0,0), Vector2(1,0), Vector2(0,1)],
		Vector2(32, 32),
		5.0,
		preload("res://Assets/untitled.obj"),
		get_node_from_packed_scene(preload("res://Prefabs/sphere.tscn")),
		func():pass
	)
	registry.register_item(
		preload("res://Assets/multiple_slot_item.png"),
		[Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1, 1)],
		Vector2(32, 32),
		5.0,
		preload("res://Assets/untitled.obj"),
		get_node_from_packed_scene(preload("res://Prefabs/sphere.tscn")),
		func():pass
	)
	add_item_to_world(0, Vector3(0, 1.7, -1.4))
	add_item_to_world(0, Vector3(0, 1.7, -0.4))
	add_item_to_world(1, Vector3(0, 1.7, -0.4))

	pass # Replace with function body.

func clone_item(item_to_clone):
	var new_item = Item.new()
	new_item.collision = item_to_clone.collision
	new_item.cut_size = item_to_clone.cut_size
	new_item.equipable = item_to_clone.equipable
	new_item.inventory_shape = item_to_clone.inventory_shape
	new_item.inventory_sprite = item_to_clone.inventory_sprite
	new_item.obj = item_to_clone.obj
	new_item.model = item_to_clone.model
	new_item.onUse = item_to_clone.onUse
	new_item.weight = item_to_clone.weight
	return new_item


func add_item_to_world(index, pos):
	var instance = RigidBody3D.new()
	var item = clone_item(registry.items[index])
	var collision = CollisionShape3D.new()
	var mesh = MeshInstance3D.new()
	mesh.mesh = item.model.mesh
	collision.set_shape(item.collision.shape)
	instance.position = pos
	instance.add_child(mesh)
	instance.add_child(collision)
	instance.mass = item.weight
	instance.name += "Item" + str(index) + "(" + str(get_child_count()) + ")"
	instance.add_child(item)
	instance.set_script(preload("res://ItemInstance.gd"))
	instance.set_meta("index", index)
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_node_from_packed_scene(scene: PackedScene):
	var instance = scene.instantiate()
	return instance
