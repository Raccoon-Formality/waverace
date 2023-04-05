shader_type spatial;
//render_mode world_vertex_coords;
//render_mode depth_prepass_alpha;
render_mode unshaded;

uniform sampler2D texas;
uniform sampler2D pattern;
uniform sampler2D water;
varying vec4 worldPos;

float get_wave(vec2 uv_local){
	vec2 uv_centered = uv_local*2.0 -1.0;
	float radial_distance = length(uv_centered);
	float wave = cos((radial_distance - TIME * 0.1) * TAU * 5.0) * 0.5 +0.5 ;
	//wave *= 1.0-radial_distance;
	return wave;
}

void vertex() {
	//UV.x -= TIME * 0.1;
	
	float pattern_texture = texture(pattern, UV).x;
	
	float t = cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5 ;
	float t1 = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 ;
	VERTEX.y = get_wave(UV) * 0.1 * pattern_texture;
	worldPos = MODEL_MATRIX * vec4(VERTEX,1);
}



void fragment() {
	
	vec2 topdownProject = worldPos.xz;
	vec4 texas_texture = texture(texas, topdownProject);
	vec4 water_texture = texture(water, topdownProject.yx);
	float pattern_texture = texture(pattern, UV).x;
	
	vec4 final = mix(texas_texture, water_texture, pattern_texture);
	
	ALBEDO = vec3(final.rgb);
	//ALPHA = texas_texture.a;
	
	//ALBEDO = vec3(topdownProject,0);
}
