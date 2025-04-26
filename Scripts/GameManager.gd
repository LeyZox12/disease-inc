extends Node

var registry = ItemRegistry.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cube = Mesh.new()
	cube = BoxMesh.new()
	registry.register_item(
		preload("res://Assets/multiple_slot_item_3.png"),
		[Vector2(0,0), Vector2(1,0), Vector2(0,1)],
		5.0,
		preload("res://Assets/untitled.obj"),
		func():pass
	)
	add_item_to_world(0, Vector3(0, 1.7, -1.4))
	pass # Replace with function body.


func add_item_to_world(index, pos):
	var instance = RigidBody3D.new()
	instance.freeze = true
	var item = registry.items[index]
	instance.position = pos
	instance.add_child(item.model)
	instance.add_child(item.collision)
	instance.mass = item.weight
	instance.name = "Item"
	add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
