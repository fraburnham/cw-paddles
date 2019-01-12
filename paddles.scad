cylinder_resolution = 60;
hole_padding = 1;

module lever(lever_dimensions) {
     cube(lever_dimensions);
}

module handle(lever_dimensions) {
     cylinder(
          r=lever_dimensions[1]*2,
          h=lever_dimensions[2],
          $fn=3
          );
}

module post(bearing_dimensions) {
     rotate([90, 0, 0]) {
          cylinder(
               h=bearing_dimensions[2] + hole_padding,
               d=bearing_dimensions[1],
               $fn=cylinder_resolution
               );
     }
}

module magnet_hole(magnet_dimensions) {
     cylinder(
          d=magnet_dimensions[0],
          h=magnet_dimensions[1] + hole_padding,
          $fn=cylinder_resolution
          );
}

function extend_hole(d) = [d[0], d[1], d[2]+1];

module contact_hole(contact_dimensions) {
     cube(extend_hole(contact_dimensions), center=true);
}

function post_translation_vector(ld) = [ld[0]*0.4, -((ld[1]/2)-hole_padding), ld[2]/2];
function lever_translation_vector(ld) = [ld[1], -ld[1]/2, 0];

module handle_lever_post_union(lever_dimensions, bearing_dimensions) {
     union() {
          handle(lever_dimensions);
          translate(lever_translation_vector(lever_dimensions)) lever(lever_dimensions);
          translate(post_translation_vector(lever_dimensions)) post(bearing_dimensions);
     }
}

function contact_hole_translation_vector(ld, cd) = [(ld[0]-1)+(cd[0]/2), 0, hole_padding];
function magnet_hole_translation_vector(ld) = [(ld[0]/4), 0, hole_padding];

module holes_union(lever_dimensions, magnet_dimensions, contact_dimensions) {
     union() {
          translate(magnet_hole_translation_vector(lever_dimensions)) magnet_hole(magnet_dimensions);
          translate(contact_hole_translation_vector(lever_dimensions, contact_dimensions)) contact_hole(contact_dimensions);
     }
}

// lever_dimensions = [length, width, height]
// bearing_dimensions = [outer_diameter, inner_diameter, height]
// magnet_dimensions = [diameter, height] (square magnets not yet supported)
// contact_dimensions = [l, w, h]
module paddle(
     lever_dimensions=[50, 5, 5],
     bearing_dimensions=[0, 5, 5],
     magnet_dimensions=[4, 3],
     contact_dimensions=[5, 4, 3]
     ) {
     difference() {
          handle_lever_post_union(
               lever_dimensions=lever_dimensions,
               bearing_dimensions=bearing_dimensions
               );
          holes_union(
               lever_dimensions=lever_dimensions,
               magnet_dimensions=magnet_dimensions,
               contact_dimensions=contact_dimensions
               );
     }
}

// need to see how to raise exceptions and fail when the values don't allow for all things to be placed properly

render() {  // remove me soon, just for testing
     paddle();
}
