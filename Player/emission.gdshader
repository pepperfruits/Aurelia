shader_type canvas_item;

uniform sampler2D emission_texture;
uniform vec4 glow_color : source_color = vec4(1.0);

void fragment()
{
	vec4 current_color = texture(TEXTURE,UV); // what's our current sprite pixel
	vec4 emission_color = texture(emission_texture,UV); // what's our current emission pixel
	
	COLOR = current_color + glow_color * texture(emission_texture, UV).a;
	COLOR.a = max(current_color.a, emission_color.a);
	COLOR.rgb = glow_color.rgb;
}