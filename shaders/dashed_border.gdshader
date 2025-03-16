shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float thickness = 3.0;
uniform float dash_length = 10.0;
uniform float gap_length = 5.0;
uniform vec2 object_size = vec2(100.0, 100.0); // Must be set from GDScript

void fragment() {
    vec2 uv_pos = UV * object_size; // Get pixel position relative to object

    // Create dashes using mod function
    float border_x = step(mod(uv_pos.x, dash_length + gap_length), dash_length);
    float border_y = step(mod(uv_pos.y, dash_length + gap_length), dash_length);

    // Convert conditions to float (1.0 if true, 0.0 if false)
    float is_top_or_bottom = step(UV.y, thickness / object_size.y) + step(1.0 - thickness / object_size.y, UV.y);
    float is_left_or_right = step(UV.x, thickness / object_size.x) + step(1.0 - thickness / object_size.x, UV.x);

    // Apply dashed effect to border
    float is_border = max(border_x * is_top_or_bottom, border_y * is_left_or_right);

    // Apply the dashed border color
    if (is_border > 0.0) {
        COLOR = outline_color;
    } else {
        discard; // Make non-border areas transparent
    }
}
