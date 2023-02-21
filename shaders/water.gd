extends Sprite


func _ready():
	material.set_shader_param("spriteScale", scale);
