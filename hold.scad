version = "9";
include <engraving.scad>
include <screw.scad>

top_gap = 65.5;
bottom_gap = 42.5;
height = 28.5;
pipe_r = 3.5;
pipe_r_gap = 0.5;


side_protrusion_top = 5;
side_protrusion_bottom = 13;
screw_offset_x = bottom_gap/2 + 15.5;
min_thickness = 4;

include <rod.scad>

// case_bottom();
// case_top();
rod();

module case_top() {
  difference() {
    union() {
      basic_case();
      rod_holder();
    }
    pipe_slots();
    top_screws_negative();
    rod_in_case(enlarge=rod_gap);
    translate([0,0,-50]) cube([100,100,100], center=true);
    engraving("case top");
  }
}

module rod_holder() {
  d = min_thickness+pipe_r;
  w = rod_in_w + (rod_holder_wall+rod_gap)*2;
  h = rod_in_h + (rod_holder_wall+rod_gap)*2;
  translate([-w/2,-height/2,0]) translate([0,0,d]) rotate([-rod_angle,0,0])
    cube([w,h,rod_holder_len]);

  h2 = height/2-3;
  l2 = 37.5;
  translate([-w/2,height/2-h2,0])
    cube([w,h2,l2]);
}

module rod() {
  y_offset = -height/2+rod_outset*0.33;
  difference() {
    union() {
      rod_in_case();
      rod_1(y_offset);
    }
    top_screws_negative();
    case_top();
    translate([-rod_in_w/2,10,25]) rotate([-rod_angle,0,0]) rotate([0,90,0])
      engraving("rod");
  }
}

module rod_1(y_offset) {
  d = min_thickness+pipe_r;
  w = rod_in_w + 2*rod_outset;
  h = rod_in_h + 2*rod_outset;
  weird_l_delta = 0.4;
  translate([w/2,y_offset,d]) rotate([-rod_angle,0,0]) rotate([0,-90, 0]) {
    translate([rod_holder_len-weird_l_delta,0,0]) linear_extrude(w) translate([0,-rod_delta_h]) {
      polygon(points=[[0,rod_delta_h],    [rod_low_l,rod_delta_h],
        [rod_low_l+rod_up_l,0],            [rod_low_l+rod_up_l+rod_high_l,0],
        [rod_low_l+rod_up_l+rod_high_l,h], [rod_low_l+rod_up_l,h],
        [rod_low_l,rod_delta_h+h],         [0, rod_delta_h+h]]);
    }
  }

  // top bolt
  z = rod_holder_len-weird_l_delta+rod_low_l+rod_up_l+rod_high_l;
  translate([0,y_offset,d]) rotate([-rod_angle,0,0]) {
    translate([-rod_in_w/2,-rod_delta_h+rod_outset,z])
      difference() {
        cube([rod_in_w,rod_in_h,rod_top_inside]);
        translate([rod_in_w/2,rod_in_h,rod_top_screw_in]) rotate([90,0,0])
          screw_negative(rod_in_h);
      }
  }
}

module rod_in_case(enlarge=0, rod_distance=0) {
  l = 40;
  d = min_thickness+pipe_r;
  w = rod_in_w + enlarge*2;
  h = rod_in_h + enlarge*2;
  difference() {
    translate([-w/2,-height/2+rod_holder_wall*1.3-enlarge*1.3,0]) translate([0,0,d]) rotate([-rod_angle,0,0])
      cube([w,h,l]);
    cube([top_gap, height, (d+rod_distance)*2], center=true);
  }
}

module top_screws_negative() {
  translate([0, height/4, 0])
    screw_negative(min_thickness+pipe_r+30, top=true, extend_top = 5);
  translate([screw_offset_x, -height/4, 0])
    screw_negative(min_thickness+pipe_r, top=true);
  translate([-screw_offset_x, -height/4, 0])
    screw_negative(min_thickness+pipe_r, top=true);
}

module case_bottom() {
  screw_l = min_thickness+pipe_r;
  difference() {
    basic_case();
    pipe_slots();
    translate([0, height/4, screw_l]) mirror([0,0,1])
      screw_negative(screw_l, bottom=true);
    translate([screw_offset_x, -height/4, screw_l]) rotate([0,0,82]) mirror([0,0,1])
      screw_negative(screw_l, bottom=true);
    translate([-screw_offset_x, -height/4, screw_l]) rotate([0,0,-82]) mirror([0,0,1])
      screw_negative(screw_l, bottom=true);
    engraving("case bottom");
  }
}

module basic_case() {
  xt = top_gap/2 + pipe_r*2+ side_protrusion_top;
  xb = bottom_gap/2 + pipe_r*2 + side_protrusion_bottom;
  h = height/2;
  linear_extrude(min_thickness + pipe_r) 
    polygon(points=[[-xt,h], [xt,h], [xb,-h], [-xb,-h]]);
}

module pipe_slots() {
  d = (top_gap + bottom_gap) / 4;
  translate([-d-pipe_r,0,0]) pipe_slot();
  translate([d+pipe_r,0,0]) mirror([1,0,0]) pipe_slot();
}

module pipe_slot() {
  r = pipe_r + pipe_r_gap; 
  a = atan((top_gap-bottom_gap)/2 / height);
  h = height+(r*8);
  rotate([0,0,a])
    translate([0,h/2,0]) rotate([90,0,0])
      cylinder(r=r, h=h, $fs=0.3);
}