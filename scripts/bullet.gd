extends CharacterBody2D

signal destroyed

@export var move_speed = 10
@export var bullet_type = ""
var move_velocity = Vector2()
var is_in_deadzone = false

func _ready():
	pass

func _physics_process(delta):
	print(position)
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
		queue_free()
		emit_signal("destroyed")
	if body.is_in_group("vent"):
		if bullet_type == "red":
			body.queue_free()
		queue_free()
		emit_signal("destroyed")
	if body.is_in_group("breaker"):
		if bullet_type == "blue":
			body.call_deferred("disable_breaker")
		queue_free()
		emit_signal("destroyed")
	if body.is_in_group("target"):
		if bullet_type == "silver":
			get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
		elif bullet_type == "red":
			get_tree().reload_current_scene()
		else:
			queue_free()
			emit_signal("destroyed")

func set_color(color):
	$Sprite2D.texture = color
