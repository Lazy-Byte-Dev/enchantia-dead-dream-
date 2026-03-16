extends State
class_name PlayerDamage

@onready var anim: AnimationTree = $"../../YBot/AnimationTree"

@export var player_stats: Resource
@export var timer: float = 0.0

func Enter():
	anim["parameters/conditions/damage"] = true
	anim["parameters/TakeDamage/StateMachine/conditions/damage3"] = true
	
func Exit():
	anim["parameters/conditions/damage"] = false
	anim["parameters/TakeDamage/StateMachine/conditions/damage3"] = false
	player.is_kicked = false
	
func Update(delta: float):
	timer += delta
	
func Physics_Update(delta: float):
	if player_stats.health <= 0:
		Transitioned.emit(self, "Death")
	
	if timer >= 1.5:
		Transitioned.emit(self, "idle")
		timer = 0.0
	
