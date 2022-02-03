/*
 * Originally by TypicalTinkerer, 2021.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

function flatten(as) = [for(a = as) each a];

function gen_v_loop_squares(range, offset) = let(nr = len(range), nc = len(range[0])) [for(col = [0:nc-1]) [col,(nr-1)*nc+col,(nr-1)*nc+(col+1)%nc,(col+1)%nc]];

function gen_surf_squares(range, offset) = let(nr = len(range), nc = len(range[0])) [for(row = [0:nr-2], col = [0:nc-1]) let(i=offset + row*nc) [i+col, i+(col+1)%nc, i+nc+(col+1)%nc, i+nc+col]];

function gen_squares(range, offset, closed) = closed ? 
    flatten([gen_surf_squares(range, offset), gen_v_loop_squares(range, offset)]) : 
    flatten([gen_surf_squares(range, offset)]);

function gen_surface(range, closed = false) = [[for(row=range) each row], gen_squares(range, 0, closed)];

function flip_lr_row(row) = [for(i=[len(row)-1:-1:0]) row[i]];
function flip_lr(surface) = [for(row = surface) flip_lr_row(row)];
function flip_ud(surface) = [for(i = [len(surface)-1:-1:0]) surface[i]];

function range(u0, du, un) = let(us=[for(u=[u0 : du: un]) u], ua=(un-u0)%du) ua == 0 ? us : concat(us, [un]);
   
function domain(u0, du, un, v0, dv, dn) = [for(u=range(u0, du, un)) [for(v=range(v0, dv, dn)) [u, v]]];

function first_row(surface) = surface[0];    
function last_row(surface) = surface[len(surface) - 1];

function sum(vertices, result=[0, 0, 0], i=0) = i<len(vertices) ? sum(vertices, result+vertices[i], i+1) : result;

function end_surface(def, first) = let(nr = len(def), nc = len(def[0]), row = first ? 0 : nr-1) [first ? [for(col = [nc-1:-1:0]) let(i=row*nc+col) i] : [for(col = [0:nc-1]) let(i=(nr-1)*nc+col) i]];

function gen_capped_surface(def) = let(surf=gen_surface(def)) [surf[0], concat(surf[1], end_surface(def, true), end_surface(def, false))];

module solid(def) {
    polyhedron(def[0], def[1], 10);
}