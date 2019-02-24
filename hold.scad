
top_gap = 65.5;
bottom_gap = 42.5;
height = 28.5;
pipe_r = 3.5;
pipe_r_gap = 0.5;


side_protrusion_top = 5;
side_protrusion_bottom = 13;
screw_offset_x = bottom_gap/2 + 15.5;
min_thickness = 4;


// case_top();
case_bottom();


module case_top() {
  difference() {
    basic_case();
    pipe_slots();
    translate([0, height/4, 0])
      screw_negative(min_thickness+pipe_r, top=true);
    translate([screw_offset_x, -height/4, 0])
      screw_negative(min_thickness+pipe_r, top=true);
    translate([-screw_offset_x, -height/4, 0])
      screw_negative(min_thickness+pipe_r, top=true);
  }
}

module case_bottom() {
  difference() {
    basic_case();
    pipe_slots();
    translate([0, height/4, 0])
      screw_negative(min_thickness+pipe_r, bottom=true);
    translate([screw_offset_x, -height/4, 0]) rotate([0,0,82])
      screw_negative(min_thickness+pipe_r, bottom=true);
    translate([-screw_offset_x, -height/4, 0]) rotate([0,0,-82])
      screw_negative(min_thickness+pipe_r, bottom=true);
  }
}

module basic_case() {
  xt = top_gap/2 + pipe_r*2+ side_protrusion_top;
  xb = bottom_gap/2 + pipe_r*2 + side_protrusion_bottom;
  h = height/2;
  linear_extrude(min_thickness + pipe_r) 
    polygon(points=[[-xt,h], [xt,h], [xb,-h], [-xb,-h]]);
}

module screw_negative(h, top=false, bottom=false) {
  screw_d = 4;  screw_d_plus = 0;
  head_d = 7;   head_d_plus = 0.2;  head_dimple= 3;
  nut_d = 8;    nut_d_plus = 0;     nut_dimple = 3.5;
  cylinder(d=screw_d+screw_d_plus, h=h, $fs=0.3);
  if (top) {
    translate([0, 0, h-head_dimple])
      cylinder(d=head_d+head_d_plus, h=head_dimple, $fs=0.3);
  }
  if (bottom) {
    translate([0, 0, h-nut_dimple])
      cylinder(d=nut_d+nut_d_plus, h=nut_dimple, $fn=6);
  }
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