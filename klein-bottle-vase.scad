/*
 * Originally by TypicalTinkerer, 2022.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

use <klein-bottle-functions.scad>;
use <klein-bottle-with-hole.scad>
use <solid.scad>;

w = 0.42; // wall
a = 10; // width
b = 50; // height
c = 10; // weight
du = 5;
dv = 5;

module place() { translate([0, 0, b + c]) rotate([-90, 0, 0]) children(); }

// draw the bottle
place() {
    // the bottle consists of the following two parts, which look fine in the
    // preview, but cannot be rendered at the same time.
    bottle_top(w, a, b, c, du, dv);
    bottle_bottom(w, a, b, c, du, dv);
}

// create solid to take away from cylindrical base
dom1 = domain(0, du, 180, 0, dv, 360);
outer_range1 = [
    for(row=dom1) [
        for(uv=row) let(u=uv[0], v=uv[1]) 
            klein1(u, v, a, b, c) + (w/2)*nklein1(u, v, a, b, c)
    ]
];
solid_surface_1 = gen_capped_surface(outer_range1);

// draw the base
difference() {
    translate([-4,0,0]) cylinder(h=3, d=35, $fn=128); // base
    place() solid(solid_surface_1); // take away
}