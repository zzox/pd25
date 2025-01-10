#version 450

uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;
out vec4 FragColor;

uniform sampler2D mask;

void main() {
    // vec2 pos = vec2(texCoord.x, texCoord.y + (1.0 / 256.0));
    // vec4 nextexcolor = texture(mask, pos);
	vec4 texcolor = texture(tex, texCoord);
    vec4 maskcolor = texture(mask, texCoord);
	// texcolor.rgb *= color.a;
    // texcolor.bgr = texcolor.rgb;

    if (maskcolor.a == 0.0) {
        discard;
    }

    texcolor.rgb = texcolor.rgb * maskcolor.a;

    // if (posX < 17.0 && posY < 17.0) {
    //     texcolor.rgb = vec3(1.0, 0.0, 1.0);
    // }

    // if (nextexcolor.a == 1.0) {
    //     texcolor.rgb = vec3(0.66, 0.0, 0.66);
    // }

    FragColor = texcolor;
}
