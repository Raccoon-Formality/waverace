shader_type spatial;

const float color_mult = 1.0f;

uniform float scale: hint_range(0.0, 1.0, 0.001) = 1.0f;
uniform sampler2D grid_texture : source_color;
uniform sampler2D grid_texture2 : source_color;
uniform sampler2D grid_texture3 : source_color;
uniform float brightness: hint_range(0.0f, 1.0f) = 1.0f;
uniform float offset: hint_range(-1.0f, 1.0f) = 0.0f;
uniform float offset2: hint_range(-1.0f, 1.0f) = 0.0f;

vec4 triplanar_texture(sampler2D p_sampler,sampler2D p_sampler2,sampler2D p_sampler3,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy*scale) * p_weights.z;
	samp+= texture(p_sampler2,p_triplanar_pos.xz*scale) * p_weights.y;
	samp+= texture(p_sampler3,p_triplanar_pos.zy*scale * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 projected_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0) ;
	vec3 albedoX = texture(grid_texture, projected_coords.yz*scale).rgb;
	vec3 albedoY = texture(grid_texture2, projected_coords.xz*scale).rgb;
	vec3 albedoZ = texture(grid_texture3, projected_coords.zy*scale).rgb;
	vec3 world_normal = clamp(vec3(0.0,offset,0.0) + smoothstep(offset2,1.0,abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz),0.0,1.0) ;
	
	vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);
	
	//vec3 color_offset = random(floor(projected_coords.xyz));
	
	ALBEDO = clamp(triplanar_texture(grid_texture,grid_texture2,grid_texture3,normal_weights,projected_coords.xyz).rgb,0.0,1.0);//mix(vec3(0.0f), (albedoX * normal_weights.x + albedoY * normal_weights.y + albedoZ * normal_weights.z), brightness);

}
