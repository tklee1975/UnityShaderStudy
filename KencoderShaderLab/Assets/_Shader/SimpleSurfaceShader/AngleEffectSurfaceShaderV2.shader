﻿Shader "Kencoder/AngleEffectSurfaceShaderV2" {
	Properties {
    _TopTex ("Top Texture (RGB)", 2D) = "white" {}
    _BottomTex ("Bottom Texture (RGB)", 2D) = "white" {}
    _EffectAngle("Angle", Vector) = (1,1,1)  
    _Threshold("Threshold", Range(-5,5)) = 0
	}

	SubShader {
    Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM

	  // surface shader | func = surf(..) | lightingModel = Lambert
    #pragma surface surf Lambert
    struct Input {
      float2 uv_TopTex : TEXCOORD0;
      float2 uv_BottomTex : TEXCOORD0;
    };

    float4 _EffectAngle;
    float _Threshold;
    sampler2D _TopTex;
    sampler2D _BottomTex;



    void surf (Input IN, inout SurfaceOutput o) {
      // fixed2 unitVector = normalize(fixed2(_x, _y));
      // fixed2 newUV = dot(IN.uv_MainTex, unitVector);  // * unitVector;											
		  
      fixed4 c;
      
      //o.Albedo = abs(o.Normal);
      if (dot( o.Normal, _EffectAngle.xyz) >= _Threshold) { // if dot product result is higher than snow amount, we turn it into sn
        c = tex2D (_TopTex, IN.uv_TopTex);
      } else {
        c = tex2D (_BottomTex, IN.uv_BottomTex);
      }
      
      o.Albedo = c.rgb;
      o.Alpha = c.a;
      //fixed2 uv = IN.uv_MainTex;
      //o.Albedo = fixed3(uv.x, uv.y, 0);
    }

    ENDCG
  }
  Fallback "Diffuse"
}