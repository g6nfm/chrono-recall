shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D Noise;
uniform float Dissolvevalue : hint_range(0.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Only flash the RGB channels; keep original alpha
    vec3 flashed = mix(tex.rgb, vec3(1.0), flash_amount);

    COLOR = vec4(flashed, tex.a);

	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(Noise, UV);


// FloatParameter:7
	float n_out7p0 = Dissolvevalue;


// FloatConstant:5
	float n_out5p0 = 0.000000;


// FloatConstant:6
	float n_out6p0 = 1.000000;


	vec3 n_out4p0;
// If:4
	float n_in4p2 = 0.00001;
	vec3 n_in4p3 = vec3(0.00000, 0.00000, 0.00000);
	if(abs(n_out3p0.x - n_out7p0) < n_in4p2)
	{
		n_out4p0 = n_in4p3;
	}
	else if(n_out3p0.x < n_out7p0)
	{
		n_out4p0 = vec3(n_out6p0);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0);
	}


	vec4 n_out9p0;
// Texture2D:9
	n_out9p0 = texture(TEXTURE, UV);
	float n_out9p4 = n_out9p0.a;


// Mix:10
	float n_in10p0 = 0.00000;
	float n_out10p0 = mix(n_in10p0, n_out4p0.x, n_out9p4);


// Output:0
	COLOR.a = n_out10p0;


}
