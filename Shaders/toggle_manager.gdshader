shader_type canvas_item;

uniform float alpha : hint_range(0, 1);

void fragment() {
	COLOR.a *= alpha;
}

