#version 450

uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;
out vec4 FragColor;

uniform sampler2D mask;

vec4 colors[32];
float minDist = 3.;
vec4 selected;

void main() {
    /*--------------------- MASK SECTION ---------------------*/
	vec4 texcolor = texture(tex, texCoord);
    vec4 maskcolor = texture(mask, texCoord);

    if (maskcolor.a == 0.0) {
        discard;
    }

    texcolor.rgb = texcolor.rgb * maskcolor.a;

    /*------------------- PALETTE SECTION -------------------*/
    colors[0] = vec4(0. / 255., 0. / 255., 0. / 255., 1.);
    colors[1] = vec4(34. / 255., 32. / 255., 52. / 255., 1.);
    colors[2] = vec4(50. / 255., 60. / 255., 57. / 255., 1.);
    colors[3] = vec4(69. / 255., 40. / 255., 60. / 255., 1.);
    colors[4] = vec4(82. / 255., 75. / 255., 36. / 255., 1.);
    colors[5] = vec4(102. / 255., 57. / 255., 49. / 255., 1.);
    colors[6] = vec4(75. / 255., 105. / 255., 47. / 255., 1.);
    colors[7] = vec4(63. / 255., 63. / 255., 116. / 255., 1.);
    colors[8] = vec4(89. / 255., 86. / 255., 82. / 255., 1.);
    colors[9] = vec4(172. / 255., 50. / 255., 50. / 255., 1.);
    colors[10] = vec4(48. / 255., 96. / 255., 130. / 255., 1.);
    colors[11] = vec4(143. / 255., 86. / 255., 59. / 255., 1.);
    colors[12] = vec4(138. / 255., 111. / 255., 48. / 255., 1.);
    colors[13] = vec4(55. / 255., 148. / 255., 110. / 255., 1.);
    colors[14] = vec4(105. / 255., 106. / 255., 106. / 255., 1.);
    colors[15] = vec4(118. / 255., 66. / 255., 138. / 255., 1.);
    colors[16] = vec4(106. / 255., 190. / 255., 48. / 255., 1.);
    colors[17] = vec4(143. / 255., 151. / 255., 74. / 255., 1.);
    colors[18] = vec4(223. / 255., 113. / 255., 38. / 255., 1.);
    colors[19] = vec4(132. / 255., 126. / 255., 135. / 255., 1.);
    colors[20] = vec4(217. / 255., 87. / 255., 99. / 255., 1.);
    colors[21] = vec4(91. / 255., 110. / 255., 225. / 255., 1.);
    colors[22] = vec4(153. / 255., 229. / 255., 80. / 255., 1.);
    colors[23] = vec4(217. / 255., 160. / 255., 102. / 255., 1.);
    colors[24] = vec4(99. / 255., 155. / 255., 255. / 255., 1.);
    colors[25] = vec4(155. / 255., 173. / 255., 183. / 255., 1.);
    colors[26] = vec4(215. / 255., 123. / 255., 186. / 255., 1.);
    colors[27] = vec4(95. / 255., 205. / 255., 228. / 255., 1.);
    colors[28] = vec4(251. / 255., 242. / 255., 54. / 255., 1.);
    colors[29] = vec4(238. / 255., 195. / 255., 154. / 255., 1.);
    colors[30] = vec4(203. / 255., 219. / 255., 252. / 255., 1.);
    colors[31] = vec4(255. / 255., 255. / 255., 255. / 255., 1.);
    for (int i = 0; i < 32; i++) {
        float dist = pow(abs(texcolor.r - colors[i].r), 2.) + pow(abs(texcolor.g - colors[i].g), 2.) + pow(abs(texcolor.b - colors[i].b), 2.);
        if (dist < minDist) {
            minDist = dist;
            selected = colors[i];
        }
    }

    /*------------------------ OUTPUT ------------------------*/
    FragColor = selected;
}
