extends CharacterBody2D

@onready var timer := $Timer
@onready var hpLabel := $"../Control/CanvasLayer/HP"
@onready var comboLabel := $"../Control/CanvasLayer/Combo"
@onready var gameOverLabel := $"../Control/CanvasLayer/GameOver"
@onready var burger3 := $"../Treasure 3"

const SPEED = 900.0
var JUMP_VELOCITY = -900.0
var BOUNCE_VELOCITY = 0
const BOUNCE_VELOCITY_DECREASE_SCALE = 0.7
var HP: int

func _ready():
	hpSetter(50)
	comboSetter(0)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

var jumped = false
var leftover_jump_velocity = 0
var COMBO: int
var counter = 0

func _physics_process(delta: float) -> void:
	if not burger3.visible:
		gameOverLabel.show()
		gameOverLabel.text = "BURGERSSSSSS!!!!"
	if HP == 0:
		gameOverLabel.show()
		gameOverLabel.text = "You lost the burgers..."
	if not gameOverLabel.visible:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
			#BOUNCE_VELOCITY = JUMP_VELOCITY
			counter = 0
			jumped = true
			if leftover_jump_velocity < -600:
				comboSetter(COMBO+1)
				velocity.y = (JUMP_VELOCITY*.25 + leftover_jump_velocity)*1.00125
			else: 
				velocity.y = JUMP_VELOCITY
			leftover_jump_velocity = velocity.y

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if is_on_floor():
			counter += delta
			if (counter / delta) > 6 and leftover_jump_velocity < -200:
				hpSetter(HP-1)
				comboSetter(0)
				leftover_jump_velocity *= 0.9
				velocity.y = leftover_jump_velocity
				counter = 0
		print(position.y)
		if not is_on_floor() and position.y > 4000:
			position = Vector2(0,0)
	
func hpSetter(new):
	HP = new
	hpLabel.text = "HP: " + str(HP)

func comboSetter(new):
	COMBO = new
	comboLabel.text = "Combo: " + str(COMBO)

func _on_mouse_entered() -> void:
	self.scale += Vector2(1,1)

func _on_mouse_exited() -> void:
	self.scale -= Vector2(1,1)
