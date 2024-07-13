#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform float u_noisePercent;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

float random(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = v_texCoord;
    vec4 color = texture2D(u_texture, uv);
    
    // Noise
    float noise = random(uv + u_time);
    color.rgb += noise * (u_noisePercent / 100.0);

    // Color distortion
    float offset = 0.02 * noise;
    vec4 red = texture2D(u_texture, vec2(uv.x + offset, uv.y));
    vec4 green = texture2D(u_texture, uv);
    vec4 blue = texture2D(u_texture, vec2(uv.x - offset, uv.y));
    color = vec4(red.r, green.g, blue.b, 1.0);
    
    gl_FragColor = color;
}
