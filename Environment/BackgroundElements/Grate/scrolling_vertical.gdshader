shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0);

void vertex() {
	UV.y -= TIME * speed;
}


