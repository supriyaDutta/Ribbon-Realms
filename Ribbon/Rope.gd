extends Node2D

var ribbon_piece = preload("res://Ribbon/ribbon.tscn")
@onready var ribbon_start_piece = $RibbonStartpiece
@onready var ribbon_end_piece = $RibbonEndpiece
@onready var ribbon_start_joint = $RibbonStartpiece/CollisionShape2D/PinJoint2D
@onready var ribbon_end_joint = $RibbonEndpiece/CollisionShape2D/PinJoint2D

var piece_length = 20.0
var rope_parts = []
var ribbon_close_tolerance = 20.0
var ribbon_points= []

func _process(_delta):
	get_ribbon_points()
	if !ribbon_points.is_empty():
		queue_redraw()

func spawn_rope(start_pos, end_pos):	
	ribbon_start_piece.global_position = start_pos
	ribbon_end_piece.global_position= end_pos
	
	start_pos = ribbon_start_joint.global_position
	end_pos = ribbon_end_joint.global_position
	
	var ribbon_distance = start_pos.distance_to(end_pos)
	var pieces_amount = ribbon_distance/piece_length
	var spawn_angle = (end_pos-start_pos).angle() - PI/2
	create_ribbon(pieces_amount, ribbon_start_piece, end_pos, spawn_angle)
#
#	for i in segment_amount:
#		print_debug(i)


func create_ribbon(pieces_amount, parent, end_pos, spawn_angle):
	for i in pieces_amount:
		parent = add_pieces(parent, i, spawn_angle)
		parent.set_name("rope_piece" + str(i))
		rope_parts.append(parent)
		
		var joint_pos = parent.get_node("CollisionShape2D/PinJoint2D").global_position
		if joint_pos.distance_to(end_pos) < ribbon_close_tolerance:
			break
	ribbon_end_joint.node_a = ribbon_end_piece.get_path()
	ribbon_end_joint.node_b = rope_parts[-1].get_path()
	
func add_pieces(parent, id, spawn_angle):
	var joint = parent.get_node("CollisionShape2D/PinJoint2D") as PinJoint2D
	var piece = ribbon_piece.instantiate() as Object
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	
	return piece
	
func get_ribbon_points():
	ribbon_points.clear()
	ribbon_points.append(ribbon_start_joint.global_position)
	for r in rope_parts:
		ribbon_points.append(r.global_position)
	ribbon_points.append(ribbon_end_joint.global_position)


func _draw():
	draw_polyline(ribbon_points,Color.BURLYWOOD)
