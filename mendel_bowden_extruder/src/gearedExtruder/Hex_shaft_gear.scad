<D_shaft.scad>
<simplified_gear.scad>

render() difference()
{
	gear(number_of_teeth=39,diametric_pitch=2);
	circle($fn = 6, r=7/2);
}