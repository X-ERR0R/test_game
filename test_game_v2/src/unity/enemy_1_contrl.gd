extends CharacterBody2D

@export var speed = 250.0

@onready var animeted: AnimatedSprite2D = $animeted

var Body:Node2D = null
var agr:bool = false

const pr_attack = 2
const pr_idle = 1
const pr_run = 1
var priority = 0

func _physics_process(delta: float) -> void:

	# гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta

# определение направления
	var direction = 0
	if agr:
		if global_position.x < Body.global_position.x:
			direction = 1
			if priority <= pr_run:animeted.play("run")
		elif global_position.x > Body.global_position.x:
			direction = -1
			if priority <= pr_run:animeted.play("run")
		else :
			direction = 0
			if priority <= pr_idle:animeted.play("idle")

		if direction == 1:animeted.flip_h = false
		elif direction == -1:animeted.flip_h = true

	# движение на игрока
	velocity.x = speed * direction

	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	agr = true
	Body = body


func _on_detector_body_exited(body: Node2D) -> void:
# остановка при покидании области
	agr = false
	animeted.play("idle")


func _on_area_atck_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
