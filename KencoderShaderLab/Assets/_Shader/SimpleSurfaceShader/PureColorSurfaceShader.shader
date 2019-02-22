Shader "Kencoder/Simple/PureColorSurfaceShader" {
	Properties {
		_Color 		("Color", Color) = (1,1,1)
	}

	SubShader {
      Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM

	  // surface shader | func = surf(..) | lightingModel = Lambert
      #pragma surface surf Lambert
      struct Input {
          float4 color : COLOR;
      };


	  fixed4 _Color;
      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = _Color.rgb;
      }

      ENDCG
    }
    Fallback "Diffuse"
}
