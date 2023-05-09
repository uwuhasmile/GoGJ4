shader_type canvas_item;

uniform vec4 color : source_color  = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 original_color = vec4(texture(TEXTURE, UV));
    float brightness = (original_color.r + original_color.g + original_color.b) / 3.0;
    vec3 grayscale = vec3(brightness);
    COLOR.rgb = grayscale * color.rgb;
    COLOR.a = original_color.a * color.a;
}
