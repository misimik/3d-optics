/* [Hidden] */
// Machine epsilon
eps = 0.01;
/* [Basic] */
// Fiber hole hight above the table
fiber_h = 125;//103;
// Fiber cable diameter
fiber_d = 2.8;
/* [General] */
// Washer diameter
washer_d = 12;
// Screw diameter
screw_d = 6.5;
// Optical table screw grid spacing
screw_grid = 25;


// How wide is the slit with relation to fiber thickness
fiber_hold_percent = 0.5;
// Column thickness
column_t = 15;
// Column width
column_w = 10;
// Base thickness
base_t = 5;
// Flexure hinge thickness
column_bend_t = 1.5;
// Vertical margin above the fiber
column_margin_above_fiber = 10;
// Fiber compression fraction
compression_percentage = 0.4;


//Calulated parameters
cr = column_w/2-column_bend_t;//Cylinder radius
cut_t = fiber_d*(1-fiber_hold_percent)*(1-compression_percentage);
base_w = screw_grid+washer_d;




//Secure clip
points = [[0,0],[1.5+0.15,0],[1.5+0.15,column_w+0.15+1.5+2],[0.15,column_w+0.15+1.5+2],[0.15-2,column_w+0.15+1.5],[0.2-2,column_w+0.2],[0.15,column_w+0.15],[0.15,column_w/2-cut_t/2],[0.0,column_w/2-cut_t/2]];

union(){
    difference(){
        // Clip base
        cube([column_t,column_w,fiber_h+fiber_d/2+column_margin_above_fiber]);
        // The cut in the middle
        translate([-eps/2,column_w/2-cut_t/2,fiber_h-(fiber_d/2+column_margin_above_fiber)]) cube([column_t+eps,cut_t,2*column_margin_above_fiber+fiber_d+eps]);
        // The halfcircle allowing for bending
        translate([-eps/2,column_w/2,fiber_h-(fiber_d/2+column_margin_above_fiber)-cr+eps]) rotate([0,90,0]) intersection(){
            cylinder(r=cr, h=column_t+eps,$fn=50);
            translate([-cr,-cr,0]) cube([2*cr,cr+cut_t/2,column_t+eps]);
        }
        // The one of the hollows for the fiber
        translate([-eps/2,column_w/2-cut_t/2+eps/2,fiber_h]) rotate([0,90,0]) intersection(){
            translate([0,fiber_d/2*(1-fiber_hold_percent),0]) cylinder(d=fiber_d,h=column_t+eps,$fn=30);
            translate([-fiber_d/2,-fiber_d,0]) cube([fiber_d,fiber_d,column_t+eps]);
        }
        // The other of the hollows for the fiber
        translate([-eps/2,column_w/2+cut_t/2-eps/2,fiber_h]) rotate([0,-90,180]) intersection(){
            translate([0,fiber_d/2*(1-fiber_hold_percent),0]) cylinder(d=fiber_d,h=column_t+eps,$fn=30);
            translate([-fiber_d/2,-fiber_d,0]) cube([fiber_d,fiber_d,column_t+eps]);
        }    
    }
    // Secure clip
    translate([column_t,0,fiber_h+fiber_d/2+column_margin_above_fiber]) rotate([0,-90,0]) linear_extrude(height = column_t, center = false, convexity = 10, twist = 0, slices = 1, scale = 1, $fn = 32){
        polygon(points);
    }
    difference(){
        translate([0,-washer_d,0]) cube([column_t,base_w,base_t]);
        translate([screw_d/2,-washer_d/2,-eps/2]){
            cylinder(d=screw_d,h=base_t+eps,$fn=30);
            translate([-screw_d,-screw_d/2,0]) cube([screw_d,screw_d,base_t+eps]);
        }
        translate([column_t-screw_d/2,base_w-washer_d*1.5,-eps/2]) rotate([0,0,180]){
            cylinder(d=screw_d,h=base_t+eps,$fn=30);
            translate([-screw_d,-screw_d/2,0]) cube([screw_d,screw_d,base_t+eps]);
        }
    }
}

// Image 512x512
translate([column_t/2,0,base_t+column_t]) rotate([90,90,0]) linear_extrude(height = 0.3) offset(delta=0.001) import(file = "QPL_logo_MM_initials.svg", center = true, dpi = 512*25.4/column_t);
