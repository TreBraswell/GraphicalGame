extends Node2D

var screen_size
var pad_size
var direction = Vector2(1.0,0.0)
var p1Score = 0
var p2Score = 0

var INITIAL_PLAYER_SPEED = 80
var player_speed = INITIAL_PLAYER_SPEED
var INTIAL_BALL_SPEED = 80
const PAD_SPEED = 150
var ball_speed = INTIAL_BALL_SPEED

var bounceSFX
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("leftpaddle").get_texture().get_size()
	bounceSFX = get_node("Bounce")
	set_process(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_pos = get_node("Ball").position
	var t = get_node("leftpaddle").position
	var left_rect = Rect2(get_node("leftpaddle").position - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("rightpaddle").position - pad_size* 0.5, pad_size)
	ball_pos += (direction*ball_speed*delta)
	var left_pos = get_node("leftpaddle").position
	if(left_pos.y>0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if(left_pos.y<screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	if(left_pos.x>0 and Input.is_action_pressed("left_move_left")):
		left_pos.x += -PAD_SPEED * delta
	if(left_pos.x<screen_size.x and Input.is_action_pressed("left_move_right")):
		left_pos.x += PAD_SPEED * delta
	get_node("leftpaddle").set_position(left_pos)
	
	var right_pos = get_node("rightpaddle").position
	var right_size = get_node("rightpaddle").texture.get_size()
	
	if(ball_pos.x <screen_size.x * 0.5):
		right_pos.y = right_pos.y +(ball_pos.y - right_pos.y) *delta
	elif(ball_pos.x> screen_size.x *.5):
		right_pos.y = right_pos.y + (ball_pos.y - right_pos.y)* 4 * delta
	get_node("rightpaddle").set_position(right_pos)
	var ball_size = get_node("Ball").texture.get_size()
	if(ball_pos.y<0 or (ball_pos.y> screen_size.y)):
		direction.y *= -1
		bounceSFX.play()
	if((left_rect.has_point(ball_pos) and direction.x <0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x *= -1
		direction.y = randf() * 2.0 -1
		direction = direction.normalized()
		ball_speed *=1.1
		bounceSFX.play()
	if(ball_pos.x<0):
		p2Score +=1
		ball_pos = screen_size*.5
		ball_speed =INTIAL_BALL_SPEED
		direction = Vector2(-1,0)
	elif(ball_pos.x > screen_size.x):
		p1Score +=1
		ball_pos = screen_size * .5
		ball_speed = INTIAL_BALL_SPEED
		direction = Vector2(-1,0)
	
	get_node("Ball").set_position(ball_pos)
	get_node("P1 Score").bbcode_text = "[center]" + str(p1Score) + "[/center]"
	get_node("P2 Score").bbcode_text = "[center]" +str(p2Score) +"[/center]"
		
