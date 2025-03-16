shader_type canvas_item;

void fragment() {
	vec4 main_tex = texture(TEXTURE, UV);
	float gray_intensity = dot(main_tex.rgb, vec3(0.299, 0.587, 0.144));
	COLOR = vec4(vec3(gray_intensity), main_tex.a);
}
