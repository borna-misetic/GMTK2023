extends StaticBody2D

@export var time = 0
var electricity: Array

func _ready():
	$BreakerTimer.wait_time = time
	for child in get_children():
		if child.is_in_group("electricity"):
			electricity.append(child)

func _process(delta):
	pass


func disable_breaker():
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("emp")
	$BreakerTimer.start()
	for child in electricity:
		child.disable()


func _on_breaker_timer_timeout():
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("idle")
	for child in electricity:
		child.enable()
