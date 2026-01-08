// ---------- DRAW EVENT (obj_card) ----------
draw_set_alpha(image_alpha);

// Sprite draw
draw_self();

var _cw = sprite_width * image_xscale;
var _ch = sprite_height * image_yscale;

// NPC Name
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_yellow);
draw_text(x, y + (_ch / 2) - 15, string(current_npc.name));

// Event Text
draw_set_valign(fa_middle);
draw_set_color(c_white);
var _txt = string_copy(event_text, 1, floor(text_char_count));
draw_text_ext(x, y, _txt, line_spacing, _cw - (padding * 2));

// ---------- INTERFACE ----------
if (!is_exiting) {
    var _off = 40;
    var _num_options = array_length(responses);

    for (var i = 0; i < _num_options; i++) {
        
        var _sx, _sy, _spr, _rot;
		
        switch(i) {
            case 0: _sx = anchor_x - _cw/2 - _off; _sy = anchor_y; _spr = spr_selection_horizontal; _rot = 180; break;
            case 1: _sx = anchor_x + _cw/2 + _off; _sy = anchor_y; _spr = spr_selection_horizontal; _rot = 0;   break;
            case 2: _sx = anchor_x; _sy = anchor_y - _ch/2 - _off; _spr = spr_selection_vertical;   _rot = 180; break;
            case 3: _sx = anchor_x; _sy = anchor_y + _ch/2 + _off; _spr = spr_selection_vertical;   _rot = 0;   break;
        }

        // Response Sprite Draw
        draw_sprite_ext(_spr, floor(selection_frame[i]), _sx, _sy, 1, 1, _rot, c_white, image_alpha);

        // Response Text
        if (selection_frame[i] > 0) {
            var _tx, _ty;
            var _max_f = sprite_get_number(_spr) - 1;
            if (_max_f <= 0) _max_f = 1;

            switch(i) {
                case 0: _tx = 565;  _ty = anchor_y; break;
                case 1: _tx = 1355; _ty = anchor_y; break;
                case 2: _tx = anchor_x; _ty = 285;  break;
                case 3: _tx = anchor_x; _ty = 795;  break;
            }

            draw_set_alpha((selection_frame[i] / _max_f) * image_alpha);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var _resp_txt = string_copy(responses[i], 1, floor(response_char_counts[i]));
            draw_text_ext(_tx, _ty, _resp_txt, line_spacing, box_width - (padding * 2));
            
            draw_set_alpha(image_alpha);
        }
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);