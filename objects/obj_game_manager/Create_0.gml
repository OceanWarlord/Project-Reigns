resource_values  = [50, 50, 50, 50, 50]; 
resource_names   = ["Gold", "Army", "Church", "People", "Family"];
resource_sprites = [spr_gold, spr_army, spr_church, spr_population, spr_family];

resource_spacing = 100;
resource_y_pos   = 100;
resource_scale   = 0.35;
is_game_over     = false;

apply_resource_change = function(_index, _amount) {
    if (is_game_over) return;
    
    resource_values[_index] += _amount;

    // Resource Debt Logic
    if (resource_values[_index] < 0) {
        var _debt = abs(resource_values[_index]);
        resource_values[_index] = 0;

        var _others = [0, 1, 2, 3, 4];
        array_delete(_others, _index, 1);
        _others = array_shuffle(_others);

        var _safety = 0;
        while (_debt > 0 && _safety++ < 500) {
            var _any_paid = false;
            for (var j = 0; j < array_length(_others); j++) {
                var _t = _others[j];
                if (resource_values[_t] > 0) {
                    resource_values[_t]--;
                    _debt--;
                    _any_paid = true;
                    if (_debt <= 0) break;
                }
            }
            if (!_any_paid) break;
        }
    }
    resource_values[_index] = clamp(resource_values[_index], 0, 100);
}