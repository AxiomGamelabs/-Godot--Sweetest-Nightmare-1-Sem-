shader_type canvas_item;

uniform vec4 color: hint_color;
uniform float lowerStep = 0.2;
uniform float upperStep = 3.0;

uniform float blurFactor : hint_range(0, 6) = 0.5;
uniform float colorFactor : hint_range(0, 1) = 0.5;


void fragment()
{
	float value = distance(UV, vec2(0.5));
	float factor = smoothstep(lowerStep, upperStep, value);
	
	vec4 blurred = texture(SCREEN_TEXTURE, SCREEN_UV, blurFactor);
	vec4 darkBlurred = mix(blurred, color, colorFactor); //zw. color und blurred 
	
	vec4 unblurred = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	COLOR = mix(unblurred, darkBlurred, factor);
}


//shader_type canvas_item;
//
//uniform float blurFactor : hint_range(0, 6) = 0.5;
//
//void fragment(){
//	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, blurFactor);
//	COLOR = color;
//}