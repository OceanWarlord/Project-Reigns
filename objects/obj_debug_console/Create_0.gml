log_messages = ds_list_create();
max_log_lines = 9;

add_log = function(_text) {
    ds_list_insert(log_messages, 0, _text);
    if (ds_list_size(log_messages) > max_log_lines) {
        ds_list_delete(log_messages, max_log_lines);
    }
}

selected_res_index = 0;
log_width = 500; log_height = 250;
ctrl_x = 40; ctrl_y = 40;
log_x = 40; log_y = room_height - log_height - 40;

ctrl_x = 10;          
ctrl_y = 10;          
ctrl_width = 350;     
ctrl_height = 250;    