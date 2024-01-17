/*######################################################################################################################

                                         3D PRINTED FIBER POLARIZATION CONTROLLER
                                              WITH ADJUSTABLE LOOP DIAMETER

                                                       Created by: 
                                                      Filip Sośnicki
                                               Quantum Photonics Laboratory
                                                   University of Warsaw
                                    
                                     Calibrated (@1555nm with SMF-28, attached graph) by:
                                                    Michał Zmyślony   
                                               Quantum Photonics Laboratory
                                                   University of Warsaw
                                    
                                                    Check our websites:
                                                     photon.fuw.edu.pl
                                                     optics.fuw.edu.pl
                                                     
                                                       Last update:
                                                        31.08.2022
                                                        
TIP: for rendering separate STL models of paddles (with brim) and paddle covers use code at the end of the file,
     for other parts use ! operator                                                     
//######################################################################################################################
*/




$fn = 100;
delta = 0.001; // epsilon for better preview 
XYcomp = 0.15; // 3D printer XY overflow compensation 


fiber_diameter = 1; //900um + 100um gap  

screw_diameter = 4; 
screw_head_diameter = 7; 
screw_min_case_thickness = 3;
screw_min_case_thickness2 = 1.5;
nut_width = 7; 
nut_thickness = 3; 




R = 14.7; //14.7mm for 1550nm (experimental), 17.4mm for 1310nm (extrapolated)


num_of_paddles = 1;

paddle_thickness = 5.5;
paddle_diameter = 2*R + 2*fiber_diameter + 3;
paddle_cover_thickness = 2;
paddle_cylinder_diameter = paddle_thickness+paddle_cover_thickness-1;
paddle_cover_thickness_screw = 1;
paddle_cover_screw_case_thickness = 2;
paddle_groove = 4.25*fiber_diameter;
paddle_groove_cylinder_diameter = paddle_cylinder_diameter - 2+0.25*fiber_diameter;
paddle_fillet = 2;
paddle_minimal_thickness_screw = 2;

paddles_distance = 50;
paddles_distance_mod = paddles_distance-paddle_diameter;
paddles_height = paddle_cylinder_diameter/2 + 9;

paddle_stick_length = 100;
paddle_stick_width = 10;

holder_thickness = paddle_cylinder_diameter/2+4;
holder_fillet = 0.5;
holder_fillet2 = 12;
holder_delta_axis = 0.2;
holder_width = paddles_distance_mod+paddle_diameter-35;
holder_height = 2;
holder_holes_delta = 1;

base_holder_thickness = 5;
base_holder_height = paddles_height-paddle_cylinder_diameter/2-1;
base_width = 30;
base_thickness = 3;
base_end_width = 10;
base_end_fillet = 3;
base_mountingholes_depth = 6;
base_mountingholes_distance = 15;

base_end_cover_height = 2;

num_of_magnets = 3;
magnet_diameter = 10;
magnet_thickness = 3;
magnet_distance_to_end = 7;


smoother_thickness = 3;
smoother_length = 30;
smother_steps = 200;
smoother_lock_width = 5;


total_in_length = num_of_paddles*(paddle_diameter+paddles_distance_mod)+holder_width;
total_out_length = total_in_length + 2*base_end_width;

paddles = true;
paddle_cover = true;
paddle_stick = true;
holders = true;
base = true;
base_covers = true;
smoothers = true;




// ================================================   GENERAL MODULES   =================================================
 module regular_polygon(order = 4, r=1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }

module fillet(r = 10, R = 20){
    translate([0,0,r]) rotate_extrude(convexity = 10) translate([R-r,0,0]) rotate(-90) difference(){   
        square(r);
        circle(r);
    }
}   

module fillet2(r = 10, h = 20){
    translate([-r+delta,-r+delta,-delta]) linear_extrude(height=h+2*delta)  difference(){   
        square(r);
        circle(r);
    }
}

module nuthole(h=10,h2=screw_min_case_thickness){
    union(){
        cylinder(d = screw_diameter+XYcomp,h=h);
        translate([0,0,-delta]) linear_extrude(height = h-h2) regular_polygon(order = 6, r = 1/sqrt(3)*nut_width+XYcomp);
    }
}

module mountinghole(){
    union(){
        translate([0,-3+base_mountingholes_depth,0]) cylinder(d = 6+2*XYcomp, h = base_thickness+2*delta);
        translate([-3-XYcomp,-delta,0]) cube([6+2*XYcomp,base_mountingholes_depth-3+delta,base_thickness+2*delta]);
        translate([3+XYcomp,0,delta]) rotate(180) fillet2(r = 3+XYcomp, h = base_thickness);
        translate([-3-XYcomp,0,delta]) rotate(270) fillet2(r = 3+XYcomp, h = base_thickness);
    }
}

module revolve_text(radius, chars, x) {
    PI = 3.14159;
    circumference = x*2 * PI * radius;
    chars_len = len(chars);
    font_size = 1.4*circumference / chars_len;
    step_angle = x*360 / chars_len;
    for(i = [0 : chars_len - 1]) {
        rotate(-i * step_angle) 
            translate([0, radius + font_size / 2, 0]) 
                text(
                    chars[i], 
                    font = "Arial Black:style=Bold", 
                    size = font_size, 
                    valign = "bottom", halign = "center",
                    spacing = 1
                );
    }
}

//=======================================================   PARTS   ======================================================



//-------------------------------------------------------   PADDLE   ------------------------------------------------------
module paddle(){
    difference(){
        union(){
            //main body
            difference(){
                cylinder(d = paddle_diameter, h = paddle_thickness);
                //fillet
                translate([0,0,-delta]) fillet(R = paddle_diameter/2+delta,r = paddle_fillet+delta);
            }
            // cylinder
            translate([-(paddle_diameter+paddles_distance_mod)/2,-R,(paddle_thickness+paddle_cover_thickness)/2]) rotate(a = 90, v = [0,1,0]) cylinder(d = paddle_cylinder_diameter, h = paddle_diameter+paddles_distance_mod);     
            }
            // fiber groove
            translate([0,0,paddle_thickness - paddle_groove+delta])difference(){
                cylinder(r = R+fiber_diameter/2+XYcomp, h = paddle_groove+paddle_cover_thickness);
                translate([0,0,-delta]) cylinder(r = R-fiber_diameter/2-XYcomp, h = paddle_groove+2*delta+paddle_cover_thickness);
            }
            // screw hole
            translate([0,0,-delta]) cylinder(d = screw_diameter+2*XYcomp, h = paddle_thickness + 2*delta);
            // place for nut
            translate([0,0,-delta]) linear_extrude(height = nut_thickness+delta) regular_polygon(order = 6, r = 1/sqrt(3)*nut_width+XYcomp);
            // straight groove
            translate([-(paddle_diameter+paddles_distance_mod)/2-delta,-R-fiber_diameter/2-XYcomp,paddle_thickness-paddle_groove]) cube([paddle_diameter+paddles_distance_mod+2*delta,fiber_diameter+2*XYcomp,paddle_groove+delta+paddle_cover_thickness]);
            // cylinder groove
            translate([-delta,-R,(paddle_thickness+paddle_cover_thickness)/2]) rotate(a = 90, v = [0,1,0]) rotate(90){
                hull(){
                    translate([-fiber_diameter/2-XYcomp,-paddle_groove/2,0])cube([fiber_diameter+2*XYcomp,paddle_groove,1]);
                    translate([0,0,(paddle_diameter+paddles_distance_mod)/2+delta])cylinder(d = paddle_groove_cylinder_diameter+2*XYcomp, h = 1);
                }
                hull(){
                    translate([-fiber_diameter/2-XYcomp,-paddle_groove/2,0])cube([fiber_diameter+2*XYcomp,paddle_groove,1]);
                    translate([0,0,-(paddle_diameter+paddles_distance_mod)/2-delta]) cylinder(d = paddle_groove_cylinder_diameter+2*XYcomp, h = 1);
                }
            }
            // place for cover    
            translate([0,0,paddle_thickness+delta]) cylinder(d = paddle_diameter+2*XYcomp, h = paddle_cover_thickness);
    }
   
}


//----------------------------------------------------   PADDLE COVER   ---------------------------------------------------
module paddle_cover(){
    if(paddle_stick){
        translate([(R+fiber_diameter/2+XYcomp),-paddle_stick_width/2,0]) cube([paddle_stick_length,paddle_stick_width,paddle_cover_thickness]);
    }
    difference(){
        union(){
            cylinder(d = paddle_diameter, h = paddle_cover_thickness);
            }
            // screw hole
            translate([0,0,-delta-(paddle_thickness-nut_thickness-paddle_cover_thickness)]) cylinder(d = screw_diameter, h = paddle_cover_thickness+2*delta);
            // screw head hole
            translate([0,0,+1]) cylinder(d = screw_head_diameter, h = paddle_cover_thickness-1+delta); 
            //fillet
            translate([0,0,paddle_fillet+delta]) rotate(a = 180, v=[1,0,0])fillet(R = paddle_diameter/2+delta,r = paddle_fillet+delta);
           
            #translate([0,0,-delta]) difference(){
                cylinder(r = R+fiber_diameter/2+XYcomp, h = 0.5);
                translate([0,0,-delta]) cylinder(r = R-fiber_diameter/2-XYcomp, h = 0.5+2*delta);
            }  
    }
}



//-------------------------------------------------------   HOLDERS   ------------------------------------------------------
module holder(){
    difference(){
        minkowski(){
            difference(){
                    translate([-holder_width/2+holder_fillet,-paddles_height+holder_fillet+1,holder_fillet]) cube([holder_width-2*holder_fillet,paddles_height+paddle_cylinder_diameter/2+holder_height-2*holder_fillet-1,holder_thickness-2*holder_fillet]);
                    translate([-(paddle_diameter+paddles_distance_mod)/2,R,-delta]) cylinder(d = paddle_diameter+holder_fillet/2+holder_fillet2, h = holder_thickness); 
                    translate([(paddle_diameter+paddles_distance_mod)/2,R,-delta]) cylinder(d = paddle_diameter+holder_fillet/2+holder_fillet2, h = holder_thickness);                        
                    translate([-holder_width/2,-paddles_height+holder_fillet+XYcomp,holder_fillet]) cube([holder_width+2*delta, base_holder_height, base_holder_thickness/2]);
                }     
                sphere(holder_fillet);
            }
            translate([-delta-holder_width/2,0,-holder_delta_axis])rotate(a = 90, v=[0,1,0]) cylinder(d = paddle_cylinder_diameter, h = holder_width+2*delta );
            translate([0,-paddles_height+base_holder_height/2+holder_holes_delta,0]) cylinder(d = screw_diameter, h = holder_thickness+2*delta );
        }
}

module holderA1(){
    difference(){
        holder();
        translate([0,-paddles_height+base_holder_height/2+holder_holes_delta,base_holder_thickness/2+screw_min_case_thickness2]) cylinder(d=screw_head_diameter+XYcomp,h=holder_thickness-screw_min_case_thickness2);
    }
}

module holderA2(){
    difference(){
        holder();
        translate([0,-paddles_height+base_holder_height/2+holder_holes_delta,holder_thickness+base_holder_thickness/2]) rotate([180,0,0]) nuthole(h=holder_thickness,h2=screw_min_case_thickness2);
    }
}

module holderB2(){
    difference(){
        holder();
        translate([0,-paddles_height+base_holder_height/2+holder_holes_delta,holder_thickness+base_holder_thickness/2]) rotate([180,0,0]) nuthole(h=holder_thickness,h2=screw_min_case_thickness2);
         translate([-0.5,-paddles_height,0]) cube([holder_width-2+2*delta, base_holder_height+paddle_cylinder_diameter/2, base_holder_thickness/2]);
    }
}

module holderC1(){
    difference(){
        holder();
        translate([0,-paddles_height+base_holder_height/2+holder_holes_delta,base_holder_thickness/2+screw_min_case_thickness2]) cylinder(d=screw_head_diameter+2*XYcomp,h=holder_thickness-screw_min_case_thickness2);
        translate([-0.5,-paddles_height,0]) cube([holder_width-2+2*delta, base_holder_height+paddle_cylinder_diameter/2, base_holder_thickness/2]);
    }    
}



module holderB1(){
    mirror([1,0,0]) holderC1();
}

module holderC2(){
    mirror([1,0,0]) holderB2();
}

//---------------------------------------------------   BASE END BASE   ---------------------------------------------------
module base_end_base(h1 = paddles_height+base_thickness, h2 = paddles_height){
    difference(){
        cube([base_end_width,base_width,h1]);
         // longer fillets
        rotate(a = 180) fillet2(r = base_end_fillet, h=h1+2*delta);
        translate([0,base_width,0]) rotate(a = 90) fillet2(r = base_end_fillet, h=h1+2*delta);
        //shorter fillets
        translate([base_end_width,0,h1-h2])  rotate(a = 270) fillet2(r = base_end_fillet, h=h2+2*delta);
        translate([base_end_width,base_width,h1-h2]) fillet2(r = base_end_fillet, h=h2+2*delta);
        // screw holes
        translate([base_end_width/2,5,-delta]) nuthole(h = h1+2*delta);
        translate([base_end_width/2,base_width-5,-delta]) nuthole(h = h1+2*delta);
    }
}

//------------------------------------------------------   BASE END   -----------------------------------------------------
module base_end(h1 = paddles_height+base_thickness, h2 = paddles_height){
    difference(){
        union(){
            base_end_base(h1=h1,h2=h2);
            //cylinder
            translate([base_end_width/2-XYcomp,base_width/2,paddles_height+paddle_cylinder_diameter/2]) rotate(a = 90, v = [0,1,0])  
                cylinder(d = paddle_cylinder_diameter-2*XYcomp, h = (base_end_width+holder_width)/2);
            //undercylinder
            translate([base_end_width-XYcomp,(base_width-base_holder_thickness)/2+XYcomp,base_thickness]) cube([holder_width/2,base_holder_thickness-2*XYcomp,paddles_height]);
        }
        //cylinder
        translate([base_end_width/2-delta,base_width/2,paddles_height+paddle_cylinder_diameter/2])
            rotate(a = 90, v = [0,1,0]) cylinder(d2 = paddle_groove_cylinder_diameter+2*XYcomp, d1 = fiber_diameter+2*XYcomp, h = (base_end_width+holder_width)/2+2*delta);
        translate([base_end_width/2-delta,(base_width-fiber_diameter)/2-XYcomp,paddles_height+base_thickness]) cube([(base_end_width+holder_width)/2+2*delta,fiber_diameter+2*XYcomp,paddle_cylinder_diameter/2+delta]);
         translate([-delta,base_width/2,paddles_height+base_thickness] ) rotate(a = 90, v = [0,1,0]) cylinder(d = fiber_diameter+XYcomp, h = base_end_width+2*delta);
    }    
}



//----------------------------------------------------  BASE END COVER  ---------------------------------------------------
module base_end_cover(h = 2) difference(){
    base_end_base(h1=h, h2=h);
    translate([-delta,base_width/2,0]) rotate([0,90,0]) cylinder(d = fiber_diameter+2*XYcomp, h = base_end_width+2*delta);
    translate([delta+base_end_width/2,base_width/2,0]) rotate([0,90,0]) cylinder(d=paddle_cylinder_diameter+2*XYcomp,h = base_end_width/2+2*delta);
}



//--------------------------------------------------------   BASE   -------------------------------------------------------
module base(){
    difference(){
        union(){
            base_end();
            translate([total_out_length,base_width,0]) rotate(180) base_end();
            // bar
            translate([base_end_width,(base_width-base_holder_thickness)/2,base_thickness]) cube([total_in_length,base_holder_thickness,base_holder_height]);
            difference(){
                // base plate
                translate([base_end_width,0,0]) cube([total_in_length,base_width,base_thickness]);
                //mounting holes
                num_of_holes = floor((total_in_length-6)/base_mountingholes_distance);
                for( i = [0:num_of_holes]){
                    translate([total_out_length/2 + (i-num_of_holes/2)*base_mountingholes_distance,0,-delta]){
                        mountinghole();
                        translate([0,base_width,0]) rotate(180) mountinghole();
                    }
                }     
            }
        }
        for(i = [0:num_of_paddles]) translate([i*(paddle_diameter+paddles_distance_mod),0,0]){
            translate([base_end_width+holder_width/2,base_width/2+delta+base_holder_thickness/2,base_thickness+base_holder_height/2+holder_holes_delta]) rotate([90,0,0])cylinder(d=screw_diameter+2*XYcomp,h=base_holder_thickness+2*delta);
        }
        for(i = [1:num_of_magnets]) translate([magnet_distance_to_end+magnet_diameter/2+(total_out_length-magnet_distance_to_end*2-magnet_diameter)/(num_of_magnets-1)*(i-1),base_width/2,-delta]) cylinder(d = magnet_diameter+2*XYcomp, h= magnet_thickness+2*delta);
    
        translate([smoother_lock_width/2,base_width/2,-delta]) linear_extrude(height=0.75*(paddles_height+base_thickness)+delta ) rotate(180) regular_polygon(order=3,r =smoother_lock_width+XYcomp);
         translate([total_out_length-smoother_lock_width/2,base_width/2,-delta]) linear_extrude(height=0.75*(paddles_height+base_thickness)+delta )  regular_polygon(order=3,r =smoother_lock_width+XYcomp);
        translate([base_end_width+holder_width+1+paddle_diameter/2-17,(base_width-base_holder_thickness)/2-5,base_thickness-0.5]) linear_extrude(height = 0.5+delta)text("Filip Sośnicki",font = "Liberation Sans:style=Bold",size=3.8);

    }
}





//-------------------------------------------------------   ADDONs   -------------------------------------------------------
module smoother(){
    rotate(90) union(){
        translate([0,-smoother_lock_width/2,0]) linear_extrude(height=0.75*(paddles_height+base_thickness)-1 ) rotate(3*360/12) regular_polygon(order=3,r =smoother_lock_width);
        translate([-smoother_thickness/2,0,0])for(a=[0:smother_steps]){
            hull(){
               translate([0,smoother_length*a/smother_steps,0])cube([smoother_thickness,delta,(paddles_height+base_thickness-fiber_diameter/2)/2*(1+cos(180*a/smother_steps))]);
               translate([0,smoother_length*(a+1)/smother_steps,0])cube([smoother_thickness,delta,(paddles_height+base_thickness-fiber_diameter/2)/2*(1+cos(180*(a+1)/smother_steps))]);
            }
        }
    }
}









// ===================================================   FULL MODEL   ====================================================

// -----------------------------------------------------  PADDLES  -------------------------------------------------------

for(i = [1:num_of_paddles]){
    translate([(i-1)*(paddle_diameter+paddles_distance_mod)+(paddle_diameter+paddles_distance_mod)/2+base_end_width+holder_width/2,(paddle_thickness+paddle_cover_thickness+base_width)/2,R+paddles_height+base_thickness]) rotate([90,0,0]){
// PADDLE -----------------------------------------------------------------------------------------------------------------
        if(paddles) paddle();
// PADDLE COVER -----------------------------------------------------------------------------------------------------------
        if(paddle_cover) translate([0,0,paddle_thickness]) {
            // normal cover
            //paddle_cover(); 
            // set of special covers
            rotate(125)difference(){
                paddle_cover();
                if(i%2) translate([0,0,paddle_cover_thickness-1]) linear_extrude(height=1+delta) revolve_text(0.62*R,"QUATER-WAVE PLATE",0.75);
                else translate([0,0,paddle_cover_thickness-1]) linear_extrude(height=1+delta) revolve_text(0.6*R,"HALF-WAVE PLATE",0.75);
            }
        }
    }
}


// ----------------------------------------------------   HOLDERS    -----------------------------------------------------
if(holders) for(i =[0:num_of_paddles]){    
    
// HOLDER A1 
    if(i>0 && i < num_of_paddles) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2-holder_delta_axis,paddles_height+base_thickness]) rotate([90,0,0]) holderA1();
    
// HOLDER A2
    if(i>0 && i < num_of_paddles) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2+holder_delta_axis,paddles_height+base_thickness]) rotate(a = 180, v=[0,1,0]) rotate([-90,0,0]) holderA2();
    
    
// HOLDER B1 
    if(i == 0) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2-holder_delta_axis,paddles_height+base_thickness]) rotate([90,0,0]) holderB1();

// HOLDER B2
    if(i == 0) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2+holder_delta_axis,paddles_height+base_thickness]) rotate(a = 180, v=[0,1,0]) rotate([-90,0,0]) holderB2();    
    
    
// HOLDER C1 
    if(i == num_of_paddles) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2-holder_delta_axis,paddles_height+base_thickness]) rotate([90,0,0]) holderC1();

// HOLDER C2
    if(i == num_of_paddles) translate([i*(paddle_diameter+paddles_distance_mod)+base_end_width+holder_width/2,base_width/2+holder_delta_axis,paddles_height+base_thickness]) rotate(a = 180, v=[0,1,0]) rotate([-90,0,0]) holderC2();
}        


// -----------------------------------------------------    BASE    ------------------------------------------------------

if(base) base();

// --------------------------------------------------   BASE COVERS   ----------------------------------------------------

if(base_covers) translate([0,0,paddles_height+base_thickness]){
    base_end_cover(h=base_end_cover_height);
    translate([total_out_length,base_width,0]) rotate(180) base_end_cover(h=base_end_cover_height);
}


// --------------------------------------------------    SMOOTHERS    ----------------------------------------------------
if(smoothers){
    translate([0,base_width/2,0]) smoother();
    translate([total_out_length,base_width/2,0]) rotate(180) smoother();
}


// ==============================================    SPECIAL STL MODELS    ===============================================


/*difference(){
    paddle_cover();
    translate([0,0,paddle_cover_thickness-1]) linear_extrude(height=1+delta) revolve_text(0.6*R,"HALF-WAVE PLATE",0.75);
}
/*
difference(){
    paddle_cover();
    translate([0,0,paddle_cover_thickness-1]) linear_extrude(height=1+delta) revolve_text(0.6*R,"QUATER-WAVE PLATE",0.85);
}*/


/*
 union(){
    paddle();
    translate([-5-(paddles_distance_mod+paddle_diameter)/2,-10-R,0]) cube([10,20,0.3]);
    translate([-5+(paddles_distance_mod+paddle_diameter)/2,-10-R,0]) cube([10,20,0.3]);
    translate([-(paddle_diameter+paddles_distance_mod)/2,-R-0.25,0]) cube([paddle_diameter+paddles_distance,0.5,paddle_cylinder_diameter-paddle_thickness]);
}
*/
