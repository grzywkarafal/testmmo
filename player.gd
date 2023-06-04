extends CharacterBody2D

const SPEED = 100.0
const ATTACK_DAMAGE = 10

var direction := Vector2.ZERO

@rpc("any_peer")
func set_controls(dir: Vector2):
	if str(multiplayer.get_remote_sender_id()) != str(name):
		return
	direction = dir

func update_controls():
	if not multiplayer.has_multiplayer_peer() or str(name) != str(multiplayer.get_unique_id()):
		return

	direction = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	# Normalize the direction vector to maintain constant speed.
	direction = direction.normalized()

	# TODO handle RPC visibility internally, sync controls only to server for now.
	if not multiplayer.is_server():
		set_controls.rpc_id(1, direction)


func _physics_process(delta):
	update_controls()

	# Calculate the movement vector.
	var movement = direction * SPEED * delta

	# Move the character using the movement vector.
	move_and_collide(movement)



