extends StaticBody2D


func _ready():
	pass


func _process(delta):
	pass


func disable():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true


func enable():
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = false
