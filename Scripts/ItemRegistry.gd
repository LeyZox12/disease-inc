class_name ItemRegistry

var items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func register_item(inventory_sprite: Texture2D, inventory_shape, cut_size: Vector2, weight: float, model: Mesh, onUse: Callable):
	var item = Item.new()
	item.inventory_sprite = inventory_sprite
	item.inventory_shape = inventory_shape
	item.cut_size = cut_size
	var coll = ConvexPolygonShape3D.new()
	coll.points = model.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = coll
	item.collision = collision_shape
	item.model = MeshInstance3D.new()
	item.model.mesh = model
	item.weight = weight
	item.onUse = onUse
	items.push_back(item)
