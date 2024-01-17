// Protractor for measuring paddle angle
// Michał Mikołajczyk michal@mikolajczyk.link

thickness = 2;
inner_r = 90;
outer_r = 110;
width = outer_r-inner_r;
hole_spacing = 200;
hole_d = 7;
base_w = 15;
base_l = 25;
tick_w = 0.75;
tick_depth = 0.2; //Layer hight
major_tick_h = 0.5;
mid_tick_h = 0.4;
minor_tick_h = 0.3;
margin = 1.5;
mat_h = major_tick_h*(outer_r-inner_r)-margin;
mdt_h = mid_tick_h*(outer_r-inner_r)-margin;
mit_h = minor_tick_h*(outer_r-inner_r)-margin;
brace_h = 5;
brace_t = 2;

arc = true;
just_labels = true;
brace = true;
base = true;


eps = 0.01;
$fn = 100;



//Ticks
module major_tick(){
    hull(){
        translate([ tick_w/2, 0, 0 ]) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
        translate( [ mat_h-tick_w/2, 0, 0 ] ) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
    }
}
module mid_tick(){
    hull(){
        translate([ tick_w/2, 0, 0 ]) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
        translate( [ mdt_h-tick_w/2, 0, 0 ] ) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
    }
}
module minor_tick(){
    hull(){
        translate([ tick_w/2, 0, 0 ]) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
        translate( [ mit_h-tick_w/2, 0, 0 ] ) cylinder( h = tick_depth, d = tick_w, $fn = 10 );
    }
}

// Arc
module arc(){
    difference(){
        cylinder( h = thickness, r = outer_r );
        minkowski(){
            cylinder( h = thickness, r = inner_r );
            sphere(d = eps);
        }
        translate( [ -outer_r, -outer_r-base_w, -eps/2 ] ) cube( [2*outer_r, outer_r, thickness+eps] );
    }
    
//    Positioners
    translate([ outer_r + 5, outer_r + 5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ -outer_r - 5, outer_r + 5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ -outer_r - 5, -base_w*1.5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ +outer_r + 5, -base_w*1.5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
}
module ticks_and_labels(){
        for(i = [0:10:180]){
        rotate([0,0,i]) translate( [(inner_r + margin),0,-eps] ) major_tick();
        rotate([0,0,-i]) translate([-outer_r+mat_h+margin,0,-eps]) mirror([0,1,0]) rotate([0,0,90]) linear_extrude(height = tick_depth) text( text = str(180-i), size = mdt_h, halign="center"); 
    }
    for(i = [0:1:180]){
        rotate([0,0,i]) translate( [(inner_r + margin),0,-eps] ) minor_tick(); 
    }
    for(i = [0:5:180]){
        rotate([0,0,i]) translate( [(inner_r + margin),0,-eps] ) mid_tick();
    }    
}

// Base
module base(){
    difference(){
        translate( [ cos(asin(base_w/inner_r))*inner_r, -base_w, 0 ] ) cube( [ width, thickness, base_l ] );
        translate( [ hole_spacing/2, -base_w-thickness/2, base_l/2 ] ) rotate( [ -90, 0, 0] ) cylinder(h = 2*thickness, d = hole_d);
        
    }
    difference(){
        translate( [ -cos(asin(base_w/inner_r))*inner_r-width, -base_w, 0 ] ) cube( [ width, thickness, base_l ] );
        translate( [ -hole_spacing/2, -base_w-thickness/2, base_l/2 ] ) rotate( [ -90, 0, 0] ) cylinder(h = 2*thickness, d = hole_d);
    }
    intersection(){
        difference(){
            cylinder( h = base_l, r = inner_r+brace_t );
            minkowski(){
                cylinder( h = base_l, r = inner_r );
                sphere(d = eps);
            }
            translate( [ -outer_r, -outer_r-base_w, -eps/2 ] ) cube( [2*outer_r, outer_r, base_l+eps] );
        }
        translate( [ -outer_r, -base_w+thickness, 0 ] ) hull(){
            cube( [ 2*outer_r, eps, base_l ] );
            cube( [ 2*outer_r, base_l, eps ] );
        }
    }
}

// Brace
module brace(){
    difference(){
        cylinder( h = brace_h + thickness, r = inner_r+brace_t );
        minkowski(){
            cylinder( h = brace_h + thickness, r = inner_r );
            sphere(d = eps);
        }
        translate( [ -outer_r, -outer_r-base_w, -eps/2 ] ) cube( [2*outer_r, outer_r, thickness+brace_h+eps] );
        translate( [ hole_spacing/2, -base_w-thickness/2, base_l/2 ] ) rotate( [ -90, 0, 0] ) cylinder(h = 2*thickness, d = hole_d);
        translate( [ -hole_spacing/2, -base_w-thickness/2, base_l/2 ] ) rotate( [ -90, 0, 0] ) cylinder(h = 2*thickness, d = hole_d);
    }
}

if(arc && !just_labels){
    difference(){
        arc();
        ticks_and_labels();
    }
}

if(just_labels){
    ticks_and_labels();
//    Positioners
    translate([ outer_r + 5, outer_r + 5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ -outer_r - 5, outer_r + 5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ -outer_r - 5, -base_w*1.5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
    translate([ +outer_r + 5, -base_w*1.5, 0 ]) cylinder(h = 1, d = 1, $fn = 10);
}

if(brace) brace();
if(base) base();


