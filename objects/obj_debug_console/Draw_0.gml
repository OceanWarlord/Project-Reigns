var draw_window = function(_x, _y, _w, _h, _title) {
    draw_sprite_stretched_ext(spr_card, 0, _x, _y, _w, _h, c_white, 1);
    draw_set_color(c_yellow);
    draw_text(_x + 10, _y + 5, _title);
    draw_set_color(c_white);
};

// ---------- DRAW TEST CONTROLS WINDOW ----------
draw_window(ctrl_x, ctrl_y, ctrl_width, ctrl_height, "TEST CONTROLS");

// Check focused resource
var _focused_name = (instance_exists(obj_game_manager)) ? obj_game_manager.resource_names[selected_res_index] : "N/A";

draw_text(ctrl_x + 15, ctrl_y + 40,  "Focus: [" + _focused_name + "]");
draw_text(ctrl_x + 15, ctrl_y + 70,  "[1-5] Select Resource");
draw_text(ctrl_x + 15, ctrl_y + 100, "[Q] -10 Focused Resource");
draw_text(ctrl_x + 15, ctrl_y + 130, "[W] +10 Focused Resource");
draw_text(ctrl_x + 15, ctrl_y + 160, "[E] Maximize All");
draw_text(ctrl_x + 15, ctrl_y + 190, "[R] Reset (Game Restart)");

// ---------- DRAW SYSTEM LOG WINDOW ----------
draw_window(log_x, log_y, log_width, log_height, "SYSTEM LOG");

for (var i = 0; i < ds_list_size(log_messages); i++) {
    draw_text(log_x + 15, log_y + 40 + (i * 20), "> " + log_messages[| i]);
}