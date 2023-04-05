shader_type spatial;
render_mode unshaded;
//render_mode world_vertex_coords;
render_mode blend_add;
render_mode cull_disabled;


uniform float value = 2.0;
uniform float offset = 0.0;
uniform vec4 color: source_color = vec4(0.5,0.5,0.5,0.1);
uniform vec4 color2: source_color = vec4(0.5,0.5,0.5,0.1);
uniform float color_start = 0.0;
uniform float color_end = 1.0;

uniform float amp: hint_range(0.0, 0.2, 0.01) = 0.1f;

varying vec3 normal;
varying vec2 uv;
void vertex() {
	//some_color = NORMAL; // make the normal the color
	
	normal = NORMAL;
	uv = (UV + offset) * value;
	
	vec3 f = ((sin(VERTEX.y * 2.0 + TIME * 1.0) * 0.5 + 0.5) * 5.0) * NORMAL;
	
	float t = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	
	VERTEX += f * amp;
}

float InverseLerp(float a, float b, float v) {
	return (v-a)/(b-a);
}

void fragment() {
	//ALBEDO = some_color; // normal from vertex to fragment
	//float t = clamp( InverseLerp(color_start,color_end,abs(fract(uv.x * 5.0)*2.0-1.0)), 0.0, 1.0 );
	
	//float t = smoothstep(color_start,color_end,uv.x);
	//t = fract(t);
	
	float xOffset = cos(UV.x * TAU * 8.0) * 0.01;
	
	float t = cos((UV.y + xOffset + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	t *= UV.y;
	vec4 new_color = mix(color, color2, UV.y);
	
	
	ALPHA = 1.0-t * UV.y;
	ALBEDO = vec3(t*new_color.rgb);//new_color.rgb;//vec3(uv.xy, 0);

}

