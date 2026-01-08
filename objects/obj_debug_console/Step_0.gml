// Resource Switch
if (keyboard_check_pressed(ord("1"))) selected_res_index = 0;
if (keyboard_check_pressed(ord("2"))) selected_res_index = 1;
if (keyboard_check_pressed(ord("3"))) selected_res_index = 2;
if (keyboard_check_pressed(ord("4"))) selected_res_index = 3;
if (keyboard_check_pressed(ord("5"))) selected_res_index = 4;

// Test Commands
if (instance_exists(obj_game_manager)) {
    var _mgr = obj_game_manager;
    
    var _res_name = _mgr.resource_names[selected_res_index]; 
    
    // 1. [Q] Subtract 10
    if (keyboard_check_pressed(ord("Q"))) {
        var _old_value = _mgr.resource_values[selected_res_index]; // ATUALIZADO: resource_values
        _mgr.resource_values[selected_res_index] -= 10;
        
        if (_old_value > 0 && _mgr.resource_values[selected_res_index] <= 0) {
            add_log(_res_name + " EMPTIED!");
        } else {
            add_log("Removed 10 from " + _res_name);
        }
    }
    
    // 2. [W] Add 10
    if (keyboard_check_pressed(ord("W"))) {
        var _old_value = _mgr.resource_values[selected_res_index]; // ATUALIZADO: resource_values
        _mgr.resource_values[selected_res_index] += 10;
    
        if (_old_value < 100 && _mgr.resource_values[selected_res_index] >= 100) {
            add_log(_res_name + " MAXED OUT!");
        } else {
            add_log("Added 10 to " + _res_name);
        }
    }
    
    // 3. [E] Maximize All
    if (keyboard_check_pressed(ord("E"))) {
        for(var i=0; i<5; i++) {
            _mgr.resource_values[i] = 100; // ATUALIZADO: resource_values
        }
        add_log("All resources set to 100%.");
    }
    
    // 4. [R] Restart
    if (keyboard_check_pressed(ord("R"))) {
        game_restart();
    }
}