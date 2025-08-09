// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform bool is_sprite;
uniform bool inverse_lighting;
uniform vec2 light_min_max;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	
	if (is_sprite) {
	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	ALPHA *= albedo.a * albedo_tex.a;
}

void light() {
	vec3 lightColor = LIGHT_COLOR / PI;
	vec3 diffuse_info = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * lightColor;
	if (!LIGHT_IS_DIRECTIONAL) {
		float alpha_mod = (diffuse_info.r + diffuse_info.g + diffuse_info.b) / 3.0;
		alpha_mod = clamp(alpha_mod - light_min_max.x, 0.0, 1.0);
		alpha_mod /= light_min_max.y - light_min_max.x;
		if (inverse_lighting) {
			alpha_mod = clamp(1.0 - alpha_mod, 0.0, 1.0);
		}
		ALPHA *= alpha_mod;
	}
	DIFFUSE_LIGHT += diffuse_info;
}