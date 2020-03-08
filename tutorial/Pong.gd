extends Node2D

var screen_size
var pad_size
var direction = Vector2(1.0,0.0)
var p1Score = 0
var p2Score = 0
var candynum = 0
var DisplayValue = 50
onready var timer = get_node("Timer")
var INITIAL_PLAYER_SPEED = 80
var player_speed = INITIAL_PLAYER_SPEED
var INTIAL_BALL_SPEED = 80
var PAD_SPEED = 150
var waittime = 30
var ball_speed = INTIAL_BALL_SPEED
var temptimer =0
onready var temp = get_node("explosive")
var ex = false
var bounceSFX
onready var ki = get_node("kid")
onready var fiery = ki.get_node("fiery")
onready var explosive = get_node("explosive")
var duration = 0.2
var frequency = 15
var amplitude = 16
var priority = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("kid").get_texture().get_size()
	bounceSFX = get_node("Bounce")
	set_process(true)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(temptimer-2>DisplayValue and ex == true):
			ex = false
			temp.set_position(get_node("bottle").position)
			temp.emitting = true
	waittime = waittime -1
	var bott_pos = get_node("bottle").position
	#var ball_pos = get_node("Ball").position
	var t = get_node("kid").position
	var ball_rect = Rect2(get_node("bottle").position,get_node("bottle").get_texture().get_size())
	var left_rect = Rect2(get_node("kid").position- pad_size* 0.5, pad_size)
	#var left_rect = Rect2(get_node("kid").position.x,get_node("kid").position.y, get_node("bottle").get_texture().get_size().x, get_node("bottle").get_texture().get_size().y)
	#var right_rect = Rect2(get_node("rightpaddle").position - pad_size* 0.5, pad_size)
	#ball_pos += (direction*ball_speed*delta)
	var left_pos = get_node("kid").position
	if(Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if(Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	if(Input.is_action_pressed("left_move_left")):
		left_pos.x += -PAD_SPEED * delta
	if(Input.is_action_pressed("left_move_right")):
		left_pos.x += PAD_SPEED * delta
		
	get_node("kid").set_position(left_pos)
	if(left_rect.has_point(bott_pos)):
		
		update_juice()
		candynum+=1
		PAD_SPEED+=100
		DisplayValue+=10
		var car = get_node("explosive").duplicate()
		car.position = get_node("bottle").position # use set_translation() if you are in 3D
		add_child(car) # parent could be whatever node in the scene that you want the car to be child of
		car.emitting = true
		bott_pos.x = randi()%int(screen_size.x) +1
		bott_pos.y = randi()%int(screen_size.y) +1
		get_node("bottle").set_position(bott_pos)
		temptimer = DisplayValue
		
	get_node("candyscore").bbcode_text = str(candynum)
	get_node("Candytimer").bbcode_text =  str(DisplayValue)
	if(waittime==0):
		waittime=30;
		DisplayValue+=-1;
		
		if(DisplayValue==0):
			DisplayValue = 60
		


func _on_Timer_timeout():
	DisplayValue+=-1;
	waittime = 60
	
func update_juice():
	ki.get_node("Line2D").set_width(ki.get_node("Line2D").get_width()+1)
	#fire variables
	fiery.get_process_material().set_emission_box_extents(Vector3(fiery.get_process_material().get_emission_box_extents().x,fiery.get_process_material().get_emission_box_extents().y+.1,fiery.get_process_material().get_emission_box_extents().z))
	fiery.set_amount(fiery.get_amount()+1)
	fiery.set_lifetime(fiery.get_lifetime()+.025)
	#fiery.get_process_material().set_param((fiery.get_process_material().get_param()+1))
	#explosive variables
	explosive.set_amount(explosive.get_amount()+20)
	#screen shake
	frequency = frequency + .005
	amplitude = amplitude +1
	priority = priority+ 1
	get_node("ScreenShake").start(duration,frequency,amplitude,priority)
