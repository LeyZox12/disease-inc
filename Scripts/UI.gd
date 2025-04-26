extends Node

const HOTBAR_MAX = 3
const INVENTORY_MAX = 5

var keys = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0]
var empty_sprite = preload("res://Assets/empty.png")
var inventory_out = false
var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_hotbar()
	init_inventory()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var SEPARATION = 25 / INVENTORY_MAX

	$Inventory.add_theme_constant_override("h_separation", SEPARATION)
	$Inventory.add_theme_constant_override("v_separation", SEPARATION)
	for i in range(INVENTORY_MAX):
		row.push_back(0)
	for i in range(INVENTORY_MAX):
		inventory.push_back(row)
	for l in inventory:
		for v in l:
			var button = Button.new()
			button.icon = empty_sprite
			button.add_theme_constant_override("icon_max_width", SIZE)
			$Inventory.add_child(button)
	$Inventory.pivot_offset.x = INVENTORY_MAX * SIZE * 0.5 + (INVENTORY_MAX-1) * SEPARATION * 0.5
	
	
func update_inventory():
	pass

func toggle_inventory():
	inventory_out = !inventory_out
	$Inventory.visible = inventory_out
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if inventory_out else Input.MOUSE_MODE_CAPTURED
