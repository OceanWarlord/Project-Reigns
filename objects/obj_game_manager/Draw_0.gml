var _cx = room_width / 2;
var _sx = _cx - (resource_spacing * 2);

// ---------- HUD BACKGROUND ----------
var _bw = (resource_spacing * 4) + 120;
var _bh = 100;

draw_sprite_stretched_ext(spr_card, 0, _cx - (_bw/2), resource_y_pos - (_bh/2), _bw, _bh, c_white, 1);

// ---------- RESOURCE ICONS ----------
for (var i = 0; i < 5; i++) {
    var _dx = _sx + (i * resource_spacing);
    var _frame = clamp(floor(resource_values[i] / 10), 0, 10);

    draw_sprite_ext(resource_sprites[i], _frame, _dx, resource_y_pos, resource_scale, resource_scale, 0, c_white, 1);

    // Mouse Hover
    var _sw = (sprite_get_width(resource_sprites[i]) * resource_scale) / 2;
    if (point_in_rectangle(mouse_x, mouse_y, _dx - _sw, resource_y_pos - _sw, _dx + _sw, resource_y_pos + _sw)) {
        draw_set_halign(fa_center);
        draw_text(_dx, resource_y_pos - _sw - 10, string(resource_values[i]));
    }
}

if (is_game_over) {
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    draw_text(room_width/2, room_height * 0.8, "PRESSIONE 'R' PARA TENTAR NOVAMENTE");
}