extends CharacterBody2D

@onready var animated: AnimatedSprite2D = $animated

const speed = 300.0
const jump = -400.0

#приоритет анимаций 
const  pr_idle = 1
const  pr_run = 1
const pr_jump = 2
const pr_fell = 1
const pr_attack = 3
var priority = 0

func _physics_process(delta: float) -> void:
	# гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta

	if global_position.y >= velocity.y && priority < pr_fell:
		animated.play("fell")
		priority = pr_fell

	# пражок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump
		if priority <= pr_jump: 
			animated.play("jump")
			priority = pr_jump

	# направление 
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# повернуть текстуру
	if direction < 0: animated.flip_h = true
	elif direction > 0: animated.flip_h = false
	
	# движение
	if direction:
		velocity.x = direction * speed
		if priority <= pr_run && is_on_floor(): 
			animated.play("run")
			priority = pr_run
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if priority <= pr_idle && is_on_floor(): 
			animated.play("idle")
			priority = pr_idle

	if Input.is_action_just_pressed("attack") && priority <= pr_attack:
		animated.play("attack")
		priority = pr_attack

	move_and_slide()

func _ready() -> void:
	animated.play("idle")


func _on_animated_animation_finished() -> void:
	priority = 0
