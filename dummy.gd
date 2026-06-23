extends CharacterBody2D

@export var notify:PackedScene
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
func damage_notify():
	var inst = notify.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.position = position
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("ai")
		damage_notify()
