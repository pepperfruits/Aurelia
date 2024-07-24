shader_type canvas_item;
render_mode blend_add;
uniform vec2 rect_size = vec2(.1, .1);
uniform float bness = 1.0;
void fragment() {
	vec2 uv = UV - vec2(.5);
	vec2 cloest_rect_point; 
	cloest_rect_point = uv;
	if (uv.x > rect_size.x) {
		cloest_rect_point.x = rect_size.x;
	}
	if (uv.x < -rect_size.x) {
		cloest_rect_point.x = -rect_size.x;
	}
	if (uv.y > rect_size.y) {
		cloest_rect_point.y = rect_size.y;
	}
	if (uv.y < -rect_size.y) {
		cloest_rect_point.y = -rect_size.y;
	} 
	vec2 cuv = uv - cloest_rect_point;
	float d2c = length(cuv);
	COLOR.a = - log(d2c*3.) * bness; 
}