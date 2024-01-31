include <../screw_dimensions.scad>;

/* [Hidden] */
// Smallest element size
$fs = 0.3;
// "Machine epislon"
eps = 0.01;
/* [Parameters] */
// Free space around external elements
margin = 0.5;
// Wall thickness
wall_t = 2;
// PCB length
pcb_l = 118;
// PCB width
pcb_w = 46;
// PCB thickness
pcb_t = 2.1;
// Thickness of 2 PCB sandwich
pcb_sandwich_t = 15.2;
// Hight of the standoff below the PCBs
pcb_base_standoff_h = 6;
// Hight of the standoff aboce the PCBs
pcb_top_standoff_h = 10;
// Spacing of the mouning holes across the PCB
hole_spacing_w = 40;
// Histance from the center of the hole to the edge of the PCB
hole_w_offset = 3;
// Spacing of the mouning holes along the PCB
hole_spacing_l = 97;
// Distance from the center of the hole to the edge of the PCB
hole_l_offset_2 = 3;
// Distance from the center of the hole to the edge of the PCB
hole_l_offset_1 = 18.5;
// VGA port width
vga_w = 31;
// VGA port hight
vga_h = 13;
// VGA port distance to the edge
vga_offset = 7.5;
// USB and power ports width
usb_power_w = 30;
// Power socked diameter
power_d = 15;
// USB and power ports hight
usb_power_h = 13.5;
// USB and power ports distance to the edge
usb_power_offset = 7;
// Power socket offset
power_offset_y = 8.5;
power_offset_z = 5.3;
// Mounting standoff diameter
standoff_d = 7;
/* [Rendering switches] */
// Render the base
base = true;
// Render modifier for the base (i.e. change the infill percentage or pattern to change the base into a mesh)
base_modifier = false;
// Render the cover
cover = true;
// Render the cover modifier
cover_modifier = false;
// Render the text infill for print-on-print markings
text_fill = false;

// Total box hight
box_h = 2*(wall_t+margin)+pcb_base_standoff_h+pcb_sandwich_t+pcb_top_standoff_h;
// Total base hight
base_h = wall_t+margin+pcb_base_standoff_h+pcb_sandwich_t+pcb_top_standoff_h;
// Total box length
box_l = pcb_l + 2*(wall_t+margin);
// Total box width
box_w = pcb_w + 2*standoff_d + 2*(wall_t+margin);
// External mounting point for M6 screw diameter
D = m6_head_d+2*(margin+wall_t);
// Calculation of external mounting points to match 25 mm grid of an optical table
mounting_points_spacing_l = (box_l-D) - ((box_l-D)%25);
mounting_points_spacing_w = ceil((box_w+m6_head_d)/25)*25;
// Hight of the standoff for mounting the cover
cover_standoff_h = box_h - 2*wall_t-2*margin;

module standoff(H){
    difference(){
        union(){
            cylinder(d = standoff_d, h = H);
            translate([0,-standoff_d/2,0]) cube([box_l,standoff_d,H]);
        }
        translate([0,0,-eps/2]) cylinder(d = m3_screw_thread_d, h = H+eps);
    }
}

module sma_cut(){
    translate([-wall_t/2,0,pcb_base_standoff_h+wall_t-sma_below-margin]) cube( [2*wall_t, sma_w+2*margin, box_h ] );
}

module base(){
    difference(){
        union(){
            // Main element
            cube([box_l, box_w, base_h]);
            // Mounting points
            translate([(box_l-mounting_points_spacing_l)/2,-(mounting_points_spacing_w-box_w)/2,0]) mounting_point();
            translate([(box_l-mounting_points_spacing_l)/2,box_w+(mounting_points_spacing_w-box_w)/2,0]) rotate([0,0,180]) mounting_point();
            translate([box_l-(box_l-mounting_points_spacing_l)/2,-(mounting_points_spacing_w-box_w)/2,0]) mounting_point();
            translate([box_l-(box_l-mounting_points_spacing_l)/2,box_w+(mounting_points_spacing_w-box_w)/2,0]) rotate([0,0,180]) mounting_point();
        }
        // Main cut
        translate([wall_t, wall_t, wall_t]) cube([box_l-2*(wall_t), box_w-2*wall_t, base_h]);
        // Port cut-outs
        translate([-eps/2,box_w/2-pcb_w/2+vga_offset, wall_t+pcb_base_standoff_h+pcb_t]) cube([wall_t+eps, vga_w+2*margin, base_h]);
        translate([-eps/2+box_l-wall_t,box_w/2-pcb_w/2+usb_power_offset, wall_t+pcb_base_standoff_h+pcb_t]) cube([wall_t+eps, usb_power_w+2*margin, base_h]);
    }
    // Standoffs
    intersection(){
        cube([box_l, box_w, base_h]);
        union(){
            // Pcb mount standoffs
            translate([wall_t+margin+hole_l_offset_1,box_w/2-pcb_w/2+hole_w_offset,0]) rotate([0,0,-90]) standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+hole_l_offset_1,box_w/2+pcb_w/2-hole_w_offset,0]) rotate([0,0,90]) standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+pcb_l-hole_l_offset_2,box_w/2+pcb_w/2-hole_w_offset,0]) rotate([0,0,90]) standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+pcb_l-hole_l_offset_2,box_w/2-pcb_w/2+hole_w_offset,0]) rotate([0,0,-90]) standoff(pcb_base_standoff_h+wall_t);
            // Cover mount standoffs
            translate([wall_t+standoff_d/2,standoff_d/2+wall_t,0]) rotate([0,0,-90]) standoff(cover_standoff_h);
            translate([wall_t+standoff_d/2,box_w-(standoff_d/2+wall_t),0]) rotate([0,0,90]) standoff(cover_standoff_h);
            translate([box_l-(wall_t+standoff_d/2),standoff_d/2+wall_t,0]) rotate([0,0,-90]) standoff(cover_standoff_h);
            translate([box_l-(wall_t+standoff_d/2),box_w-(standoff_d/2+wall_t),0]) rotate([0,0,90]) standoff(cover_standoff_h);
        }
    }
}

module base_modifier(){
    difference(){
        translate([wall_t, wall_t, 0]) cube([box_l-2*wall_t, box_w-2*wall_t, 2*wall_t]);
        translate([0,0,-eps/2]) union(){
            union(){
            // Pcb mount standoffs
            translate([wall_t+margin+hole_l_offset_1,box_w/2-pcb_w/2+hole_w_offset,0]) rotate([0,0,-90]) hull() standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+hole_l_offset_1,box_w/2+pcb_w/2-hole_w_offset,0]) rotate([0,0,90]) hull() standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+pcb_l-hole_l_offset_2,box_w/2+pcb_w/2-hole_w_offset,0]) rotate([0,0,90]) hull() standoff(pcb_base_standoff_h+wall_t);
            translate([wall_t+margin+pcb_l-hole_l_offset_2,box_w/2-pcb_w/2+hole_w_offset,0]) rotate([0,0,-90]) hull() standoff(pcb_base_standoff_h+wall_t);
            // Cover mount standoffs
            translate([wall_t+standoff_d/2,standoff_d/2+wall_t,0]) rotate([0,0,-90]) hull() standoff(cover_standoff_h);
            translate([wall_t+standoff_d/2,box_w-(standoff_d/2+wall_t),0]) rotate([0,0,90]) hull() standoff(cover_standoff_h);
            }
        }
    }
}

module triangle(){
   translate([wall_t,0,0]) rotate([0,-90,0]) linear_extrude(height=wall_t) polygon([[0,0],[0,2*D],[2*D,2*D]]);
}

module mounting_point(){
    difference(){
        union(){
            cylinder(h = wall_t, d = D);
            translate([-(D)/2,0,0]) cube([D,2*D,wall_t]);
        }
        translate([0,0,-eps/2]) cylinder(h = wall_t+eps, d = m6_screw_d+2*margin);
    }
    translate([D/2-wall_t,0,wall_t]) triangle();
    translate([-D/2,0,wall_t]) triangle();
}

module cover(){
    mirror([0,0,1]) difference(){
        union(){
            cube([box_l, box_w, wall_t]);
            translate([wall_t+margin,wall_t+margin,wall_t]) difference(){
                cube([box_l-2*(margin+wall_t), box_w-2*(margin+wall_t), wall_t]);
                translate([wall_t, wall_t, -eps/2]) cube([box_l-2*margin-4*wall_t, box_w-2*margin-4*wall_t, wall_t+eps]);
            }
            translate([0,box_w/2-vga_w/2,wall_t]) cube([wall_t+margin, vga_w, pcb_top_standoff_h]);
            #difference(){
                translate([box_l-wall_t-margin,box_w/2+pcb_w/2-usb_power_offset-usb_power_w-margin,wall_t]) cube([wall_t+margin, usb_power_w, pcb_top_standoff_h]);
                translate([box_l-wall_t-margin-eps/2,box_w/2+pcb_w/2-usb_power_offset-usb_power_w+power_offset_y,wall_t+pcb_top_standoff_h+power_offset_z]) rotate([0,90,0]) cylinder( h = 2*wall_t, d =  power_d+2*margin);
            }
        }
        // Mounting screw holes
        translate([wall_t+standoff_d/2,standoff_d/2+wall_t,-eps/2]) cylinder(h=2*wall_t+eps, d = m3_screw_d+2*margin);
        translate([wall_t+standoff_d/2,box_w-(standoff_d/2+wall_t),-eps/2]) cylinder(h=2*wall_t+eps, d = m3_screw_d+2*margin);
        translate([box_l-(wall_t+standoff_d/2),standoff_d/2+wall_t,-eps/2]) cylinder(h=2*wall_t+eps, d = m3_screw_d+2*margin);
        translate([box_l-(wall_t+standoff_d/2),box_w-(standoff_d/2+wall_t),-eps/2]) cylinder(h=2*wall_t+eps, d = m3_screw_d+2*margin);
        texts(0.2, 0, false);
    }
}

module cover_modifier(){
    difference(){
        translate([wall_t+margin,wall_t+margin,0]) cube([box_l-2*(margin+wall_t), box_w-2*(margin+wall_t), wall_t]);
        translate([wall_t+standoff_d/2,standoff_d/2+wall_t,-eps/2]) cylinder(h=2*wall_t+eps, d = m3_head_d+2*margin);
        translate([wall_t+standoff_d/2,box_w-(standoff_d/2+wall_t),-eps/2]) cylinder(h=2*wall_t+eps, d = m3_head_d+2*margin);
        translate([box_l-(wall_t+standoff_d/2),standoff_d/2+wall_t,-eps/2]) cylinder(h=2*wall_t+eps, d = m3_head_d+2*margin);
        translate([box_l-(wall_t+standoff_d/2),box_w-(standoff_d/2+wall_t),-eps/2]) cylinder(h=2*wall_t+eps, d = m3_head_d+2*margin);
        texts(wall_t, wall_t, true );
    }
}

module text_fill(){
    translate([0,0,-0.2]) linear_extrude(height = 0.2, center = false, convexity = 10, twist = 0, slices = 1, scale = 1.0) offset(r=0) flat_texts();
    cube( [eps,eps,eps] );
    translate([0, box_w, 0]) cube( [eps,eps,eps] );
    translate([box_l, 0, 0]) cube( [eps,eps,eps] );
    translate([box_l, box_w,0]) cube( [eps,eps,eps] );
}

module texts(h, r, fill){
    if( fill ) linear_extrude(height = h, center = false, convexity = 10, twist = 0, slices = 1, scale = 1.0) offset(r=r) fill() flat_texts();
    else linear_extrude(height = h, center = false, convexity = 10, twist = 0, slices = 1, scale = 1.0) offset(r=r) flat_texts();
}

module flat_texts(){
        translate([box_l*3/4-15,box_w/2+1,0]) mirror([1,0,0]) offset(delta=0.001){
            text("Standa 8SMC5-USB",size=5, font = "Liberation Sans:style=Bold");
        }
        translate([box_l*3/4-15,box_w/2-6.5,0]) mirror([1,0,0]) offset(delta=0.001){
            text("Stepper controller",size=5, font = "Liberation Sans:style=Bold");
        }
        translate([box_l*3/4+5,box_w/2,0]) mirror([1,0,0]) offset(delta=0.001) import(file = "QPL_logo_MM_initials.svg", center = true, dpi = 600);
            
}

if( base ) base();
if( base_modifier ) #base_modifier();
if( cover ) mirror([0,0,1]) translate([0,2*box_w,0]) cover();
if( text_fill ) mirror([0,0,1]) translate([0,2*box_w,0]) text_fill();
if( cover_modifier ) translate([0,2*box_w,0]) #cover_modifier();







