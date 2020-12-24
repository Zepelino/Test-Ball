extends Spatial

var rng = RandomNumberGenerator.new()

var foi = false

func _ready():
	rng.randomize()
	
	$Sun.rotation = Global.sunRot
	$CanvasLayer/Goals.bbcode_text = "Goals: %s"%[Global.gols]
	$Golo.translation = Vector3(rng.randf_range(-6,6),rng.randf_range(0,8),-13)

func _process(delta):
	$Sun.rotate(Vector3(1,0,0),delta/10)



func _on_Area_body_entered(body):
	Global.sunRot = $Sun.rotation
	if body.is_in_group("Ball") && !foi:
		foi = true
		Global.gols += 1
		$CanvasLayer/Goals.bbcode_text = "Goals: %s"%[Global.gols]
		$CanvasLayer/Texto.bbcode_text = "[wave amp=200 freq=20][center] Goal!!! [/center] [/wave]"
		$CanvasLayer/AnimationPlayer.play("Main")
		$CPUParticles.emitting = true


func _on_TouchDown_body_entered(body):
	Global.sunRot = $Sun.rotation
	if body.is_in_group("Ball") && !foi:
		foi = true
		$CanvasLayer/Texto.bbcode_text = "[wave amp=50 freq=5][center] Out [/center] [/wave]"
		$CanvasLayer/AnimationPlayer.play("Main")


func _on_AnimationPlayer_animation_finished(anim_name):
	Global.sunRot = $Sun.rotation
	get_tree().reload_current_scene()
