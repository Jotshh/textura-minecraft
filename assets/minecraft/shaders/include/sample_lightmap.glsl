vec4 sample_lightmap(sampler2D lightMap, ivec2 uv) {
	float blockLight = uv.x / 16.0;
	float skyLight = uv.y / 16.0;
	
	vec4 pureSkyLight = texture(lightMap, clamp(vec2(0.0, 240.0) / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0))); // Gets the color of pure skylight.
	float dayness = 1.0 - (smoothstep(7.0, 15.0, skyLight) * smoothstep(0.164, 0.976, pureSkyLight.r));
	
	float brightnessModifier = ((blockLight * dayness) + 32.0) / 32.0; // Lighter light levels are made brighter because it looks pretty.
	vec3 warmTint = vec3(0.15, 0.04, -0.15) * dayness; // The default warm tint of light.
	vec3 lightModifier = vec3(brightnessModifier) + (warmTint * smoothstep(0.0, 7.0, blockLight)); // Combine the brightness modifier and the warm tint to get the nice glow effect!
	
	vec4 defaultLightColor = texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0))); // Gets what the light color would be in vanilla.
	
	if (blockLight > 0.0) return defaultLightColor * vec4(lightModifier, 1.0); // If there is enough block light, add the light modifier.
	else return defaultLightColor; // If there is no block light, return default.
}
