extends CharacterBody2D

@export var GRAVITY = 1500;
@export var MOVE_SPEED = 200;
@export var JUMP_FORCE = 400;

var grounded: bool;
var direction: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	grounded = is_on_floor();
	
	direction.x = Input.get_axis("ui_left", "ui_right");
	
	if !grounded:
		direction.y += GRAVITY * delta;
	else:				
		direction.y = 0;
	
	if Input.is_action_just_pressed("player1_jump") and grounded:
			direction.y = -JUMP_FORCE;
	
	if Input.is_action_just_pressed("player2_shoot"):
		print("BANG!");
	
	velocity.x = direction.x * MOVE_SPEED;
	velocity.y = direction.y;
	
	move_and_slide();
	
	pass;
	
