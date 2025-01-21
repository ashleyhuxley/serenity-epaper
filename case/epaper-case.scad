include <modules.scad>
$fn = 30;

panelWidth = 57 + 1;
panelLength = 150 + 1;
panelThickness = 2;

displayWidth = 50;
displayLength = 141;

internalWidth = 50;
internalLength = 140;
bottomThickness = 1;

boxLength = 170;
boxWidth = 67;
boxHeight = bottomThickness + 14;  // Min 12 to account for screws

fireBeetleWidth = 26 + 1;
fireBeetleLength = 60 + 1;
fireBeetleHeight = 8;

bevelWidthX = (panelWidth - displayWidth) / 2;
bevelWidthY = (panelLength - displayLength) / 2;

holeDia = 4;
fixingDia = 4;
holeOffset = 5;

cableDia = 6;

lid_thickness = 1.4;

//box();

//translate([0, 0, 22])
{
    lid();
}

module box()
{
    difference()
    {
        translate([boxWidth / 2, boxLength / 2, 0])
        {
            rounded_rect(boxLength, boxWidth, boxHeight, 5);
        }
        
        // Box Cutout
        translate([(boxWidth - internalWidth) / 2, (boxLength - internalLength) / 2, bottomThickness])
        {
            cube([internalWidth, internalLength, boxHeight]);
        }
        
        // Panel Cutout
        translate([(boxWidth - panelWidth) / 2, (boxLength - panelLength) / 2, boxHeight - panelThickness])
        {
            cube([panelWidth, panelLength, panelThickness + 0.1]);
        }
        
        // Fixing Holes
        translate([boxWidth / 2, boxLength / 2, 0])
        {
            quads(boxLength - holeDia - holeOffset, boxWidth - fixingDia - holeOffset)
            {
                cylinder(h = boxHeight + 1, d = fixingDia);
            }
        }
        
        // Cable hole
        translate([boxWidth / 2, 0, cableDia / 2])
        {
            rotate([-90, 0, 0])
            {
                cylinder(d = cableDia, h = 20);
            }
        }
        translate([(boxWidth / 2) - cableDia / 2, 0, 0])
        {
            cube([cableDia, 20, cableDia / 2]);
        }
        translate([(boxWidth / 2) - 7.5, (boxLength - internalLength) / 2, 0])
        {
            cube([15, 10, bottomThickness+2]);
        }
        
        // Ribbon cable space
        ribbonWidth = 40;
        translate([(boxWidth / 2) - (ribbonWidth / 2), ((boxLength - internalLength) / 2) + internalLength, bottomThickness])
        {
            cube([ribbonWidth, 10, boxHeight]);
        }
    }
    
    translate([boxWidth / 2, 70, bottomThickness])
    {
        translate([-(fireBeetleWidth / 2), -(fireBeetleLength / 2), 0])
        {
            rotate([0, 0, 0])
            {
                corner(5, 3, 1);
            }
        }
        
        translate([(fireBeetleWidth / 2), -(fireBeetleLength / 2), 0])
        {
            rotate([0, 0, 90])
            {
                corner(5, 3, 1);
            }
        }
        
        translate([-(fireBeetleWidth / 2), (fireBeetleLength / 2), 0])
        {
            rotate([0, 0, -90])
            {
                corner(5, 3, 1);
            }
        }
        
        translate([(fireBeetleWidth / 2), (fireBeetleLength / 2), 0])
        {
            rotate([0, 0, 180])
            {
                corner(5, 3, 1);
            }
        }
    }
}

module lid()
{
    difference()
    {
        translate([boxWidth / 2, boxLength / 2, 0])
        {
            rounded_rect(boxLength, boxWidth, lid_thickness, 5);
        }
    
        translate([(boxWidth - displayWidth) / 2, ((boxLength - panelLength) / 2) + 1, -0.1])
        {
            translate([0,0,0.5])
            {
                trapezoid(displayWidth, displayLength, displayWidth + 6, displayLength + 6, lid_thickness + 0.2);
            }
            
            cube([displayWidth, displayLength, lid_thickness]);
        }
        
        translate([boxWidth / 2, boxLength / 2, 0])
        {
            quads(boxLength - holeDia - holeOffset, boxWidth - holeDia - holeOffset)
            {
                cylinder(h = boxHeight + 1, d = holeDia);
            }
        }
    }
}

module trapezoid(bw, bl, tw, tl, h)
{
    tl_diff = (bl - tl) / 2;
    tw_diff = (bw - tw) / 2;
    
    points = [
        [  0,  0,  0 ],  //0
        [ bw,  0,  0 ],  //1
        [ bw,  bl,  0 ],  //2
        [  0,  bl,  0 ],  //3
        [  tw_diff,  tl_diff,  h ],  //4
        [ tw_diff + tw,  tl_diff,  h ],  //5
        [ tw_diff + tw,  tl_diff + tl,  h ],  //6
        [  tw_diff,  tl_diff + tl,  h ]]; //7
      
    faces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]]; // left
      
    polyhedron(points, faces);
}

module corner(size, height, width)
{
    difference()
    {
        translate([-width, -width, 0])
        {
            cube([size, size, height]);
        }
       
        cube([size - width, size - width, height]); 
    }
}