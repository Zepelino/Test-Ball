extends RigidBody

var rng = RandomNumberGenerator.new()

var dir := Vector3()

var force: float
var increase: bool = true
var canShoot: bool = true

var lcp := Vector3.ZERO
var nfoi = true

func _ready():
	rng.randomize()
	translation.x = rng.randf_range(-6,6)

func _physics_process(delta):
	
	if len(get_colliding_bodies()) > 0:
		if get_colliding_bodies()[0].is_in_group("Traves") && !get_parent().foi:
			get_parent().foi = true
			$"../CanvasLayer/Texto".bbcode_text = "[wave amp=50 freq=5][center] Post [/center] [/wave]"
			$"../CanvasLayer/AnimationPlayer".play("Main")
		elif get_colliding_bodies()[0].is_in_group("Gol") && nfoi:
			nfoi = false
			$"../CPUParticles".translation = lcp

func _integrate_forces(state):
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		lcp = state.get_contact_collider_position(0)

func _process(delta):
	
	if Input.is_action_pressed("click") && canShoot:
		var maxi = get_node("../CanvasLayer/ForceBar").max_value
		if increase:
			force += delta*100
			if force >= maxi:
				force = maxi
				increase = false
		else:
			force -= delta*100
			if force <= 0:
				force = 0
				increase = true
		get_node("../CanvasLayer/ForceBar").value = force
	
	if Input.is_action_just_released("click") && canShoot:
		if ray() != null:
			canShoot = false
			$DieTimer.start()
			dir = (ray() - translation).normalized()
			apply_impulse(Vector3.ZERO,dir*force)

func ray():
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_node("../Camera")
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_world().get_direct_space_state()
	var result = space_state.intersect_ray( from, to, get_tree().get_nodes_in_group("Ball"))
	
	return result.get("position")


func _on_DieTimer_timeout():
	Global.sunRot = get_node("../Sun").rotation
	get_tree().reload_current_scene()
