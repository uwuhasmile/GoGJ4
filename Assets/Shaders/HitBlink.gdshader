shader_type canvas_item;

uniform bool active = false;
uniform float frequency = 2.0;
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 previous_color = texture(TEXTURE, UV);
    vec4 colored = vec4(color.r, color.g, color.b, previous_color.a * color.a);
    vec4 new_color = previous_color;
    if (active == false || mod(abs(TIME), frequency * 2.0) < frequency) {
        new_color = previous_color;
    }
	else if (mod(abs(TIME), frequency) < frequency) {
        new_color = colored;
    }
    COLOR = new_color;
}
