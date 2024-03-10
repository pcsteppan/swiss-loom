float xPartition = 0.92;
float yPartition = 0.92;

vec4 black = vec4(0., 0., 0., 1.);
vec4 gray = vec4(.88);

if(UV.x < xPartition && UV.y > yPartition) {
// THREADING
	vec2 tuv = vec2(UV.x, UV.y - yPartition);
	vec2 luv = vec2(tuv.x / xPartition, tuv.y * (1. / (1. - yPartition)));
	float v = step(abs(luv.y - th(luv.x)), .1);
	v = dit(I, v);
	FOut = mix(gray, black, v);
} else if(UV.x > xPartition && UV.y < yPartition) {
// TREADLING
	vec2 tuv = vec2(UV.x - xPartition, UV.y);
	vec2 luv = vec2(tuv.x * (1. / (1. - xPartition)), tuv.y / yPartition);
	float v = step(abs(tr(luv.y) - luv.x), .1);
	v = dit(I, v);
	FOut = mix(gray, black, v);
} else if(UV.x > xPartition && UV.y > yPartition) {
// TIEUP
	vec2 tuv = vec2(UV.x - xPartition, UV.y - yPartition);
	vec2 luv = vec2(tuv.x * (1. / (1. - xPartition)), tuv.y * (1. / (1. - yPartition)));
	float v = tie(luv);

	// slight vibration/scanline/refresh effect
	v += hash(
			ivec3(
				I, 
				(time/10. * float(I.y)/120.) * 6.
			)
		).r * .18;
	
	v = dit(I, v);
	FOut = vec4((1. - v) * gray);
} else {
// TEXTILE
	vec2 tuv = vec2(UV.x, UV.y / yPartition);
	vec2 luv = vec2(tuv.x / xPartition, tuv.y);

	float th = th(luv.x);
	float tr = tr(luv.y);
	float v = tie(vec2(th, tr));

	vec4 o = dit(I, v) * gray;
	FOut = vec4(o);
}