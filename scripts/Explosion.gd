extends AnimatedSprite


func _on_explosion_animation_finished():
	# print("suppression de l'explosion")
	self.queue_free()