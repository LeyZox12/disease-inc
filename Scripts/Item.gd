class_name Item
extends Node

var inventory_sprite
var inventory_shape
var collision
var cut_size
var obj
var weight
var model
var equipable
var onUse

func get_shape_rotated(angle: int) -> Array:
	var rotated = inventory_shape.duplicate(true)
	for i in range(floor(angle / 90)):
		for j in range(inventory_shape.size()):
			var x = rotated[j].x
			var y = rotated[j].y
			rotated[j].x = 2 - 1 - y
			rotated[j].y = x
	return rotated
