extends StaticBody2D

var electricity: Array

func _ready():
	for child in get_children():
		if child.is_in_group("electricity"):
			electricity.append(child)

func _process(delta):
	pass


func disable_breaker():
	$CollisionShape2D.disabled = true
	$BreakerTimer.start()
	for child in electricity:
		child.disable()


func _on_breaker_timer_timeout():
	$CollisionShape2D.disabled = false
	for child in electricity:
		child.enable()
