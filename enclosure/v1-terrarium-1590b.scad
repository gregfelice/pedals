// ============================================================
// v1 Terrarium 1590B Enclosure — Neural Amp Modeler Pedal
// ============================================================
// Dimensions match Hammond 1590B so drill template carries
// over to the final aluminum enclosure from Tayda.
//
// Print settings:
//   Material: PETG or PLA+
//   Layer height: 0.2mm
//   Infill: 30%+
//   Walls: 3
//   Supports: not needed if printed lid-down
//
// Orientation when viewing from above (foot toward you):
//   TOP edge    = DC jack, output jack, input jack
//   BOTTOM edge = footswitch
//   FACE        = pots, OLED, encoder, LED
// ============================================================

// --- Parameters (all mm) ---

// 1590B external dimensions
box_length = 112;     // top-to-bottom (long axis)
box_width  = 60;      // left-to-right
box_depth  = 31;      // height

wall = 2.5;           // wall thickness
lid_thick = 2.5;      // face plate thickness
corner_r = 3;         // corner radius

// Screw posts (M3)
screw_d = 3.2;
screw_post_d = 7;
screw_post_h = 5;     // height inside box

// Pot holes (7mm shaft, 8mm clearance)
pot_hole_d = 8;
pot_rows = 2;
pot_cols = 3;
pot_y_start = 18;     // from top edge of lid
pot_y_spacing = 18;
pot_x_spacing = 16;

// Footswitch (12mm thread)
foot_d = 12.5;
foot_y = 96;          // from top edge, near bottom

// LED (5mm + bezel)
led_d = 8;            // 5mm LED with bezel
led_y = 82;

// OLED cutout (SSD1306 128x64 display window)
oled_w = 26;
oled_h = 14;
oled_y = 54;          // center Y from top edge
oled_corner_r = 1.5;

// Rotary encoder (7mm shaft)
encoder_d = 7.5;
encoder_y = 54;       // same Y as OLED center
encoder_x_offset = 22; // right of center

// Audio jacks (1/4" = 9.5mm thread)
jack_d = 10;
jack_z = 15;          // height from bottom of box

// DC barrel jack (2.1mm, 8mm thread)
dc_d = 8.5;
dc_z = 15;

// --- Derived ---
inner_l = box_length - 2*wall;
inner_w = box_width - 2*wall;
inner_d = box_depth - lid_thick;
cx = box_width / 2;   // center X

// ============================================================
// Modules
// ============================================================

module rounded_box(l, w, h, r) {
    hull() {
        for (x = [r, w-r])
            for (y = [r, l-r])
                translate([x, y, 0])
                    cylinder(h=h, r=r, $fn=32);
    }
}

module screw_post(h, od, id) {
    difference() {
        cylinder(h=h, d=od, $fn=24);
        translate([0, 0, -0.1])
            cylinder(h=h+0.2, d=id, $fn=24);
    }
}

// Enclosure body (open top)
module body() {
    difference() {
        // Outer shell
        rounded_box(box_length, box_width, box_depth, corner_r);

        // Hollow interior
        translate([wall, wall, wall])
            rounded_box(inner_l, inner_w, box_depth, corner_r - wall/2);

        // --- Side holes (drilled into walls) ---

        // Input jack — right side, toward top
        translate([box_width + 0.1, 22, jack_z])
            rotate([0, -90, 0])
                cylinder(h=wall+0.2, d=jack_d, $fn=32);

        // Output jack — left side, toward top
        translate([-0.1, 22, jack_z])
            rotate([0, 90, 0])
                cylinder(h=wall+0.2, d=jack_d, $fn=32);

        // DC jack — top edge, center
        translate([cx, box_length + 0.1, dc_z])
            rotate([90, 0, 0])
                cylinder(h=wall+0.2, d=dc_d, $fn=32);
    }

    // Screw posts in corners
    post_inset = 6;
    for (x = [post_inset, box_width - post_inset])
        for (y = [post_inset, box_length - post_inset])
            translate([x, y, wall])
                screw_post(screw_post_h, screw_post_d, screw_d);
}

// Face plate / lid
module lid() {
    difference() {
        // Plate
        rounded_box(box_length, box_width, lid_thick, corner_r);

        // --- Pot holes (2 rows x 3 cols) ---
        for (row = [0 : pot_rows-1])
            for (col = [0 : pot_cols-1])
                translate([
                    cx + (col - 1) * pot_x_spacing,
                    pot_y_start + row * pot_y_spacing,
                    -0.1
                ])
                    cylinder(h=lid_thick+0.2, d=pot_hole_d, $fn=32);

        // --- OLED rectangular cutout ---
        translate([cx - oled_w/2, oled_y - oled_h/2, -0.1])
            hull() {
                for (x = [oled_corner_r, oled_w - oled_corner_r])
                    for (y = [oled_corner_r, oled_h - oled_corner_r])
                        translate([x, y, 0])
                            cylinder(h=lid_thick+0.2, r=oled_corner_r, $fn=16);
            }

        // --- Rotary encoder hole ---
        translate([cx + encoder_x_offset, encoder_y, -0.1])
            cylinder(h=lid_thick+0.2, d=encoder_d, $fn=32);

        // --- LED hole ---
        translate([cx, led_y, -0.1])
            cylinder(h=lid_thick+0.2, d=led_d, $fn=32);

        // --- Footswitch hole ---
        translate([cx, foot_y, -0.1])
            cylinder(h=lid_thick+0.2, d=foot_d, $fn=32);

        // --- Screw holes ---
        post_inset = 6;
        for (x = [post_inset, box_width - post_inset])
            for (y = [post_inset, box_length - post_inset])
                translate([x, y, -0.1])
                    cylinder(h=lid_thick+0.2, d=screw_d, $fn=24);
    }
}

// ============================================================
// Render
// ============================================================
// Uncomment one at a time for STL export, or view both together.

// Body
color("dimgray") body();

// Lid — shown offset above for visualization
color("silver", 0.7) translate([0, 0, box_depth + 10]) lid();

// To export for printing:
//   1. Comment out one part, render the other (F6), export STL
//   2. Print body open-side-up
//   3. Print lid flat (face down for smooth surface)
