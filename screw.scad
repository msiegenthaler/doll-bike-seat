module screw_negative(h, top=false, bottom=false, extend_top=0, extend_bottom=0) {
  screw_d = 4;  screw_d_plus = 0;
  head_d = 7;   head_d_plus = 0.2;  head_dimple= 3;
  nut_d = 8;    nut_d_plus = 0;     nut_dimple = 3.5;
  cylinder(d=screw_d+screw_d_plus, h=h, $fs=0.3);
  if (top) {
    translate([0, 0, h-head_dimple])
      cylinder(d=head_d+head_d_plus, h=head_dimple+extend_top, $fs=0.3);
  }
  if (bottom) {
    translate([0,0,-extend_bottom])
      cylinder(d=nut_d+nut_d_plus, h=nut_dimple+extend_bottom, $fn=6);
  }
}