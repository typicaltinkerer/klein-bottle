function flatten_surfaces(surfaces) = concat([for(surface = surfaces) for(row=surface) each row]);

function gen_squares(surface, offset) = let(nr = len(surface), nc = len(surface[0])) [for(row = [0:nr-2], col = [0:nc-2]) let(i=offset + row*nc+col) [i, i+1, i+nc+1, i+nc]];

function concat_squares(surfaces, index = 0, offset = 0) = index == len(surfaces) ? [] : let(surface = surfaces[index]) concat(gen_squares(surface, offset), concat_squares(surfaces, index + 1, offset + len(surface)*len(surface[0])));

function gen_surface(surfaces) = [
    flatten_surfaces(surfaces),
    concat_squares(surfaces)
];

function reorder_row(row) = [for(i=[len(row)-1:-1:0]) row[i]];
function reorder_rows(surface) = [for(row = surface) reorder_row(row)];

function range(u0, du, un) = let(us=[for(u=[u0 : du: un]) u], ua=(un-u0)%du) ua == 0 ? us : concat(us, [un]);
   
function domain(u0, du, un, v0, dv, dn) = [for(u=range(u0, du, un)) [for(v=range(v0, dv, dn)) [u, v]]];

function first_row(surface) = surface[0];    
function last_row(surface) = surface[len(surface) - 1];

function sum(vertices, result=[0, 0, 0], i=0) = i<len(vertices) ? sum(vertices, result+vertices[i], i+1) : result;

function minimal_surface(p) = let(
    n = len(p),
    s = 2, // number of layers
    m = n*(2*s - 1),
    pc = sum(p) / n) [
        concat(p, [for(j = [1:s], i = [0:n-1]) p[i] + j*(pc-p[i])/(s+1)], [pc]),
        concat(
            [for(j = [0:s-1], i = [0:n-2]) [j*n+i,j*n+i+1,(j+1)*n+i]],
            [for(j = [0:s-1], i = [0:n-2]) [j*n+i+1 ,(j+1)*n+i+1, (j+1)*n+i]],
            [for(i = [0:n-2]) [s*n, s*n+i, s*n+i+1]])
    ];
            
module minimal_surface(p) {
    polygons = minimal_surface(p);
    def2polyhedron(polygons);
}

function shift(faces, offset) = [for(face = faces) [for(e = face) e + offset]];

function concat_surface_defs(defs, index = 0, offset = 0) = index == len(defs) ? [[],[]] : 
    let(next_def = concat_surface_defs(defs, index + 1, offset + len(defs[index][0])),
        points = concat(defs[index][0], next_def[0]),
        faces = concat(shift(defs[index][1], offset), next_def[1])) [ points, faces];
    
module solid(defs) {
    def = concat_surface_defs(defs);
    polyhedron(def[0], def[1]);
}