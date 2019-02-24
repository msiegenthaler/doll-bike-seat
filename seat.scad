version = "1";

seat_width = 130;
seat_depth = 90;
seat_round_depth = 17;
// base_thickness = 3;
base_thickness = 1;

back_height = 10;
// back_height = 170;
back_angle = 15;
back_thickness = 3;

base();
back();

module base() {
  difference() {
    linear_extrude(base_thickness) base_2d();
    engraving("seat");
  }
}

module back() {
  back_y_delta = tan(back_angle) * back_height;
  difference() {
    hull() {
      linear_extrude(1) back_2d();
      translate([0,back_y_delta, back_height]) linear_extrude(1) back_2d();
    }
    translate([0,-back_thickness,0]) hull() {
      linear_extrude(1) back_2d();
      translate([0,back_y_delta, back_height]) linear_extrude(1) back_2d();
    }
  }
}

module back_2d() {
  s = seat_width/seat_round_depth/2;
  translate([0,(seat_depth-seat_round_depth)/2]) difference() {
      scale([s,1,1]) circle(r=seat_round_depth, $fa=0.1);
      translate([0,-back_thickness,0]) scale([s,1,1])
        circle(r=seat_round_depth, $fa=0.1);
  }
}

module base_2d() {
  y_offset = (seat_depth-seat_round_depth)/2;
  feet_middle_d = 20;
  feet_indent_d = 27;
  difference() {
    union() {
      square([seat_width, seat_depth-seat_round_depth], center=true);
      translate([0,(seat_depth-seat_round_depth)/2])
        scale([seat_width/seat_round_depth/2,1,1])
        circle(r=seat_round_depth, $fa=0.1);
      
      translate([0,-y_offset+feet_middle_d/6,0]) scale([1.5,1])
        circle(d=feet_middle_d);
    }
    translate([seat_width/4,-y_offset-feet_indent_d/5,0]) scale([1.5,1])
      circle(d=feet_indent_d);
    translate([-seat_width/4,-y_offset-feet_indent_d/5,0]) scale([1.5,1])
      circle(d=feet_indent_d);
  }
}

module engraving(name) {
  txt = str(name, " v", version);
  linear_extrude(0.2) mirror([1,0,0])
    text(txt, size=3, halign="center", valign="center");
}