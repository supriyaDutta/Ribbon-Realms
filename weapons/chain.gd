extends Node2D


@onready var links =$Area2D/Link 
var direction = Vector2(0,0)
var tip = Vector2(0,0)

const  ribbon_speed = 25
var flying = false
var hooked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	$Tip.global_position = tip
	if flying:
		var colliderObject = $Tip.move_and_collide((direction.normalized()) * ribbon_speed)
		if colliderObject:
			if !colliderObject.get_collider().name.find("HangerBox")==-1:
#			print_debug(colliderObject.get_collider().name.find(HangerBox))
				print_debug(colliderObject.get_collider().global_position)
			hooked = true
			flying = false
			
			print_debug("hooked")
	elif not hooked:
		if $Tip.position == self.position:
			return

		$Tip.position= Vector2(0,0)
	
	tip = $Tip.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if flying or hooked:
		var tip_loc = to_local(tip)
		$Tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
		links.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
		
		links.region_enabled=true
		links.position = tip_loc
		links.region_rect.size = Vector2(16,(tip_loc).length())

	elif not hooked:
		$Tip.rotation =0
		links.region_rect.size = Vector2(16,0)




func ribbon_throw(dir):
	flying = true
	direction = dir #.normalized()
	tip = self.global_position #here tip = tip position global

func ribbon_released():
	hooked = false
	flying = false




