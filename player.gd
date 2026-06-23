extends CharacterBody2D

enum State {IDLE,WALKING,ATTACKING,ROLLING}
var current_state = State.IDLE
const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var can_attack = false
@onready var vis = $visual
@onready var sword = $visual/hand
@onready var rollcooldown = $RollCooldown
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
	if current_state!=State.ATTACKING:
		if Input.is_action_just_pressed("attack"):
			current_state = State.ATTACKING
			attack()
		elif Input.is_action_just_pressed("roll"):
			roll()
		elif direction!=0:
			current_state = State.WALKING
		else:
			current_state =State.IDLE
		
	match current_state:
		State.IDLE:
			if $visual/player_anim.current_animation != "idle":
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
		State.ROLLING:
			pass
			
				

	move_and_slide()
			
			
func roll():
	if rollcooldown.is_stopped():
		current_state = State.ROLLING
		rollcooldown.start()
		$visual/player_anim.play("roll")
		var roll_direction = vis.scale.x
		var tween = create_tween()
		velocity.x = roll_direction * 600
		tween.tween_callback(finish_roll)
		print("rolando",velocity)

func attack():
	current_state = State.ATTACKING
	var tween = create_tween()
	print("attacando")
	tween.tween_property(sword,"rotation_degrees",90,0.1)
	tween.tween_property(sword,"rotation_degrees",0,0.05)
	tween.tween_callback(finish_attack)

func finish_attack():
	current_state = State.IDLE # Ou volte para IDLE/WALKING
func finish_roll():
	velocity.x = 0
	current_state = State.IDLE # Ou volte para IDLE/WALKING
