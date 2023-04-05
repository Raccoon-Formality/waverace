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

uniform sampler2D water;
uniform sampler2D noise;


uniform float amp: hint_range(0.0, 1.0, 0.01) = 0.1f;

varying vec3 normal;
varying vec2 uv;
float random (vec2 uv2) {
    return fract(sin(dot(uv2.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

varying vec4 worldPos;
void vertex() {
	//some_color = NORMAL; // make the normal the color
	
	normal = NORMAL;
	uv = (UV + offset) * value;
	
	worldPos = MODEL_MATRIX * vec4(VERTEX,1);
	float t = cos((UV.y + TIME * 0.1) * TAU * 2.0) * 0.5 ;
	
	float t2 =  cos((UV.x-0.2 + TIME * 0.1) * TAU * 2.0) * 0.5 + 0.5;
	VERTEX.y += clamp(t * t2* amp,-1.0,1.0);
	
}

float InverseLerp(float a, float b, float v) {
	return (v-a)/(b-a);
}

void fragment() {
	//ALBEDO = some_color; // normal from vertex to fragment
	//float t = clamp( InverseLerp(color_start,color_end,abs(fract(uv.x * 5.0)*2.0-1.0)), 0.0, 1.0 );
	
	//float t = smoothstep(color_start,color_end,uv.x);
	//t = fract(t);
	
	
	vec2 topdownProject = worldPos.xz;
    vec4 new_color = mix(color, color2, UV.y);
	float t = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	
	float t2 = cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	//ALPHA = clamp(1.0-UV.y, 0.0, 1.0);
	vec4 water_tex = texture(water,topdownProject-TIME*0.1);
	vec4 noise_tex = texture(noise,topdownProject*.2+TIME*0.1);
	
	vec4 final = mix(vec4(0.25,0.62,1.0,1.0), vec4(1.0), round(noise_tex.x-0.15));
	
	ALBEDO = clamp(final.rgb,0.0,1.0);//new_color.rgb;//vec3(uv.xy, 0);
	//ALPHA = 0.5;

}

