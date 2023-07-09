extends CharacterBody2D

signal destroyed
signal fail

@export var move_speed = 10
@export var bullet_type = ""
@export var particle_color : Color
var move_velocity = Vector2()
var is_in_deadzone = false
var hit = false

func _ready():
	$GPUParticles2D.process_material.color = particle_color

func _physics_process(delta):
	if !hit:
		var mouse_pos = get_global_mouse_position()
		if(!is_in_deadzone):
			var direction = (mouse_pos - position).normalized()
			move_velocity = (direction * move_speed)
			look_at(mouse_pos)
		move_and_collide(move_velocity)


func _on_mouse_deadzone_mouse_entered():
	is_in_deadzone = true


func _on_mouse_deadzone_mouse_exited():
	is_in_deadzone = false


func _on_collision_area_body_entered(body):
	if body.is_in_group("wall"):
		bullet_hit()
		await get_tree().create_timer($GPUParticles2D.lifetime).timeout
		queue_free()
		emit_signal("destroyed")
	elif body.is_in_group("vent"):
		bullet_hit()
		if bullet_type == "red":
			body.queue_free()
		await get_tree().create_timer($GPUParticles2D.lifetime).timeout
		queue_free()
		emit_signal("destroyed")
	elif body.is_in_group("breaker"):
		bullet_hit()
		if bullet_type == "blue":
			body.call_deferred("disable_breaker")
		await get_tree().create_timer($GPUParticles2D.lifetime).timeout
		queue_free()
		emit_signal("destroyed")
	elif body.is_in_group("target"):
		if bullet_type == "silver":
			bullet_hit()
			await get_tree().create_timer($GPUParticles2D.lifetime).timeout
			get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
		elif bullet_type == "red":
			bullet_hit()
			await get_tree().create_timer($GPUParticles2D.lifetime).timeout
			emit_signal("fail")
			queue_free()
			emit_signal("destroyed")
		else:
			bullet_hit()
			await get_tree().create_timer($GPUParticles2D.lifetime).timeout
			queue_free()
			emit_signal("destroyed")

func set_color(color):
	$Sprite2D.texture = color

func bullet_hit():
	hit = true
	$Sprite2D.visible = false
	$GPUParticles2D.emitting = true
	$Crash.play()
