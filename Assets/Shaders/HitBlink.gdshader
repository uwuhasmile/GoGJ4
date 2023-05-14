shader_type canvas_item;

uniform bool active = false;
uniform float frequency = 2.0;
uniform vec4 color : source_color = vec4(1.0);
uniform vec3 blend = vec3(1.0);

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    vec4 colored = vec4(
        mix(original.r, color.r, blend.r),
        mix(original.g, color.g, blend.g),
        mix(original.b, color.b, blend.b),
        original.a * color.a);
    vec4 new_color = original;
    if (active == false || mod(abs(TIME), frequency * 2.0) < frequency) {
        new_color = original;
    }
	else if (mod(abs(TIME), frequency) < frequency) {
        new_color = colored;
    }
    COLOR = new_color;
}
