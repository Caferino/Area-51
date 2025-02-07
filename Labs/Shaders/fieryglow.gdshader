shader_type canvas_item;
render_mode blend_add, unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float glow_scale_y = 1.0;
uniform float glow_strength = 1.0;
uniform float glow_intensity = 0.0;  // Default value for glow_intensity
uniform sampler2D noise : repeat_enable, filter_nearest_mipmap_anisotropic;
uniform sampler2D color_curve;

// Parameters for position and size
uniform vec2 glow_position = vec2(0.5, 0.5);
uniform vec2 glow_size = vec2(0.2, 0.2);

// Parameters for pulsating effect
uniform float pulsation_speed = 1.0;
uniform float glow_intensity_start = 0.75;
uniform float glow_intensity_stop = 1.0;

void fragment()
{
	float time = TIME;

	COLOR.rgb = texture(color_curve, vec2(COLOR.r, 0.0)).rgb;

	// Light
	vec2 glowUV = (UV - glow_position) / glow_size;
	float d2c_l = length(glowUV * vec2(1.0, glow_scale_y) - vec2(0.58, 0.5 * glow_scale_y));

	// Oscillating glow_intensity if pulsate is true, otherwise use the default glow_intensity
	float glow_intensity_value = mix(glow_intensity_start, glow_intensity_stop, 0.5 + 0.5 * sin(time * pulsation_speed * 3.14159 * 2.0));
	float l = -log(d2c_l + glow_intensity_value) * glow_strength;

	COLOR += texture(color_curve, vec2(1.0 - d2c_l - 0.1, 0.0)) * l;
}