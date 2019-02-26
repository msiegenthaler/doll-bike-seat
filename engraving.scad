module engraving(name) {
  txt = str(name, " v", version);
  linear_extrude(0.2) mirror([1,0,0])
    text(txt, size=3, halign="center", valign="center", spacing=1.2);
}