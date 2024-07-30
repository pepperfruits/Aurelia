shader_type canvas_item;

uniform float speed : hint_range(0.0, 1.0);

void vertex() {
	UV.x += TIME * speed;
}


