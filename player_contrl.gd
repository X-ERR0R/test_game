extends CharacterBody2D

@onready var animated: AnimatedSprite2D = $animated

@export var speed:float = 300.0
@export var jump:float = -400.0
@export var max_speed_fell:float = 400.0
@export var max_h:float = -400
@export var mult_fell:float = 2
@export var mult_up:float = 0.5
@export var sky_freeze:float = 0.2

#приоритет анимаций 
const  pr_idle = 1
const  pr_run = 1
const pr_jump = 2
const pr_fell = 1
const pr_attack = 3
var priority = 0

func _physics_process(delta: float) -> void:

	if global_position.y < to_global(velocity).y  && priority <= pr_fell:
		animated.play("fell")
		priority = pr_fell

	# пражок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump
		if priority <= pr_jump: 
			animated.play("jump")
			priority = pr_jump

	# гравитация
	if velocity.y < 0: #двигается в верх
		velocity += get_gravity() * delta * mult_up
	elif velocity.y > 0: #двигается в вниз
		velocity += get_gravity() * delta * mult_fell
	else:
		velocity += get_gravity() * delta * sky_freeze

	if velocity.y > max_speed_fell:velocity.y = max_speed_fell
	

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


func _on_animated_frame_changed() -> void:
	if $animated.animation == "jump" && $animated.frame == 8:
		$animated.offset.y += 5
	else: $animated.offset.y = 0
