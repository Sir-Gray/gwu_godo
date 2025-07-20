shader_type canvas_item;

uniform float speed = 1.0;
uniform float pulse_strength = 0.5;
uniform float base_brightness = 1.0;

void fragment() {
	float t = TIME * speed;
	float brightness = base_brightness + sin(t * 6.283) * pulse_strength;
	COLOR.rgb = texture(TEXTURE, UV).rgb * brightness;
	COLOR.a = texture(TEXTURE, UV).a;
}
