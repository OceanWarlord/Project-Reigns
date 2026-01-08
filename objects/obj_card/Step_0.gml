// --- INPUT HANDLING ---
if (!is_exiting) {
    var _move = -1;
    if (keyboard_check_pressed(vk_left))  _move = 0;
    if (keyboard_check_pressed(vk_right)) _move = 1;
    if (keyboard_check_pressed(vk_up))    _move = 2;
    if (keyboard_check_pressed(vk_down))  _move = 3;

    if (_move != -1 && _move < array_length(responses)) {
        selected_index = (selected_index == _move) ? -1 : _move;
    }
}

// ---------- CONFIRMATION LOGIC ----------
if (keyboard_check_pressed(vk_space) && !is_exiting && selected_index != -1) {
    var _c = active_options_data[selected_index];
    var _m = obj_game_manager;
    is_exiting = true;

    if (instance_exists(_m)) {
        // 1. Resources
        var _res_keys = ["gold", "army", "church", "people", "family"];
        for (var i = 0; i < array_length(_res_keys); i++) {
            var _val = _c[$ _res_keys[i]];
            if (!is_undefined(_val)) {
                var _change = is_array(_val) ? irandom_range(_val[0], _val[1]) : _val;
                _m.apply_resource_change(i, _change);
            }
        }
    }

    // 2. Loyalty
    var _loyalty = _c[$ "loyalty_impact"];
    if (!is_undefined(_loyalty)) {
        var _names = struct_get_names(_loyalty);
        for (var i = 0; i < array_length(_names); i++) {
            var _key = _names[i];
            var _target = _key;
            
            if (_key == "treasurer" || _key == "general" || _key == "bishop" || _key == "queen") {
                var _found = get_npc_by_role(_key);
                if (!is_undefined(_found)) _target = _found;
            }

            if (struct_exists(global.npcs, _target)) {
                global.npcs[$ _target].base_loyalty = clamp(global.npcs[$ _target].base_loyalty + _loyalty[$ _key], 0, 100);
            }
        }
    }

    // 3. NPC handler
    if (!is_undefined(_c[$ "unlock_npc"])) global.npcs[$ _c.unlock_npc].enabled = true;
    if (!is_undefined(_c[$ "lock_npc"]))   global.npcs[$ _c.lock_npc].enabled = false;
    if (!is_undefined(_c[$ "kill_npc"])) {
        global.npcs[$ _c.kill_npc].is_alive = false;
        global.npcs[$ _c.kill_npc].enabled = false;
    }

    global.forced_next_event = _c[$ "force_event"] ?? -1;
}

// ---------- ANIMATIONS & TYPEWRITER ----------
var _num_options = array_length(responses);

for (var i = 0; i < 4; i++) {
    var _limit = (i <= 1) ? sprite_get_number(spr_selection_horizontal)-1 : sprite_get_number(spr_selection_vertical)-1;
    
    if (i == selected_index && !is_exiting) {
        selection_frame[i] = min(selection_frame[i] + selection_speed, _limit);
        if (i < _num_options) {
            response_char_counts[i] = min(response_char_counts[i] + write_speed, string_length(responses[i]));
        }
    } else {
        selection_frame[i] = max(selection_frame[i] - selection_speed, 0);
        if (i < 4) response_char_counts[i] = 0;
    }
}

text_char_count = min(text_char_count + write_speed, string_length(event_text));

// ---------- MOVEMENT ----------
if (!is_exiting) {
    var _tx = anchor_x + ((selected_index == 1) ? tilt_amount : (selected_index == 0 ? -tilt_amount : 0));
    var _ty = anchor_y + ((selected_index == 3) ? tilt_amount : (selected_index == 2 ? -tilt_amount : 0));
    x = lerp(x, _tx, 0.2);
    y = lerp(y, _ty, 0.2);
} else {
    if (selected_index == 0) x -= exit_speed;
    if (selected_index == 1) x += exit_speed;
    if (selected_index == 2) y -= exit_speed;
    if (selected_index == 3) y += exit_speed;

    if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
        reset_card();
    }
}
image_alpha = lerp(image_alpha, 1, fade_speed);