include <engraving.scad>
version = "2";

seat_width = 130;
seat_depth = 90;
seat_round_depth = 17;
base_thickness = 5;
feet_middle_d = 20;
feet_middle_f = 1.5;

back_height = 170;
back_angle = 15;
back_thickness = 3;

base();
back();

module base() {
  base_stopper();
  difference() {
    translate([0,0,-base_thickness]) linear_extrude(base_thickness) base_2d();
    ass_dents_negative();
    translate([0,-seat_depth/2+10,-base_thickness]) engraving("seat");
  }
}

module base_stopper() {
  y_offset = (seat_depth-seat_round_depth)/2 - feet_middle_d/6;
  y_delta = 10;
  difference() {
    hull() {
      translate([0,-y_offset,0]) scale([feet_middle_f,1,1])
        sphere(d=feet_middle_d);
      translate([0,-y_offset+y_delta,0]) scale([feet_middle_f*0.8,1,0.5])
        sphere(d=feet_middle_d);
    }
    translate([0,0,-100]) linear_extrude(100) square(seat_width,center=true);
  }
}

module ass_dents_negative() {
  translate([0,14,1.1]) scale([1,0.53,0.1]) sphere(d=seat_width*0.8);
  translate([-seat_width/4,0,0]) leg_dent_negative();
  translate([+seat_width/4,0,0]) leg_dent_negative();
}
module leg_dent_negative() {
  translate([0,seat_depth/3,5]) rotate([3,0,0])
    scale([4,1,1]) rotate([90,0,0])
    cylinder(d=10, h=200);
}

module back() {
  back_y_delta = tan(back_angle) * back_height;
  asymetic = 5;
  translate([0,-asymetic,0]) difference() {
    hull() {
      translate([0,asymetic,0]) linear_extrude(1) back_2d();
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
  feet_indent_d = 27;
  difference() {
    union() {
      square([seat_width, seat_depth-seat_round_depth], center=true);
      translate([0,(seat_depth-seat_round_depth)/2])
        scale([seat_width/seat_round_depth/2,1,1])
        circle(r=seat_round_depth, $fa=0.1);
      
      translate([0,-y_offset+feet_middle_d/6,0]) scale([feet_middle_f,1])
        circle(d=feet_middle_d);
    }
    translate([seat_width/4,-y_offset-feet_indent_d/5,0]) scale([1.5,1])
      circle(d=feet_indent_d);
    translate([-seat_width/4,-y_offset-feet_indent_d/5,0]) scale([1.5,1])
      circle(d=feet_indent_d);
  }
}
