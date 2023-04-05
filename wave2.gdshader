shader_type spatial;
render_mode unshaded;
//render_mode world_vertex_coords;
//render_mode blend_add;
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
float random (vec2 uv2) {
    return fract(sin(dot(uv2.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float get_wave(vec2 uv_local){
	vec2 uv_centered = uv_local*2.0 -1.0;
	float radial_distance = length(uv_centered);
	float wave = cos((radial_distance - TIME * 0.1) * TAU * 5.0) * 0.5 +0.5 ;
	wave *= 1.0-radial_distance;
	return wave;
}


void vertex() {
	//some_color = NORMAL; // make the normal the color
	
	normal = NORMAL;
	uv = (UV + offset) * value;
	
	VERTEX.y = get_wave(UV) * amp;
	
	//float t = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	
	//float t2 =  cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	//VERTEX.y = t * amp;
}

float InverseLerp(float a, float b, float v) {
	return (v-a)/(b-a);
}

void fragment() {
	//ALBEDO = some_color; // normal from vertex to fragment
	//float t = clamp( InverseLerp(color_start,color_end,abs(fract(uv.x * 5.0)*2.0-1.0)), 0.0, 1.0 );
	
	//float t = smoothstep(color_start,color_end,uv.x);
	//t = fract(t);
	
	
    vec4 new_color = mix(color, color2, UV.y);
	
	//ALPHA = clamp(1.0-UV.y, 0.0, 1.0);
	//ALBEDO = clamp(vec3(new_color.rgb*get_wave(UV)),0.0,1.0);//new_color.rgb;//vec3(uv.xy, 0);
	ALBEDO = vec3(get_wave(UV) * amp);
}

