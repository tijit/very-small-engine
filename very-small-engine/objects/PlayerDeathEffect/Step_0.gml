if (--timer <= 0) {
}
else {
	repeat(particlesPerFrame) {
		instance_create_depth(x, y, depth, BloodParticle);
	}
}
