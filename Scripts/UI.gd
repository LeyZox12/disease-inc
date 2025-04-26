extends Node

const HOTBAR_MAX = 3
const INVENTORY_MAX = 5

var keys = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0]
var empty_sprite = preload("res://Assets/empty.png")
var inventory_out = false
var inventory = []

@onready var game_manager = $"../../.."

var is_sorting_inv = false
var current_item = null
var current_rot = 0
var current_obj = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_hotbar()
	init_inventory()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_sorting_inv and current_item >= 0:
		var mousepos = get_viewport().get_mouse_position()
		var sprite = game_manager.registry.items[current_item].inventory_sprite
		if get_child_count() < 5:
			var item_instance = TextureRect.new()
			item_instance.name = "item_instance"
			item_instance.texture = sprite
			item_instance.scale *= 2.0
			add_child(item_instance)
		else:
			$item_instance.rotation = current_rot * 3.141592654 / 180.0
			$item_instance.position = get_viewport().get_mouse_position()

	for i in range(INVENTORY_MAX):
		for j in range(INVENTORY_MAX):
			if inventory[j][i] != 0:
				var icon = AtlasTexture.new()
				var index = inventory[j][i]
				var full_sprite = game_manager.registry.items[floor(index)].inventory_sprite
				var size = Vector2(full_sprite.get_width(), full_sprite.get_height())
				var cut_size = game_manager.registry.items[floor(index)].cut_size
				var cut_amounts = size / cut_size
				var atlas_index = (index - floor(index)) * 10 - 1
				var x = fmod(atlas_index,cut_amounts.x)
				var y = floor(atlas_index / cut_amounts.y)
				icon.atlas = full_sprite
				var region_rect = Rect2(size.x / cut_amounts.x * x, size.y / cut_amounts.y * y, size.x / cut_amounts.x, size.y / cut_amounts.y)
				#print(size.x, size.y, cut_amounts)
				icon.region = region_rect
				$Inventory.get_child(i + j * INVENTORY_MAX).icon = icon
	pass


func init_hotbar():
	for i in range(HOTBAR_MAX):
		InputMap.add_action(str(i+1))
		var IEK = InputEventKey.new()
		IEK.keycode = keys[i]
		InputMap.action_add_event(str(i+1), IEK)
		var button = Button.new()
		button.add_theme_constant_override("icon_max_width", 16)
		button.icon = empty_sprite
		$Hotbar.add_child(button)
	$Hotbar.pivot_offset.x = HOTBAR_MAX * 8 + HOTBAR_MAX * 2.5 


func init_inventory():
	$Inventory.columns = INVENTORY_MAX
	var row = []
	var RATIO = 5.0 / INVENTORY_MAX
	var SIZE = 80 / INVENTORY_MAX

	$Inventory.add_theme_constant_override("h_separation", 0)
	$Inventory.add_theme_constant_override("v_separation", 0)
	for i in range(INVENTORY_MAX):
		row.push_back(0)
	for i in range(INVENTORY_MAX):
		inventory.push_back(row.duplicate(true))
	for l in inventory:
		for v in l:
			var button = Button.new()
			button.icon = empty_sprite
			button.add_theme_constant_override("icon_max_width", SIZE)
			$Inventory.add_child(button)
	$Inventory.pivot_offset.x = INVENTORY_MAX * $Inventory.get_child(0).size.x * 0.5


func update_inventory():
	pass


func toggle_inventory():
	inventory_out = !inventory_out
	$Inventory.visible = inventory_out
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if inventory_out else Input.MOUSE_MODE_CAPTURED


func add_item(item: RigidBody3D):
	if not $Inventory.visible: toggle_inventory()
	current_item = item.get_meta("index")
	current_obj = item
	is_sorting_inv = true

func OnRotate():
	current_rot += 90

func OnClick():
	if is_sorting_inv:
		var indexes = []
		for i in range(game_manager.registry.items[current_item].inventory_shape.size()):
			var index = $Inventory.get_local_mouse_position() / $Inventory.get_child(0).size
			index.x = floor(index.x) + game_manager.registry.items[current_item].inventory_shape[i].x
			index.y = floor(index.y) + game_manager.registry.items[current_item].inventory_shape[i].y
			if not get_index_valid(index): return
			indexes.push_back(index)
		for i in range(indexes.size()):
			inventory[indexes[i].y][indexes[i].x] = current_item + 0.1 * (i + 1)
		current_item = -1
		is_sorting_inv = false
		$item_instance.queue_free()
		current_obj.queue_free()
			
			
			
func get_index_valid(index: Vector2) -> bool:
	var max = floor($Inventory.get_child_count() / $Inventory.columns) -1
	if index.x < 0 or index.x > max or index.y < 0 or index.y > max or inventory[index.y][index.x] != 0:
		$Label.add_message("Can't do that !", 1.0)
		return false
	return true
