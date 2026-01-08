if (!is_game_over) {
    var _zero_count = 0;
    for (var i = 0; i < 5; i++) {
        if (resource_values[i] <= 0) _zero_count++;
    }

    if (_zero_count >= 2) {
        is_game_over = true;
        global.forced_next_event = 999; 

        var _found_ev = undefined;
        for (var j = 0; j < array_length(global.event_pool); j++) {
            if (global.event_pool[j][$ "id"] == 999) {
                _found_ev = global.event_pool[j];
                break;
            }
        }

        if (!is_undefined(_found_ev)) {
            with(obj_card) {
                event_text = _found_ev.text;
                responses = [];
                is_exiting = false;
                text_char_count = 0;
            }
        }
    }
}