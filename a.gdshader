shader_type spatial;

const float color_mult = 1.0f;

uniform float scale: hint_range(0.0, 10.0, 0.1) = 1.0f;
uniform sampler2D grid_texture : source_color;
uniform float brightness: hint_range(0.0f, 1.0f) = 1.0f;

void fragment() {
	vec4 projected_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 albedoX = texture(grid_texture, projected_coords.zy*scale).rgb;
	vec3 albedoY = texture(grid_texture, projected_coords.xz*scale).rgb;
	vec3 albedoZ = texture(grid_texture, projected_coords.xy*scale).rgb;
	vec3 world_normal = abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);
	
	//vec3 color_offset = random(floor(projected_coords.xyz));
	
	ALBEDO = mix(vec3(0.0f), (albedoX * normal_weights.x + albedoY * normal_weights.y + albedoZ * normal_weights.z), brightness);

}
