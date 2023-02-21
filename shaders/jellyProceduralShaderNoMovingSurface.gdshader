shader_type canvas_item;

uniform vec4 jellyTint: hint_color; //this tells the inspector that this variable is a color. We can find it under "shader parameters"
uniform vec2 spriteScale;
uniform float scaleX = 0.67;

float rand(vec2 coord){ //this function generates a rand nr for each pixel in the texture
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 coord){ //uses the rand function to make a noise texture
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	
	vec2 cubic = f * f * (3.0 - 2.0 * f);
	
return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment(){ //here we set the color of the pixel
	
	vec2 noisecoord1 = UV * spriteScale * scaleX; //UV is too large, so we make it smaller by mult.
	vec2 noisecoord2 = UV * spriteScale * scaleX + 4.0;
	
	vec2 motion1 = vec2(TIME * 0.3, TIME * -0.4);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 0.5);
	
	vec2 distort1 = vec2(noise(noisecoord1 + motion1), noise(noisecoord2 + motion1)) - vec2(0.5);
	vec2 distort2 = vec2(noise(noisecoord1 + motion2), noise(noisecoord2 + motion2)) - vec2(0.5);
	
	vec2 distortSum = (distort1 + distort2)/60.0;
	
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV + distortSum, 0.0); //vec4 because r,g,b and alpha. Here we set the color of a single pixel. Copy the color of the pixel that is underneath it
	
	color = mix(color, jellyTint, 0.6); //the last number is how much we want to mix it
	color.rgb = mix(vec3(0.5), color.rgb, 1.4); //adds more contrast by mixing in gray
	
	//MOVING SURFACE//
//	float nearTop = (UV.y + distortSum.y) / (0.2/spriteScale.y);
//	nearTop = clamp(nearTop, 0.0, 1.0);
//	nearTop = 1.0 - nearTop;
//
//	color = mix(color, vec4(1.0), nearTop);
//
//	float edgeLower = 0.6;
//	float edgeUpper = edgeLower + 0.1;
//
//	if(nearTop > edgeLower){
//		color.a = 0.0;
//
//		if(nearTop < edgeUpper){
//			color.a = (edgeUpper - nearTop) / (edgeUpper - edgeLower);
//		}
//	}
	////////////7////
	
	COLOR = color;
}