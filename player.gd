extends CharacterBody2D

enum State {IDLE,WALKING,ATTACKING,ROLLING}
var current_state = State.IDLE
const SPEED = 100.0
@onready var collision = $visual/hand/sword/CollisionShape2D
const JUMP_VELOCITY = -200.0
var can_attack = false
@onready var vis = $visual
@onready var sword = $visual/hand
@onready var player_anim = $visual/player_anim
@onready var sword_anin = $visual/hand/sword_anin
@onready var rollcooldown = $RollCooldown
func _ready() -> void:
	$visual/hand/sword_particle.emitting = false
	collision.disabled=true
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction := Input.get_axis("left", "right")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#STATE
	if current_state!=State.ATTACKING and current_state!=State.ROLLING:
		if Input.is_action_just_pressed("attack"):
			current_state = State.ATTACKING
		elif Input.is_action_just_pressed("roll"):
			current_state = State.ROLLING
		elif direction!=0:
			current_state = State.WALKING
		else:
			current_state =State.IDLE
		
	match current_state:
		State.IDLE:
			$visual/player_anim.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		State.WALKING:
			velocity.x = direction * SPEED
			if direction!=0:
				vis.scale.x = 1 if direction > 0 else -1	
			else:
				current_state = State.IDLE
		State.ATTACKING:
			velocity.x = 0
			attack()
		State.ROLLING:
			roll()
			
				

	move_and_slide()
			
			
func roll():
	if rollcooldown.is_stopped() and player_anim.current_animation!="roll":
		player_anim.play("roll")
		rollcooldown.start()
		var roll_direction = vis.scale.x
		velocity.x = roll_direction * 100
		print("rolando")
		await player_anim.animation_finished
		finish_roll()
func attack():
	if player_anim.current_animation != "attack1":
		player_anim.play("attack1")
		print("attacando")
		await player_anim.animation_finished
		finish_attack()

func on_hitbox():
	print("ativou")
	collision.disabled = false
	$visual/hand/sword_particle.emitting = true

func off_hitbox():	
	print("desativou")
	collision.disabled = true
	$visual/hand/sword_particle.emitting = false

	
	
	
func player_on_hitbox():
	print("ativou")
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
func player_off_hitbox():	
	print("desativou")
	set_collision_mask_value(1, false)
	
	
func finish_attack():
	current_state = State.IDLE # Ou volte para IDLE/WALKING
func finish_roll():
	current_state = State.IDLE # Ou volte para IDLE/WALKING
