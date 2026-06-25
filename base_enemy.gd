extends CharacterBody2D

@export var notify:PackedScene
const SPEED = 50.0
const JUMP_VELOCITY = -400.0
enum State {PATROLING, ATTACKING}
var current_state = State.PATROLING
var direction = 1
var body_position =null
@onready var ledge_check = $RayCast2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		State.PATROLING:
			patrol()
		State.ATTACKING:
			attack(body_position)
	move_and_slide()
func damage_notify():
	var inst = notify.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.position = position
	
func patrol():
	velocity.x = direction*SPEED
	if is_on_wall() or not ledge_check.is_colliding():
		direction*=-1
		ledge_check.position.x = 20*direction
func attack(player_pos):
	print(player_pos)
	#pega pos faz o inimigo parar tudo e ir lá
	if body_position:
		var norm_pos = (player_pos.global_position - global_position).normalized()
		if norm_pos.length()<10:
			velocity.x= norm_pos.x*SPEED
		else:
			velocity.x = 0
			
	else:current_state = State.PATROLING
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("ai")
		damage_notify()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_position = body
		current_state = State.ATTACKING


func _on_detection_area_body_exited(body: Node2D) -> void:
	body_position = null
