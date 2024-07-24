shader_type canvas_item;

uniform float redness : hint_range(0, 1);

void fragment() {
	COLOR.rgb += vec3(redness, 0.0, 0.0);
}
