shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    // Only flash the RGB channels; keep original alpha
    vec3 flashed = mix(tex.rgb, vec3(1.0), flash_amount);

    COLOR = vec4(flashed, tex.a);
}