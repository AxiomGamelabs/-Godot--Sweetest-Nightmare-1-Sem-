shader_type canvas_item;

uniform vec4 tint: hint_color = vec4(1.0);

//for each pixel on the screen
void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV); //maps the screen textures to the screen coordinates
	
	color = mix(color, tint, 0.9); //mix the "transparent" color with the tint color. 1 = opaque, 0 = transparent
	color = mix(vec4(0.5), color, 1.9); //mixes a gray color (that does not change our jelly-tone) with the current color. Values > 1 make the jelly color "stronger"
	
	COLOR = color; //this makes it "transparent", because it just copies the color that is under it to the texture
}