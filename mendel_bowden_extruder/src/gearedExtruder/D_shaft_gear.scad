<D_shaft.scad>
<simplified_gear.scad>

render() difference()
{
	gear(number_of_teeth=11,diametric_pitch=2);
	d_shaft();
}
