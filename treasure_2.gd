extends CharacterBody2D

@onready var treasureSprite = $CollisionShape2D/Sprite2D 
@onready var player = $"../Player"

var rng = RandomNumberGenerator.new()
var collision_counter = 0
var burger_unlocked = false
var burger_eaten = false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	if not burger_eaten:	
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.name == "Player":
				collision_counter += 1
				velocity = Vector2(rng.randf_range(-1000,1000), rng.randf_range(-1200,-700))
		if collision_counter > 15 and not burger_unlocked:
			burger_unlocked = true
			treasureSprite.texture = load("res://burger.png")
			treasureSprite.scale = Vector2(0.25,0.25)
			collision_counter = 0
		if burger_unlocked and collision_counter > 30:
			burger_eaten = true
			hide()
			scale = Vector2(0,0)
			player.HP += 75
			player.JUMP_VELOCITY -= 150
		if position.y > 4000:
			position = Vector2(0,0)
	pass
