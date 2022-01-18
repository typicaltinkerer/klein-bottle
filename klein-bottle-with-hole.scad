/*
 * Originally by TypicalTinkerer, 2021.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
include <klein-bottle-functions.scad>;
include <solid.scad>;

du = 20;
dv = 20;

un1 = 180;
vn1 = 360;
dom1 = domain(0, du, un1, 0, dv, vn1);

inner_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v) - (w/2)*nklein1(u, v)]];    
outer_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v) + (w/2)*nklein1(u, v)]];
    
un2 = 270;
dom2 = domain(un1, du, un2, 0, dv, vn1);

inner_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) + (w/2)*nklein2(u, v)]];    
outer_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];

un3 = 360;
dom3 = domain(un2, du, un3, 0, dv, vn1);

inner_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];    
outer_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) + (w/2)*nklein2(u, v)]];

range_1_3 = concat(flip_lr(inner_range3), flip_lr(inner_range1), flip_ud(flip_lr(outer_range1)), flip_ud(flip_lr(outer_range3)));
surface_1_3 = gen_surface(range_1_3, true);
module bottle_1_3() solid(surface_1_3);

range_2 = concat(inner_range2, flip_ud(outer_range2));
surface_2 = gen_surface(range_2, true);
module bottle_2() solid(surface_2);

// create solid for creating hole
dom4 = domain(320, du, 360, 0, dv, vn1);
inner_range4 = [for(row=dom4) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]]; 
plug_surface = gen_capped_surface(inner_range4);
module hole() solid(plug_surface);

// the bottle consists of the following two parts, which look fine in the preview, but cannot be 
// rendered at the same time.
bottle_1_3();
difference() { bottle_2(); hole();}