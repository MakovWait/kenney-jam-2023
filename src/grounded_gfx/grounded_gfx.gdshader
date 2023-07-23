shader_type canvas_item;

uniform vec4 original: source_color;
uniform vec4 replacement: source_color;

const float precision = 0.1;

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV);
	COLOR = mix(curr_color, replacement, step(distance(curr_color, original), precision));
}
