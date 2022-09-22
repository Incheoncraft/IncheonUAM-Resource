#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float shadow;

void main() {
    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 0.5), vec2(0.5), vec2(0.5, 0));
    
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = UV0;
    shadow = 0;
	
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

    vec3 Pos = Position;

    
    float lum = max(Color.r, max(Color.g, Color.b));

    if (Pos.z == 0 && ProjMat[3][0] == -1 && lum > 0.4 && !(Color.r == 1.0 && Color.g == 1.0 && Color.b == 1.0))
    {
        vec2 corner = corners[gl_VertexID % 4];
        Pos.xy += corner;
        texCoord0 += corner / textureSize(Sampler0, 0);
        shadow = 1;
    }


    vec3 shadowColor = vec3(0.248, 0.248, 0.248);
    if(Position.z == 0.0) {
        // shadow remover - action bar, title, bossbar.. etc
        
        if((Position.y >= ScrSize.y - 64 || Position.y <= 64) && lessThan(vertexColor.rgb, shadowColor) == bvec3(true)) {
            Pos.x += ScrSize.x * 100;
        }
        else 
        {
        
            gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
            if(gl_Position.x >= 0.95 && gl_Position.y >= -0.35 && gl_VertexID <= 7 && vertexColor.b == 84.0/255.0 && vertexColor.g == 84.0/255.0 && vertexColor.r == 252.0/255.0) {
                Pos.x += ScrSize.x;
            }
            /*
            else if(Color.r == 254.0/255.0) {
                vertexColor = vec4(1.0, 1.0, 1.0, 1.0) * texelFetch(Sampler2, UV2 / 16, 0);
                Pos.x -= ceil(ScrSize.x);
                Pos.y += ceil(ScrSize.y / 2);
                if(Color.g == 254.0/255.0) {
                    Pos.y += 24;
                } else if(Color.g == 253.0/255.0) {
                    vertexColor = vec4(128.0/255.0, 200.0/255.0, 255.0/255.0, 1.0) * texelFetch(Sampler2, UV2 / 16, 0);
                    Pos.y += 24;
                }
                gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
            } 
            else if(Color.r == 253.0/255.0) {
                vertexColor = vec4(1.0, 1.0, 1.0, 1.0) * texelFetch(Sampler2, UV2 / 16, 0);
                Pos.x -= ceil(ScrSize.x / 2);
                Pos.y += ceil(ScrSize.y / 2);
                gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
            } 
            else if(Color.r == 252.0/255.0) {
                vertexColor = vec4(1.0, 1.0, 1.0, 1.0) * texelFetch(Sampler2, UV2 / 16, 0);
                Pos.x -= ceil(ScrSize.x / 2);
                gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
            }
            */
        }
        /* // experience
        vec3 isXpGreen = abs(Color.rgb - vec3(0x7e, 0xfc, 0x20) / 255);
        if(Position.y >= ScrSize.y - 36 && Position.y <= ScrSize.y - 25 && (Color.rgb == vec3(0, 0, 0) || (isXpGreen.r < 0.1 && isXpGreen.r < 0.1 && isXpGreen.r < 0.1))) {
            Pos.x += ScrSize.x;
        }
        */
    }
    /* // etc
     else if(Position.z == 100.0) {
        Pos.x += ScrSize.x;
    }
     else if(Position.z == 400.0) {
        Pos.x += ScrSize.x;
	}
     else if(Position.z == 0.03) {

     
    }
    */

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
