// Designer: Michał Mikołajczyk michal@mikolajczyk.link
// Last edit: 2024.01.16

// A plate for fragile fibers.
// The design consists of a base and a cover.
// The base has a channel for a fragile fiber (ie. fiber Bragg grating)
// with slots to guide sticky-tape to hold pigatils spliced to the fragile fiber.
// The fragile fiber is intended to be hold by a thin strip of a sponge
// or a gasket which is then compressed by a ring in the cover.
// The cover is mounted to the base with screws or zip-ties guide through the holes.

/* [General] */

// General render resolution
$fn = 30;
// Rise to 1000 for final rendering
cylinders_resolution = 100;
// Radius of the fiber spool
internal_diameter = 145;
// Spool width
storing_ring_width = 5;
wall_thickness = 1.5;
base_thickness = 1.5;




/* [Base] */

pigtail_brim_width = 10;
plate_hight = 10;
tape_slot_width = 2;
// Minimal width of the tape slot
tape_slot_minlength = 15;
tape_slot_fraction = 0.2;
fiber_slot_width = 5;

/* [Cover] */
//Hight of the sponge compressing ring
commpression_h = 4;
// Lower for more snug fit
insertion_margin = 0.05;

/* [Joining] */
screw_number = 3; // [3:11]
// M4 screw hole
screw_d = 4.5;
// M4 head diameter
head_d = 7.2;
// M4 nut diameter
m4_2h = 6.9;
nut_d = m4_2h * 2/sqrt(3);
// M4 nut hight
nut_h = 3.4;
// Threaded insert hole diameter.
insert_d = 5.5;
// Threaded insert hight
insert_h = 5;


screw_post_d = max(nut_d, insert_d, head_d) + 2*wall_thickness;
echo(screw_post_d);

/* [Render selectors] */

// Render base
base = true;
// Render cover
cover = false;
// Put holes to save on plastic?
make_holes = false;
// Circular or hex holes
hex_holes = false;
// Screw holes, posts and insert/nut slots
joinging_with_screws = false;
// Screw posts: Insert = true, nut=false
insert = true;

/* [Hidden] */

// Put logo on the cover?
logo = true;
// Small value to beautify rendering
eps = 0.01;

l = 3.14159*(internal_diameter+2*(storing_ring_width+wall_thickness))*tape_slot_fraction;
slot_number = floor(l / 2 / tape_slot_minlength);
tape_slot_length = l / 2 / slot_number;

module wall(hight, diameter, wall_thickness){
    difference(){
        cylinder(h = hight, d = diameter, $fn=cylinders_resolution);
        translate([0,0,-eps/2]) cylinder(h = hight+eps, d = diameter-2*wall_thickness, $fn=cylinders_resolution);
    }
}

module tape_slot(){
    translate([0,0,-plate_hight/2]) difference(){
        intersection(){
            translate([-tape_slot_length/2,-(internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width))/2,0]) cube([tape_slot_length, internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width),plate_hight]);
            cylinder( h = plate_hight, d = internal_diameter+2*(storing_ring_width+wall_thickness+tape_slot_width) );
        }
        intersection(){
            translate([-tape_slot_length/2,-(internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width))/2,0]) cube([tape_slot_length, internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width),plate_hight]);
            cylinder( h = plate_hight, d = internal_diameter+2*(storing_ring_width+wall_thickness) );
        }
    }
}

module hole_maker(D, H){
    a = 25*sqrt(2)/4;
    sS = 6; // Space for the screwhead separation
    sH = 7; // Space for the screwhead height
    hD = 7; // Hole diameter
    b = 10;
    module hex_grid(b, hD){
        render() intersection(){
                cylinder(h = H, d = D);
                union(){
                    for(x = [-D/2:a:D/2]) {
                        for(y = [-D/2:2*a*sin(60):D/2]) {
                            translate([x-sH/2, y-sH/2, -H]) rotate([0,0,30]) cylinder( d = sH, h = 3*H, $fn=b );
                            translate([x-sH/2 + a*cos(60), y -sH/2 + a*sin(60), -H]) rotate([0,0,30]) cylinder( d = sH, h = 3*H, $fn=b );
                        };
                    };
                };
            };
    }
    if(hex_holes){
        b = 6;
        hD = 8*2/sqrt(3); // Hole diameter
        hex_grid(b, hD);
    }
    else{
        b = 10;
        hD = 7; // Hole diameter
        hex_grid(b, hD);
    }
};

module base(){
//  Internal wall
    wall(plate_hight, internal_diameter, wall_thickness);
//  Outer wall with slots
    difference(){
        wall(plate_hight, internal_diameter+2*(storing_ring_width+wall_thickness), wall_thickness);
    //  Slot for fiber to leave the spool 1.
        translate([internal_diameter/2-fiber_slot_width/2,-(internal_diameter/2+storing_ring_width+wall_thickness+pigtail_brim_width),base_thickness]) cube([fiber_slot_width, internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width), plate_hight]);
    //  Slot for fiber to leave the spool 2.
        rotate([0,0,180]) translate([internal_diameter/2-fiber_slot_width/2,-(internal_diameter/2+storing_ring_width+wall_thickness+pigtail_brim_width),base_thickness]) cube([fiber_slot_width, internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width), plate_hight]);
    }
//  Base plate with holes
    difference(){
        cylinder( h = base_thickness, d = internal_diameter+2*(storing_ring_width+wall_thickness+pigtail_brim_width), $fn=cylinders_resolution );
        for( i = [0:1:slot_number]){
            rotate([0,0,i*180/slot_number]) tape_slot();
        }
        if(make_holes){
            translate([0,0,-base_thickness]) hole_maker(internal_diameter, 3*base_thickness);
        }
        if( joinging_with_screws ){
            screw_post_prep(internal_diameter, plate_hight, internal_diameter);
            screw_head_hole_prep(internal_diameter,base_thickness);
        }
    }
    if( joinging_with_screws ){
        screw_post(internal_diameter, plate_hight, internal_diameter);
        screw_head_hole(internal_diameter,base_thickness);
    }
}

module cover(){
    translate([0,0,plate_hight-commpression_h-eps/2]) wall(commpression_h, internal_diameter+2*(storing_ring_width-2*insertion_margin), storing_ring_width-insertion_margin*5);
    translate([0,0,plate_hight-eps/2]){
        difference(){
            cylinder( h = base_thickness, d = internal_diameter+2*(storing_ring_width+wall_thickness), $fn=cylinders_resolution);
            if(make_holes){
                    translate([0,0,-base_thickness]) hole_maker(internal_diameter, 3*base_thickness);
            }
            if(logo){ logo_prep(); }
            if( joinging_with_screws ){ screw_post_prep(internal_diameter, base_thickness, internal_diameter+storing_ring_width); }
        }
        if(logo){ logo(); }
        if( joinging_with_screws ){ screw_post(internal_diameter, base_thickness, internal_diameter+storing_ring_width); }
    }
}

// QPL LOGO
module logo(){
    difference(){
        translate([-12.5,-12.5,0]) cube([25,25,base_thickness]);
        translate([0,0,1.5*base_thickness]) mirror([0,0,1]) rotate([0,0,0]) linear_extrude(height = base_thickness, center = false, convexity = 10, twist = 0, slices = 1, scale = 1, $fn = 32){
            offset(delta=0.001) import(file = "QPL_logo_MM_initials.svg", center = true, dpi = 600);
        };
    }
}

module logo_prep(base_t){
    translate([-12.5,-12.5,-base_thickness]) cube([25,25,3*base_thickness]);
}

module screw_post(D, H, D_extend){
d = D-2*wall_thickness;
    for(i = [0:1:screw_number]){
        rotate([0,0,i*360/screw_number]) intersection(){
            translate([d/2-screw_post_d/2,0,0]){
                difference(){
                    union(){
                        cylinder(h = H, d = screw_post_d);
                        translate([0,-screw_post_d/2,0]) cube( [100, screw_post_d, H] );
                    }
                    if(insert){
                        translate([0,0,-eps/2]) cylinder(h = insert_h+eps, d = insert_d);  
                        }
                    else{
                        translate([0,0,-eps/2]) cylinder(h = nut_h+eps, d = nut_d, $fn=6);
                    }
                    translate([0,0,-eps/2])cylinder(h = H+eps, d = screw_d);
                }
            }
            cylinder(h = H, d = D_extend-2*wall_thickness, $fn=cylinders_resolution);
        }
    }
}

module screw_post_prep(D, H, D_extend){
d = D-2*wall_thickness;
    render() for(i = [0:1:screw_number]){
        rotate([0,0,360/screw_number*i]) intersection(){
            translate([d/2-screw_post_d/2,0,0]){
                union(){
                    cylinder(h = H, d = screw_post_d);
                    translate([0,-screw_post_d/2,0]) cube( [100, screw_post_d, H] );
                }
            }
            cylinder(h = H, d = D_extend-2*wall_thickness, $fn=cylinders_resolution);
        }
    }
}

module screw_head_hole(D,H){
    d = D-2*wall_thickness;
    for(i = [0:1:screw_number]){
        rotate([0,0,(i+0.5)*360/screw_number]) translate([d/2-screw_post_d/2,0,0]){
                difference(){
                    cylinder(h = H, d = screw_post_d);
                    translate([0,0,-eps/2]) cylinder(h = H+eps, d = head_d);
                }
            }
    }
}

module screw_head_hole_prep(D,H){
d = D-2*wall_thickness;
    render() for(i = [0:1:screw_number]){
        rotate([0,0,(i+0.5)*360/screw_number]) translate([d/2-screw_post_d/2,0,0]){
            cylinder(h = H, d = screw_post_d);
        }
    }
}

if( cover ){ color("MediumSeaGreen", 1.0) cover(); }
if( base ){ base(); }