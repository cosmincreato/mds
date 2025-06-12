extends GutTest

func test_base_damage():
	var base_scene = load("res://scenes/entities/base.tscn")
	var base : Base = base_scene.instantiate()
	add_child(base)
	var health_component : HealthComponent = base.get_node_or_null("HealthComponent")
	health_component.take_damage(20)
	assert_eq(health_component.max_health - 20, health_component.health, "Base did not take the correct amount of damage.")


func test_ally_damage():
	var elf_scene = load("res://scenes/entities/allies/elf.tscn")
	var elf : Elf = elf_scene.instantiate()
	add_child(elf)
	var health_component : HealthComponent = elf.get_node_or_null("HealthComponent")
	health_component.take_damage(20)
	assert_eq(health_component.max_health - 20, health_component.health, "Ally did not take the correct amount of damage.")


func test_enemy_damage():
	var dragon_scene = load("res://scenes/entities/enemies/dragon.tscn")
	var dragon : Dragon = dragon_scene.instantiate()
	add_child(dragon)
	var health_component : HealthComponent = dragon.get_node_or_null("HealthComponent")
	health_component.take_damage(20)
	assert_eq(health_component.max_health - 20, health_component.health, "Enemy did not take the correct amount of damage.")
