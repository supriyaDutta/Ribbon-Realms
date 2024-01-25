extends Node2D

@onready var ropeClass = preload("res://Ribbon/rope.tscn")
var start_pos = Vector2.ZERO
var end_pos = Vector2.ZERO
@onready var player_pos = $player.global_position

#func _input(event):
#	if event is InputEventMouseButton and !event.is_pressed():
#		if start_pos == Vector2.ZERO:
#			start_pos = player_pos
##		elif end_pos == Vector2.ZERO:
#			end_pos = get_global_mouse_position()
#			var ropeObject = ropeClass.instantiate()
#			add_child(ropeObject)
#			ropeObject.spawn_rope(start_pos, end_pos)
#			start_pos = Vector2.ZERO
#			end_pos = Vector2.ZERO

func _process(delta):
	start_pos = player_pos
	
