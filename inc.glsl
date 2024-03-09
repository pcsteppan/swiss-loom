float quantize(float x, float q) {
	return floor(x / q) * q;
}

float repeat(float x, float repeatBy) {
	return mod(x * repeatBy, 1.);
}

// dithering
float dit(ivec2 st, float v) {
	ivec2 iuv = ivec2(st.x % 4, st.y % 4);
	float d = _sample(dither, iuv).r;
	return step(v + 0.0001, d);
}

// threading
float th(float x) {
	x = repeat(x, 4.);
	x = quantize(x, 1. / 46.);

	// quadratic
	float r = 2.;
	float a = r * x - r / 2.;
	float v = (a * a) + .5;

	// modify time
	// more in the center
	// less on the edges
	float ab = 1. - abs(x - .5);
	float stime = sin(time) * 4.2 + 12.4;
	float m = sin(stime * ab);

	float xa = v * m;

	return mod(xa, 1.);
}

// treadling
float tr(float y) {
	return 1. - th(y);
}

// tieup
float tie(vec2 uv) {
	return 1. - texture(tieup, uv).r * 255.;
}



