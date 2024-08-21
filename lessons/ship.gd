extends Area2D

var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0
var health:=10
var gem_count:=0
const MAX_HEALTH = 100
const MIN_HEALTH = 0
const HEALTH_PACK_HEAL_VALUE := 10
const BLACK_HOLE_DAMAGE_VALUE := 20
const GEM_VALUE :=1

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_health(health)

func _process(delta: float) -> void:
	

	var direction : Vector2 = Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	var direction_joystick : Vector2 = $CanvasLayer/JoyStick.get_joystick_dir()
	direction+=direction_joystick
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta
	
	if velocity.length() > 0.0:
		#so we don't rotate UI elements, we will only rotate the sprite
		get_node("Sprite2D").rotation = velocity.angle()

func set_health(new_health: int) -> void:
	if new_health < MIN_HEALTH:
		health = MIN_HEALTH
	else:
		health = min(new_health,MAX_HEALTH)
	get_node("UI/HealthBar").value=health

func set_gem_count(new_gem_count: int) -> void:
	gem_count = new_gem_count
	get_node("UI/GemCount").text="x"+str(gem_count)
	
func _on_area_entered(area_that_entered:Area2D) -> void:
	if area_that_entered.is_in_group("healing_item"):
		set_health(health + HEALTH_PACK_HEAL_VALUE)
	elif area_that_entered.is_in_group("black_hole"):
		set_health(health - BLACK_HOLE_DAMAGE_VALUE)
	elif area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + GEM_VALUE)

