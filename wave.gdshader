shader_type spatial;
render_mode unshaded;
//render_mode world_vertex_coords;
//render_mode blend_add;
render_mode cull_disabled;


uniform vec4 color: source_color = vec4(0.5,0.5,0.5,0.1);
uniform vec4 color2: source_color = vec4(0.5,0.5,0.5,0.1);
uniform float color_start = 0.0;
uniform float color_end = 1.0;

uniform float amp: hint_range(0.0, 0.2, 0.01) = 0.1f;


varying vec4 worldPos;

void vertex() {
	float t = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 ;
	
	worldPos = MODEL_MATRIX * vec4(VERTEX,1);
	
	float wave = cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5;
	
	VERTEX.y += wave * amp;
}

float InverseLerp(float a, float b, float v) {
	return (v-a)/(b-a);
}

void fragment() {
    vec4 new_color = mix(color, color2, UV.x);
	//ALPHA = clamp(1.0-UV.x, 0.0, 1.0);
	//ALBEDO = new_color.rgb;
	float wave = cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5;
	ALBEDO.rgb = vec3(UV,0.0); //vec3(new_color.rgb);
}

