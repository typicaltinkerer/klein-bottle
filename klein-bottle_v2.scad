/*
 * Parametrization giving the classic form in R3 (hence with self-intersection):
 * https://mathcurve.com/surfaces.gb/klein/klein.shtml
 *
 * Originally by TypicalTinkerer, 2021.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
include <solid.scad>;

a = 8; // width
b = 30; // height
c = 8; // weight
w = 0.7; // wall

du = 5;
dv = 20;

alpha = 1;

function unit_normal(v) = v / norm(v);
function normal(a, b) = let(c = cross(a, b)) unit_normal(c);

// helper function
function r(u) = c*(1 - cos(u)/2);

// first part
function klein1(u, v) = let(ru=r(u)) [
    (a*(1 + sin(u)) + ru*cos(v))*cos(u),
    (b + ru*cos(v))*sin(u),
    ru*sin(v)
];

// dklein1/du
function dklein1_du(u, v) =
[
    c*sin(u)*(cos(u) - 1)*cos(v) - a*(2*sin(u)^2 + sin(u) - 1),
    (2*b*cos(u) + c*cos(v)*(2*sin(u)^2 + 2*cos(u) - 1))/2,
    (c*cos(u - v) - c*cos(u + v))/4
];

// dklein1/dv
function dklein1_dv(u, v) =
[
    c*(cos(u) - 2)*cos(u)*sin(v)/2,
    c*sin(u)*(cos(u) - 2)*sin(v)/2,
    -c*(cos(u) - 2)*cos(v)/2
];

function nklein1(u, v) = normal(dklein1_du(u, v), dklein1_dv(u, v));

un1 = 180;
vn1 = 360;
dom1 = domain(0, du, un1, 0, dv, vn1);

inner_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v) - (w/2)*nklein1(u, v)]];    
outer_range1 = [for(row=dom1) [for(uv=row) let(u=uv[0], v=uv[1]) klein1(u, v) + (w/2)*nklein1(u, v)]];
    
// second part
function klein2(u, v) = let(ru=r(u)) [
    a*(1 + sin(u))*cos(u) + ru*cos(v),
    b*sin(u),
    ru*sin(v)
];

// dklein2/du
function dklein2_du(u, v) =
[
    a*(-2*sin(u)^2 - sin(u) + 1) + c*sin(u)*cos(v)/2,
    b*cos(u),
    (c*cos(u - v) - c*cos(u + v))/4
];

// dklein2/dv
function dklein2_dv(u, v) =
[
    c*(cos(u)/2 - 1)*sin(v),
    0,
    -c*(cos(u)/2 - 1)*cos(v)
];

function nklein2(u, v) = normal(dklein2_du(u, v), dklein2_dv(u, v));

un2 = 270;
dom2 = domain(un1, du, un2, 0, dv, vn1);

inner_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) + (w/2)*nklein2(u, v)]];    
outer_range2 = [for(row=dom2) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];

un3 = 360;
dom3 = domain(un2, du, un3, 0, dv, vn1);

inner_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) - (w/2)*nklein2(u, v)]];    
outer_range3 = [for(row=dom3) [for(uv=row) let(u=uv[0], v=uv[1]) klein2(u, v) + (w/2)*nklein2(u, v)]];

surface = gen_surface([reorder_rows(inner_range1), outer_range1, inner_range2, reorder_rows(outer_range2), reorder_rows(inner_range3), outer_range3]);
module bottle() solid([surface]);
color("yellow", alpha) bottle();

// attempt to create a hole, but doesn't work as expected...
plug_outer_surface = gen_surface([inner_range3]);
plug_end_surface_1 = minimal_surface(reorder_row(first_row(inner_range3)));
plug_end_surface_2 = minimal_surface(last_row(inner_range3));
module plug() solid([plug_outer_surface, plug_end_surface_1, plug_end_surface_2]);
//color("yellow", alpha) plug();
//color("yellow", alpha) difference() { bottle(); plug(); }
