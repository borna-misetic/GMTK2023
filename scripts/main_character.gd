extends StaticBody2D

var bullets_left = [3,3,3]

@onready var firing_point = get_parent().get_node("FiringPoint")

const bullet_path = preload("res://scenes/bullet.tscn")
# shouldn't preload here, but who cares (not me)
const red_bullet = preload("res://assets/img/red-temp.png")
const blue_bullet = preload("res://assets/img/blue-temp.png")
const silver_bullet = preload("res://assets/img/silver-temp.png")
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
		get_parent().add_child(bullet)
		$Camera2D.enabled = false
		bullet.connect("destroyed", Callable(self, "on_destroyed"))
		match(active_bullet):
			"red": 
				bullet.bullet_type = active_bullet
				bullet.set_color(red_bullet)
			"blue": 
				bullet.bullet_type = active_bullet
				bullet.set_color(blue_bullet)
			"silver": 
				bullet.bullet_type = active_bullet
				bullet.set_color(silver_bullet)
		bullets_left[active_index] -= 1
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
