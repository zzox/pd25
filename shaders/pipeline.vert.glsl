#version 450

in vec3 vertexPosition;
in vec2 vertexUV;
in vec4 vertexColor;
uniform mat4 projectionMatrix;
uniform float uTime;
out vec2 texCoord;
out vec4 color;
out float time;

void main() {
	gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);
	texCoord = vertexUV;
    time = uTime;
	color = vertexColor;
}