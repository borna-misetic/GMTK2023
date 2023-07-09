extends StaticBody2D

var bullets_left = [3,3,3]

@onready var firing_point = get_parent().get_node("FiringPoint")

const bullet_path = preload("res://scenes/bullet.tscn")
# shouldn't preload here, but who cares (not me)
const red_bullet = preload("res://assets/img/red-bullet.png")
const blue_bullet = preload("res://assets/img/blue-bullet.png")
const silver_bullet = preload("res://assets/img/silver-bullet.png")
var is_fired = false
var finished = true
var active_bullet = ""
var active_index = -1


func _input(event):
	if Input.is_action_just_pressed("shoot") and !is_fired and !$SwapMenu.visible and active_bullet != "" and bullets_left[active_index] > 0 and finished:
		is_fired = true
		var bullet = bullet_path.instantiate()
		bullet.position = firing_point.position
		$AnimationPlayer.play("shoot")
		finished = false
		await get_tree().create_timer(0.7).timeout
		match(active_bullet):
			"red":
				bullet.particle_color = Color(0.67,0.2,0.2)
				bullet.bullet_type = active_bullet
				bullet.set_color(red_bullet)
			"blue":
				bullet.particle_color = Color(0.22,0.6,0.6)
				bullet.bullet_type = active_bullet
				bullet.set_color(blue_bullet)
			"silver":
				bullet.particle_color = Color(0.61,0.68,0.71)
				bullet.bullet_type = active_bullet
				bullet.set_color(silver_bullet)
		bullets_left[active_index] -= 1
		get_parent().add_child(bullet)
		$Camera2D.enabled = false
		bullet.connect("destroyed", Callable(self, "on_destroyed"))
		bullet.connect("fail", Callable(self, "failed"))
		match(active_index):
			0: $SwapMenu/RedCount.text = str(bullets_left[active_index])
			1: $SwapMenu/BlueCount.text = str(bullets_left[active_index])
			2: $SwapMenu/SilverCount.text = str(bullets_left[active_index])
		await $AnimationPlayer.animation_finished
		finished = true
		$AnimationPlayer.play("idle")

	if Input.is_action_pressed("swap") and !is_fired:
		$SwapMenu.visible = true
	else:
		$SwapMenu.visible = false

func on_destroyed():
	is_fired = false
	$Camera2D.enabled = true


func _on_red_button_pressed():
	active_bullet = "red"
	active_index = 0


func _on_blue_button_pressed():
	active_bullet = "blue"
	active_index = 1


func _on_silver_button_pressed():
	active_bullet = "silver"
	active_index = 2


func failed():
	finished = false
	$AnimationPlayer.play("fail")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
