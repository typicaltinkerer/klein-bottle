/*
 * Originally by TypicalTinkerer, 2021.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
include <klein-bottle-functions.scad>;
include <solid.scad>;

w = 0.7; // wall

du = 20;
dv = 20;

un1 = 180;
vn1 = 360;
dom1 = domain(0, du, un1, 0, dv, vn1);

inner_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v) - (w/2)*nklein1(u, v)]];    
outer_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]+180) klein1(u, v) + (w/2)*nklein1(u, v)]];
    
un2 = 270;
dom2 = domain(un1, du, un2, 0, dv, vn1);

inner_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]+180) klein2(u, v) + (w/2)*nklein2(u, v)]];    
outer_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];

un3 = 360;
dom3 = domain(un2, du, un3, 0, dv, vn1);

inner_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];    
outer_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]+180) klein2(u, v) + (w/2)*nklein2(u, v)]];

range = concat(flip_lr(inner_range3), flip_lr(inner_range1), inner_range2, outer_range3, outer_range1, flip_lr(outer_range2));
surface = gen_surface(range, true);
module bottle() solid(surface);

bottle();