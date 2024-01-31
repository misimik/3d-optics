include <../screw_dimensions.scad>

$fs = 0.3;
eps = 0.01;
wall_t = 2;
pcb_l = 76;
pcb_w = 66;
pcb_thickness = 1.6;
pcb_base_standoff_h = 6;
pcb_top_standoff_h = 10;
hole_spacing_w = 56;
hole_w_offset = 5;
hole_spacing_l = 66;
hole_l_offset = 5;
margin = 0.5;
sma_w = 10;
sma_below = 3;
sma_above = 5;
cable_above = 8;
cable_w = 9;
standoff_d = 7;
texts = ["LOP", "LO_SE", "LON", "I_LO", "I_HI", "Q_LO", "Q_HI", "RF", "POWER"];
zip_tie_w = 5;
zip_tie_h = 2;

base = true;
base_modifier = false;
cover = true;
text_fill = false;
cover_modifier = false;

box_h = pcb_base_standoff_h+pcb_top_standoff_h+pcb_thickness+2*margin;
box_l = pcb_l + 2*(wall_t+margin);
box_w = pcb_w + 2*(wall_t+margin);
D = m6_head_d+2*(margin+wall_t);
echo(m3_screw_thread_d);

module standoff(){
    difference(){
        hull(){
            cylinder(d = standoff_d, h = pcb_base_standoff_h+wall_t);
            translate([-(wall_t+margin+standoff_d/2),-(wall_t+margin+standoff_d/2),0]){
                translate([0,0,0]) cube([standoff_d/2, eps, pcb_base_standoff_h+wall_t]);
                translate([0,0,0]) cube([eps, standoff_d/2, pcb_base_standoff_h+wall_t]);
            }
        }
        translate([0,0,-eps/2]) cylinder(d = m3_screw_thread_d, h = pcb_base_standoff_h+wall_t+eps);
    }
}

module sma_cut(){
    translate([-wall_t/2,0,pcb_base_standoff_h+wall_t-sma_below-margin]) cube( [2*wall_t, sma_w+2*margin, box_h ] );
}

module base(){
    union(){
        difference(){
            union(){
                cube( [ box_l, box_w, box_h+wall_t ] );
                translate([box_l+D/2,53.5,0]) rotate([0,0,90]) mounting_point();
                translate([13.5,box_w+D/2,0]) rotate([0,0,180]) mounting_point();
            }
            translate([wall_t,wall_t,wall_t]) cube( [ pcb_l+2*margin, pcb_w+2*margin, box_h+eps ] );
            // Port cutouts
            translate([0,15+wall_t,0]) sma_cut();
            translate([0,30+wall_t,0]) sma_cut();
            translate([0,45+wall_t,0]) sma_cut();
            translate([-wall_t/2,15+wall_t,pcb_base_standoff_h+wall_t-3/2*margin+pcb_thickness/2]) cube( [2*wall_t,30+sma_w+2*margin,box_h] );
            translate([10.5+wall_t,wall_t,0]) rotate([0,0,-90]) sma_cut();
            translate([25+wall_t,wall_t,0]) rotate([0,0,-90]) sma_cut();
            translate([40+wall_t,wall_t,0]) rotate([0,0,-90]) sma_cut();
            translate([54.5+wall_t,wall_t,0]) rotate([0,0,-90]) sma_cut();
            translate([10.5+wall_t,-wall_t/2,pcb_base_standoff_h+wall_t-3/2*margin+pcb_thickness/2]) cube( [44+sma_w+2*margin,2*wall_t,box_h] );
            translate([box_l-wall_t,31+wall_t,0])  sma_cut();
            translate([32+wall_t,pcb_w+wall_t/2+2*margin,pcb_base_standoff_h+wall_t+pcb_thickness-margin]) cube( [cable_w, 2*wall_t, box_h ] );
            
        }

        translate([margin+wall_t+hole_l_offset,margin+wall_t+hole_w_offset,0]) standoff();
        translate([margin+wall_t+hole_l_offset+hole_spacing_l,margin+wall_t+hole_w_offset+hole_spacing_w,0]) rotate([0,0,180]) standoff();
        translate([margin+wall_t+hole_l_offset+hole_spacing_l,margin+wall_t+hole_w_offset,0]) rotate([0,0,90]) standoff();
        translate([margin+wall_t+hole_l_offset,margin+wall_t+hole_w_offset+hole_spacing_w,0]) rotate([0,0,270]) standoff();
        translate([32+wall_t,pcb_w+2*wall_t+2*margin,0]) difference(){
            cube( [cable_w, zip_tie_w+wall_t, box_h/2-margin/2 ] );
            translate([-eps/2,0,(box_h/2-margin/2)/2-zip_tie_h/2]) cube( [cable_w+eps, zip_tie_w, zip_tie_h] );
            
        }
        
    }
}

module base_modifier(){
    difference(){
        translate([wall_t+margin,wall_t+margin,-eps/2]) cube( [ pcb_l+margin, pcb_w+margin, 2*wall_t ] );
        translate([margin+wall_t+hole_l_offset,margin+wall_t+hole_w_offset,-eps]) hull() standoff();
            translate([margin+wall_t+hole_l_offset+hole_spacing_l,margin+wall_t+hole_w_offset+hole_spacing_w,-eps]) rotate([0,0,180]) hull() standoff();
            translate([margin+wall_t+hole_l_offset+hole_spacing_l,margin+wall_t+hole_w_offset,-eps]) rotate([0,0,90]) hull() standoff();
            translate([margin+wall_t+hole_l_offset,margin+wall_t+hole_w_offset+hole_spacing_w,-eps]) rotate([0,0,270]) hull() standoff();
    }
}

module flat_texts(r, fill){
    translate([2,49+wall_t,0]){
        text(texts[0],size=3, font = "Liberation Sans");
    }
    translate([2,34+wall_t,0]){
        text(texts[1],size=3, font = "Liberation Sans");
    }
    translate([2,19+wall_t,0]){
        text(texts[2],size=3, font = "Liberation Sans");
    }
    translate([14.5,2,0]){
         text(texts[3],size=3, font = "Liberation Sans");
    }
    translate([29.5,2,0]){
         text(texts[4],size=3, font = "Liberation Sans");
    }
    translate([42.5,2,0]){
         text(texts[5],size=3, font = "Liberation Sans");
    }
    translate([57.5,2,0]){
         text(texts[6],size=3, font = "Liberation Sans");
    }
    translate([pcb_l-2,pcb_w/2+4,0]){
         text(texts[7],size=3, font = "Liberation Sans");
    }
    translate([pcb_l/2-6,pcb_w,0]){
         text(texts[8],size=3, font = "Liberation Sans");
    }
    translate([box_l/4,box_w/4,0]){
         text("IQ Demodulator ADL5387",size=3, font = "Liberation Sans");
    }
    translate([box_l/2,box_w/2,0]) offset(delta=0.001) import(file = "QPL_logo_MM_initials.svg", center = true, dpi = 600);
            
}

module texts(h, r, fill){
    // Text: AC
    if( fill ) linear_extrude(height = h, center = false, convexity = 10, twist = 0, slices = 1, scale = 1.0) offset(r=r) fill() flat_texts(0, false);
    else linear_extrude(height = h, center = false, convexity = 10, twist = 0, slices = 1, scale = 1.0) offset(r=r) flat_texts(0, false);
            
}

module cover(){
    translate([0,0,0]) mirror([0,0,1]){
        difference(){
            cube( [ box_l, box_w, wall_t ] );
            texts(0.2, 0, false);
            translate([wall_t+margin+hole_l_offset,wall_t+margin+hole_w_offset,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_screw_d+margin );
            translate([wall_t+margin+hole_l_offset+hole_spacing_l,wall_t+margin+hole_w_offset+hole_spacing_w,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_screw_d+margin );
            translate([wall_t+margin+hole_l_offset+hole_spacing_l,wall_t+margin+hole_w_offset,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_screw_d+margin );
            translate([wall_t+margin+hole_l_offset,wall_t+margin+hole_w_offset+hole_spacing_w,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_screw_d+margin );
        }
        difference(){
            translate([wall_t+margin,wall_t+margin,wall_t]) cube( [ pcb_l, pcb_w, wall_t ] );
            translate([2*wall_t+margin,2*wall_t+margin,wall_t]) cube( [ pcb_l+margin-2*wall_t, pcb_w+margin-2*wall_t, box_h+eps ] );
        }
        difference(){
            translate([0,15+wall_t+margin,wall_t]) cube( [2*wall_t,30+sma_w,box_h-(pcb_base_standoff_h-sma_below+1/2*margin+sma_below)] );
            translate([wall_t,15+wall_t+margin,2*wall_t]) cube( [wall_t,30+sma_w,box_h-(pcb_base_standoff_h-1/2*margin+pcb_thickness/2)] );
            translate([0,15+wall_t,pcb_top_standoff_h-sma_above-margin]) sma_cut();
            translate([0,30+wall_t,pcb_top_standoff_h-sma_above-margin]) sma_cut();
            translate([0,45+wall_t,pcb_top_standoff_h-sma_above-margin]) sma_cut();
        }
        difference(){
            translate([10.5+wall_t+margin,0,wall_t]) cube( [44+sma_w,2*wall_t,box_h-(pcb_base_standoff_h-sma_below+1/2*margin+sma_below)] );
            translate([10.5+wall_t+margin,wall_t,2*wall_t]) cube( [44+sma_w,2*wall_t,box_h-(pcb_base_standoff_h-sma_below-1/2*margin+sma_below)] );
            translate([10.5+wall_t,wall_t,pcb_top_standoff_h-sma_above-margin]) rotate([0,0,-90]) sma_cut();
            translate([25+wall_t,wall_t,pcb_top_standoff_h-sma_above-margin]) rotate([0,0,-90]) sma_cut();
            translate([40+wall_t,wall_t,pcb_top_standoff_h-sma_above-margin]) rotate([0,0,-90]) sma_cut();
            translate([54.5+wall_t,wall_t,pcb_top_standoff_h-sma_above-margin]) rotate([0,0,-90]) sma_cut();
        }
        translate([pcb_l+wall_t/2+2*margin,31+wall_t+margin,-wall_t+margin]) translate([-wall_t/2,0,pcb_base_standoff_h+wall_t-sma_below-margin]) cube( [2*wall_t, sma_w, sma_above+wall_t-2*margin ] );
        translate([32+wall_t+margin,pcb_w+2*margin,wall_t]) cube( [cable_w-2*margin, 2*wall_t, cable_above-wall_t ] );
    }
}

module triangle(){
   translate([wall_t,0,0]) rotate([0,-90,0]) linear_extrude(height=wall_t) polygon([[0,0],[0,m6_head_d+2*(margin+wall_t)],[m6_head_d+2*(margin+wall_t),m6_head_d+2*(margin+wall_t)]]);
}

module mounting_point(){
    difference(){
        union(){
            cylinder(h = wall_t, d = D);
            translate([-(m6_head_d+2*(margin+wall_t))/2,0,0]) cube([m6_head_d+2*(margin+wall_t),m6_head_d+2*(margin+wall_t),wall_t]);
        }
        translate([0,0,-eps/2]) cylinder(h = wall_t+eps, d = m6_screw_d+2*margin);
    }
    translate([D/2-wall_t,0,wall_t]) triangle();
    translate([-D/2,0,wall_t]) triangle();
}

if( base ) base();
if( base_modifier ) base_modifier();
if( cover ) rotate([0,180,0]){
    cover();
    translate([0,0,0]) cube( [eps,eps,eps] );
    translate([0, pcb_w+2*wall_t+2*margin, 0]) cube( [eps,eps,eps] );
    translate([pcb_l+2*wall_t+2*margin, 0, 0]) cube( [eps,eps,eps] );
    translate([pcb_l+2*wall_t+2*margin, pcb_w+2*wall_t+2*margin,0]) cube( [eps,eps,eps] );
}
if( text_fill ) rotate([0,180,0]) translate([0,0,-0.2]){
    texts(0.2, 0, false);
    translate([0,0,0]) cube( [eps,eps,eps] );
    translate([0, pcb_w+2*wall_t+2*margin, 0]) cube( [eps,eps,eps] );
    translate([pcb_l+2*wall_t+2*margin, 0, 0]) cube( [eps,eps,eps] );
    translate([pcb_l+2*wall_t+2*margin, pcb_w+2*wall_t+2*margin,0]) cube( [eps,eps,eps] );
}

if(cover_modifier){
    difference(){
        translate([-pcb_l-wall_t+margin, wall_t+margin, 0]) cube([pcb_l, pcb_w, wall_t]);
        rotate([0,180,0]) translate([0,0,-0.8]) texts(0.8, 2, true);
        translate([-(wall_t+margin+hole_l_offset),wall_t+margin+hole_w_offset,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_head_d+margin );
        translate([-(wall_t+margin+hole_l_offset+hole_spacing_l),wall_t+margin+hole_w_offset+hole_spacing_w,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_head_d+margin );
        translate([-(wall_t+margin+hole_l_offset+hole_spacing_l),wall_t+margin+hole_w_offset,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_head_d+margin );
        translate([-(wall_t+margin+hole_l_offset),wall_t+margin+hole_w_offset+hole_spacing_w,-eps/2]) cylinder( h = 2*wall_t+eps, d = m3_head_d+margin );
    }
    translate([0,0,0]) cube( [eps,eps,eps] );
    translate([0, pcb_w+2*wall_t+2*margin, 0]) cube( [eps,eps,eps] );
    translate([box_l, 0, 0]) cube( [eps,eps,eps] );
    translate([box_l, pcb_w+2*wall_t+2*margin,0]) cube( [eps,eps,eps] );
}




