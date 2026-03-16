extends State
class_name PlayerDeath
@onready var anim: AnimationTree = $"../../YBot/AnimationTree"

func Enter():
	anim["parameters/conditions/damage"] = true
	anim["parameters/TakeDamage/conditions/death"] = true
	
func Exit():
	anim["parameters/conditions/damage"] = false
	anim["parameters/TakeDamage/conditions/death"] = false
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass
