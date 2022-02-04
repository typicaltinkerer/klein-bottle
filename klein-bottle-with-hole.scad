/*
 * Originally by TypicalTinkerer, 2021.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
use <klein-bottle-functions.scad>;
use <solid.scad>;

module bottle_top(w, a, b, c, du, dv) {
    dom1 = domain(0, du, 180, 0, dv, 360);
    inner_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v, a, b, c) - (w/2)*nklein1(u, v, a, b, c)]];    
    outer_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v, a, b, c) + (w/2)*nklein1(u, v, a, b, c)]];

    dom3 = domain(270, du, 360, 0, dv, 360);
    inner_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v, a, b, c) - (w/2)*nklein2(u, v, a, b, c)]];    
    outer_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v, a, b, c) + (w/2)*nklein2(u, v, a, b, c)]];

    range_1_3 = concat(flip_lr(inner_range3), flip_lr(inner_range1), flip_ud(flip_lr(outer_range1)), flip_ud(flip_lr(outer_range3)));
    surface_1_3 = gen_surface(range_1_3, true);
    solid(surface_1_3);
}

module bottle_bottom(w, a, b, c, du, dv) {
    dom2 = domain(180, du, 270, 0, dv, 360);
    inner_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v, a, b, c) + (w/2)*nklein2(u, v, a, b, c)]];    
    outer_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v, a, b, c) - (w/2)*nklein2(u, v, a, b, c)]];

    range_2 = concat(inner_range2, flip_ud(outer_range2));
    surface_2 = gen_surface(range_2, true);   

    // substract plug to create hole
    difference() {
        solid(surface_2);
        bottom_plug(w, a, b, c, du, dv, 320, 360);
    }
}

module bottom_plug(w, a, b, c, du, dv, start, end) {
    // create solid for creating hole
    dom4 = domain(start, du, end, 0, dv, 360);
    inner_range4 = [for(row=dom4) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v, a, b, c) - (w/2)*nklein2(u, v, a, b, c)]]; 
    plug_surface = gen_capped_surface(inner_range4);
     solid(plug_surface);
}
    
w = 0.42; // wall
a = 10; // width
b = 50; // height
c = 10; // weight
du = 5;
dv = 5;

bottle_top(w, a, b, c, du, dv);
bottle_bottom(w, a, b, c, du, dv);