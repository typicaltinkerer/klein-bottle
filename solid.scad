function flatten_surfaces(surfaces) = concat([for(surface = surfaces) for(row=surface) each row]);

function gen_faces(surface, offset) = let(nr = len(surface), nc = len(surface[0])) [for(row = [0:nr-2], col = [0:nc-2]) let(i=offset + row*nc+col) [i, i+1, i+nc+1, i+nc]];

function tail(l) = [if (len(l)==1) [] else for(i = [1:len(l)-1]) l[i]];

function concat_faces(surfaces, offset = 0) = len(surfaces[0]) == 0 ? [] : let(surface = surfaces[0])
    concat(gen_faces(surface, offset), concat_faces(tail(surfaces), offset + len(surface)*len(surface[0])));

function reorder(surface) = [for(row = surface) [for(i=[len(row)-1:-1:0]) row[i]]];
    
module solid(surfaces) {
    points = flatten_surfaces(surfaces);
    faces = concat_faces(surfaces);
    polyhedron(points, faces);
}


function range(u0, du, un) = let(us=[for(u=[u0 : du: un]) u], ua=(un-u0)%du) ua == 0 ? us : concat(us, [un]);
   
function domain(u0, du, un, v0, dv, dn) = [for(u=range(u0, du, un)) [for(v=range(v0, dv, dn)) [u, v]]];

function first_row(surface) = surface[0];    
function last_row(surface) = surface[len(surface) - 1];