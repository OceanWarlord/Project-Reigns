// ---------- EVENT CONTENT ----------
event_text      = "";
text_char_count = 0;
current_npc     = { name: "Ninguém" };
current_event   = noone;

// ---------- RESPONSES ----------
responses           = [];
active_options_data = [];
selected_index      = -1;
is_exiting          = false;

// ---------- VISUAL SETUP ----------
anchor_x     = room_width / 2;
anchor_y     = room_height / 2;
x            = anchor_x;
y            = anchor_y;
padding      = 16;
line_spacing = 24;
image_alpha  = 0;

// ---------- BOX DIMENSIONS ----------
box_width  = 240;
box_height = 160;

// ---------- ANIMATION & SPEEDS ----------
selection_frame      = [0, 0, 0, 0]; 
response_char_counts = [0, 0, 0, 0];
selection_speed      = 0.3;
write_speed          = 0.6;
fade_speed           = 0.03;
tilt_amount          = 35;
exit_speed           = 45;

if (script_exists(asset_get_index("reset_card"))) {
    reset_card();
}