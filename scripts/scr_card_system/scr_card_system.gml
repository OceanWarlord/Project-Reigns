/// @function reset_card()
function reset_card() {
    with(obj_card) {
        // ---------- 1. VISUAL RESET ----------
        x = anchor_x; 
        y = anchor_y; 
        image_alpha = 0; 
        is_exiting = false;
        selected_index = -1; 
        text_char_count = 0;
        
        for(var i=0; i<4; i++) { 
            selection_frame[i] = 0; 
            response_char_counts[i] = 0; 
        }

        var _chosen = noone;

        // ---------- 2. STATE CHECK ----------
		var _is_dead = false;
		if (instance_exists(obj_game_manager)) {
		    if (variable_instance_exists(obj_game_manager, "is_game_over")) {
		        _is_dead = obj_game_manager.is_game_over;
		    }
		}

        // ---------- 3. EVENT SELECTION ----------
        
        // A. Game Over
        if (_is_dead) {
            _chosen = event_find_by_id(999);
        }

        // B. ROLE CHANGER
        if (!_chosen && !_is_dead && global.forced_next_event == 99) {
            var _treasurer = get_npc_by_role("treasurer");
            global.forced_next_event = (_treasurer == "alfred") ? 3 : ((_treasurer == "barnaby") ? 20 : -1);
        }

        // C. EVENT CHAINS
        if (!_chosen && global.forced_next_event != -1) {
            _chosen = event_find_by_id(global.forced_next_event);
            global.forced_next_event = -1;
        }

        // D. RANDOM SELECTION
        if (!_chosen) {
            var _valid_list = [];
            var _pool_size = array_length(global.event_pool);
            
            for (var i = 0; i < _pool_size; i++) {
                var _ev = global.event_pool[i];
                
                // Basic Filter
                if (_ev.event_id == 1000 || _ev.event_id == 999 || _ev.is_chain_only) continue;

                // Required NPC Filter
                if (_ev.req_npc != undefined) {
                    var _npc = global.npcs[$ _ev.req_npc];
                    if (!_npc || !_npc.enabled || !_npc.is_alive) continue;
                }

                // Required Role Filter
                if (_ev.req_role != undefined && !role_is_active(_ev.req_role)) continue;

                // Anti-repeat Filter
                var _hist_idx = ds_list_find_index(global.event_history, _ev.event_id);
                if (_ev.is_once && _hist_idx != -1) continue;
                if (_hist_idx != -1) continue;

                array_push(_valid_list, _ev);
            }
            
            if (array_length(_valid_list) > 0) {
                _chosen = _valid_list[irandom(array_length(_valid_list) - 1)];
                
                // History Manager
                ds_list_insert(global.event_history, 0, _chosen.event_id);
                if (ds_list_size(global.event_history) > global.max_history) {                   
                    ds_list_delete(global.event_history, ds_list_size(global.event_history) - 1);
                }
            } else {
                // Failsafe
                ds_list_clear(global.event_history);
                _chosen = global.event_pool[0]; 
            }
        }

        // ---------- 4. DATA ----------
        if (_chosen != noone) {
            current_event = _chosen;
            event_text = current_event.event_text;
            
            // Sets talking NPC
            var _n_key = current_event.npc_key;
            if (struct_exists(global.npcs, _n_key)) {
                current_npc = global.npcs[$ _n_key];
            } else {
                var _role_npc = get_npc_by_role(_n_key);
                current_npc = (_role_npc != undefined) ? global.npcs[$ _role_npc] : global.npcs.elara;
            }

            // ---------- 5. Response Processing ----------
            active_options_data = [];
            responses = [];

            if (!_is_dead) {
                var _opt_pool = [];
                for (var i = 0; i < array_length(current_event.options); i++) {
                    var _o = current_event.options[i];
                    var _can = true;

                    if (_o[$ "req_role"] != undefined && !role_is_active(_o.req_role)) _can = false;
                    
                    if (_o[$ "req_npc"] != undefined) {
                        var _target = global.npcs[$ _o.req_npc];
                        if (!_target.is_alive) _can = false;
                        if (!_target.enabled && current_event.event_id != 4) _can = false;
                    }

                    if (_can) array_push(_opt_pool, _o);
                }

                _opt_pool = array_shuffle(_opt_pool);
                var _count = min(irandom_range(current_event.min_choices, current_event.max_choices), array_length(_opt_pool));

                for (var k = 0; k < _count; k++) {
                    array_push(active_options_data, _opt_pool[k]);
                    responses[k] = _opt_pool[k].text;
                }
            }
        }
    }
}

/// @function event_find_by_id(id)
function event_find_by_id(_id) {
    for (var i = 0; i < array_length(global.event_pool); i++) {
        if (global.event_pool[i].event_id == _id) return global.event_pool[i];
    }
    return noone;
}

/// @function array_shuffle(array)
function array_shuffle(_arr) {
    var _len = array_length(_arr);
    for (var i = _len - 1; i > 0; i--) {
        var _j = irandom(i);
        var _temp = _arr[i];
        _arr[i] = _arr[_j];
        _arr[_j] = _temp;
    }
    return _arr;
}