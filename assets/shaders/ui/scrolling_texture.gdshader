shader_type canvas_item;

uniform float speed = 0.5;  // Scrolling speed
uniform vec2 direction = vec2(1.0, 0.0);  // (1,0) = horizontal, (0,1) = vertical
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);  // Color multiplier
uniform vec2 tiling = vec2(1.0, 1.0);  // Tiling factor

void fragment() {
    vec2 uv_scroll = fract(UV * tiling + direction * TIME * speed);
    vec4 tex_color = texture(TEXTURE, uv_scroll);
    COLOR = tex_color * tint_color;  // Multiply texture color with tint
}
