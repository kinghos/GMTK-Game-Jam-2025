shader_type canvas_item;

// --- Uniforms --- //
uniform bool weighted = true;	// Determines whether to use normal or weighted averages
uniform bool enabled = true;
void fragment() {
	if (enabled) {
		COLOR.rgb = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), float(weighted));
	}
}