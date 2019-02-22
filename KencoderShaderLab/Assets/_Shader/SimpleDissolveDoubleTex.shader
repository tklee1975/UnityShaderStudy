Shader "Kencoder Shader/Simple Dissolve DoubleTex" {
    Properties {
        _MainTex ("Primary (RGB)", 2D) = "white" {}
		_SecondTex ("Secondary (RGB)", 2D) = "white" {}
        _Range("_Range", Range(0, 1)) = 0 
    }
 
    SubShader{
            Tags { "RenderType" = "Transparent" }
            LOD 200            
        
CGPROGRAM
#pragma surface surf Standard fullforwardshadows
        
float3 _Position; // from script

sampler2D _MainTex, _SecondTex;
float _Range;


struct Input {
    float2 uv_MainTex : TEXCOORD0;
    float3 worldPos;// built in value to use the world space position
    float3 worldNormal; // built in value for world normal

};
    
void surf (Input IN, inout SurfaceOutputStandard o) {
    half4 c = tex2D(_MainTex, IN.uv_MainTex);          // first texture
    half4 c2 = tex2D(_SecondTex, IN.uv_MainTex);       // second texture

    // float diff = 
    float check = (IN.uv_MainTex.x - _Range) / _Range;    // the diff will be range from (-1, 1)

    //float3 sphereNoise = noisetexture.r * sphere;


    float3 primaryTex = (step(check, 0) * c.rgb);
    float3 secondaryTex = (step(0, check) * c2.rgb);
    float3 resultTex = primaryTex + secondaryTex;
    o.Albedo = resultTex;

    //o.Emission = DissolveLine;
    o.Alpha = c.a;

}

ENDCG
 
    }
 
    Fallback "Diffuse"
}