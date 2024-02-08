/* [Hidden] */
// Rendering resolution (smallest element size)
$fs = 0.3;
// Machine epsilon
eps = 0.01;
/* [General] */
// Hanging rod diameter
rod_d = 4;
// Margin around the rod [mm]
margin = 0.5;
// Overlap with the rod, so the hanger will clip [mm]
overlap = 0.5;
// Hanger length
l = 20;
// Fiber / cable / rope coil thickness
coil_d = 20;
// Hanger wall thickness
wall_t = 2;
hang_d = rod_d+overlap+2*wall_t;
coil_ext_d = coil_d + 2*wall_t;
coil_overlap = 10;


module hook(wall_t, internal_d, margin, overlap, length){
    translate([0,(internal_d+margin+wall_t)/2,0]) difference(){
        offset(r = wall_t){
            circle(d=internal_d+margin);
            difference(){
                translate([0,-(internal_d+margin)/2,0]) square([length,internal_d-overlap-wall_t]);
                translate([internal_d/2,0,0]) square([length*1.5,internal_d]);
            }
        }
        circle(d=internal_d+margin);
        translate([0,-(internal_d+margin)/2,0]) square([length*1.5,internal_d+margin/2+eps-overlap]);
    }
}

linear_extrude(height = l) union(){
    hook(wall_t, rod_d, margin, overlap, hang_d*2);
    translate([hang_d*4,0,0]) mirror([1,0,0]) hook(wall_t, coil_d, margin, coil_overlap, hang_d*2);
}

translate([hang_d*2,-wall_t/2,l/2]) rotate([90,0,0]) linear_extrude(height = 0.3) offset(delta=0.001) import(file = "QPL_logo_MM_initials.svg", center = true, dpi = 600);