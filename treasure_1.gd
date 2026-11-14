extends CharacterBody2D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	var collision := move_and_collide(velocity*delta)
	if collision:
		print(collision.get_collider().name)
	pass
