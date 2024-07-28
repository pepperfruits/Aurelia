shader_type canvas_item;

uniform float top : hint_range(0, 1);
uniform float bottom : hint_range(0, 1);
uniform vec4 top_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	float height = UV.y;
	if (height < top) {
		height = 0.0;
	} else if (height > 1.0 - bottom){
		height = 1.0;
	} else{
		height = (height - top) * (1.0 / (1.0 - top - bottom));
	}
	
	COLOR.rgb = bottom_color.rgb * height + top_color.rgb * (1.0 - height);
}
