version = "6";
include <engraving.scad>
include <screw.scad>

seat_width = 130;
seat_depth = 90;
seat_round_depth = 17;
base_thickness = 8;
feet_middle_d = 20;
feet_middle_f = 1.5;

back_height = 170;
back_angle = 15;
back_thickness = 3;

protection_thickness = 3.9;

include <rod.scad>
screw_base = 4.5;
holder_base_l = 40;

*seat();
holder();

module seat() {
  difference() {
    base();
    belt_negative();
  }
  back();
  side_protections();
}

module belt_negative() {
  belt_w = 12;
  belt_t = 2;
  y = -10.1 + seat_depth/2-belt_w;
  translate([-seat_width/2+protection_thickness, y,-50])
    cube([belt_t,belt_w,100]);
  translate([seat_width/2-protection_thickness-belt_t, y,-50])
    cube([belt_t,belt_w,100]);
}
module holder() {
  y_inset = 12;
  y_offset = (seat_depth-seat_round_depth)/2-y_inset;
  difference() {
    translate([0,-y_offset,-base_thickness]) {
      holder_base(y_inset);
      holder_top();
    }
    translate([0,-y_offset,-base_thickness])
      rod_negative();
    translate([0,-y_offset+holder_base_l/2,-base_thickness-engraving_depth])
      engraving("seat-mnt");
    screws_negative();
  }
}
module holder_base() {
  x = 30;
  h_y = 15;
  difference() {
    hull() {
      translate([-x/2, 0,-screw_base])
        cube([x, holder_base_l, screw_base]);
      translate([-x/2, holder_base_l, -0.1])
        cube([x, h_y, 0.1]);
    }
  }
}

module holder_top() {
  x = rod_in_w+(rod_holder_wall+rod_gap)*2;
  y = rod_top_inside + rod_gap + rod_holder_wall;
  z = rod_in_h+rod_holder_wall+rod_gap*2;
  x2 = 2.2;
  hull() {
    translate([-x/2,0,-screw_base-z])
      cube([x,y,z]);
    translate([-x2/2,0,-screw_base])
      cube([x2,holder_base_l,screw_base]);
  }
}

module rod_negative() {
  w = rod_in_w+rod_gap*2;
  z = -rod_in_h -screw_base -rod_gap;
  translate([-w/2,0,z])
    cube([w, rod_top_inside+rod_gap, rod_in_h+rod_gap*2]);
}

module side_protections() {
  intersection() {
    union() {
      translate([seat_width/2-protection_thickness,0,0])
        side_protection();
      translate([-seat_width/2,0,0])
        side_protection();
    }
    hull() {
      linear_extrude(100) base_2d();
      back();
    }
  }
}

module side_protection() {
  x_offset = 0;
  y_offset = -(seat_depth-seat_round_depth)/2;

  h = 35;
  d_plus = h*1.5;
  r1 = h;
  r2 = 20;

  translate([x_offset,y_offset+r1,0])
    cube([protection_thickness,seat_depth+d_plus-r1,h]);
  translate([x_offset,y_offset+r1,0])
    rotate([0,90,0]) cylinder(r=r1,h=protection_thickness);
  translate([x_offset,seat_depth/2,h]) rotate([30,0,0])
    rotate([0,90,0]) scale([1,1.7,1]) cylinder(r=r2,h=protection_thickness);
}

module base() {
  base_stopper();
  difference() {
    translate([0,0,-base_thickness]) linear_extrude(base_thickness)
      base_2d();
    ass_dents_negative();
    translate([0,-seat_depth/2+10,-base_thickness])
      engraving("seat");
    screws_negative();
  }
}

module screws_negative() {
  l = base_thickness + screw_base;
  sink1 = 1.6;
  translate([0,-9.5,-l])
    screw_negative(l-sink1, top=true, bottom=true, extend_top=10, extend_bottom=1);
  sink2 = 2.8;
  translate([7.5,10.5,-l]) rotate([0,0,90])
    screw_negative(l-sink2, top=true, bottom=true, extend_top=10, extend_bottom=1);
  translate([-7.5,10.5,-l]) rotate([0,0,90])
    screw_negative(l-sink2, top=true, bottom=true, extend_top=10, extend_bottom=1);
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
  translate([0,14,1.1]) scale([1,0.53,0.08]) sphere(d=seat_width*0.8);
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
  rounder_r = 120; rounder_s=0.8;
  intersection() {
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
    union() {
      translate([0,200,back_height-rounder_r]) scale([rounder_s, 1,1]) rotate([90,0,0]) cylinder(r=rounder_r, h=200, $fa=5);
      translate([-100,0,0]) cube([200,200,back_height/2]);
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
