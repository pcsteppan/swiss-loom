float xPartition = 0.92;
float yPartition = 0.92;

vec4 blue = vec4(0., 0., 1., 1.);
vec4 gray = vec4(.7);

if(UV.x < xPartition && UV.y > yPartition) {
// THREADING
	vec2 tuv = vec2(UV.x, UV.y - yPartition);
	vec2 luv = vec2(tuv.x / xPartition, tuv.y * (1. / (1. - yPartition)));
	float v = step(abs(luv.y - th(luv.x)), .1);
	v = dit(I, v);
	FOut = mix(gray, blue, v);
} else if(UV.x > xPartition && UV.y < yPartition) {
// TREADLING
	vec2 tuv = vec2(UV.x - xPartition, UV.y);
	vec2 luv = vec2(tuv.x * (1. / (1. - xPartition)), tuv.y / yPartition);
	float v = step(abs(tr(luv.y) - luv.x), .1);
	v = dit(I, v);
	FOut = mix(gray, blue, v);
} else if(UV.x > xPartition && UV.y > yPartition) {
// TIEUP
	vec2 tuv = vec2(UV.x - xPartition, UV.y - yPartition);
	vec2 luv = vec2(tuv.x * (1. / (1. - xPartition)), tuv.y * (1. / (1. - yPartition)));
	float v = tie(luv);
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