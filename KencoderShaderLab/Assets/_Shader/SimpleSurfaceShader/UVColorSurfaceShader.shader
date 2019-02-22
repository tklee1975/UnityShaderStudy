Shader "Kencoder/Simple/UVColorSurfaceShader" {
	Properties {
        _MainTex ("Primary (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic 	("Metallic", Range(0,1)) = 0.0
	}

	SubShader {
      Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM

	  // surface shader | func = surf(..) | lightingModel = Lambert
      #pragma surface surf Lambert
      struct Input {
          float2 uv_MainTex : TEXCOORD0;
      };

      sampler2D _MainTex;

	  fixed4 _Color;
      void surf (Input IN, inout SurfaceOutput o) {
          fixed2 uv = IN.uv_MainTex;
          o.Albedo = fixed3(uv.x, uv.y, 0);
      }

      ENDCG
    }
    Fallback "Diffuse"
}
