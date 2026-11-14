extends CharacterBody2D

@onready var timer := $Timer

const SPEED = 900.0
const JUMP_VELOCITY = -900.0

func _ready():
	print(self.name)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

var jumped = false
var leftover_jump_velocity = 0
var combo = 0
var counter = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		counter = 0
		jumped = true
		if leftover_jump_velocity < -600:
			combo += 1
			velocity.y = (JUMP_VELOCITY*.25 + leftover_jump_velocity)*1.00125
		else: 
			velocity.y = JUMP_VELOCITY
		print("combo: ", combo)
		leftover_jump_velocity = velocity.y

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if jumped and is_on_floor():
		print(counter/delta)
		if (counter / delta) > 3:
			combo = 0
			print("combo: ", combo)
			leftover_jump_velocity *= 0.9
			velocity.y = leftover_jump_velocity
			counter = 0
	if is_on_floor():
		counter += delta
	
func bounce():
	return

func _on_mouse_entered() -> void:
	self.scale += Vector2(1,1)

func _on_mouse_exited() -> void:
	self.scale -= Vector2(1,1)
