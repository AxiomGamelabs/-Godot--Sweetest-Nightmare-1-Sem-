shader_type canvas_item;

uniform float blurFactor : hint_range(0, 6) = 0.5;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, blurFactor);
	COLOR = color;
}

