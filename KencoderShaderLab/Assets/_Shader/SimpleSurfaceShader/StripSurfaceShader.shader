Shader "Kencoder/Simple/StripSurfaceShader" {
	Properties {
        _MainTex ("Primary (RGB)", 2D) = "white" {}
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
        fixed3 color1 = fixed3(0.5, 0, 0);      // RED
        fixed3 color2 = fixed3(0, 0.5, 0);      // GREEN
        fixed3 color3 = fixed3(0, 0, 0.5);      // BLUE

        fixed2 uv = IN.uv_MainTex;

        fixed3 xColor, yColor;

        //xColor = step(uv.x, 0.5) * color1;
        xColor = lerp(color1, color2, step(0.5, uv.x));

        // "if-else"  style version
        // if(uv.x < 0.5) {
        //     xColor = color1;
        // } else {
        //     xColor = color2;
        // }

        fixed3 tmpColor = lerp(color2, color3, step(0.66, uv.y));
        yColor = lerp(color1, tmpColor, step(0.33, uv.y));

        // if(uv.y < 0.33) {
        //     yColor = color1;
        // } else if(uv.y < 0.66) {
        //     yColor = color2;
        // } else {
        //     yColor = color3;
        // }
          
          
        //o.Albedo = yColor;      // 3 horizontal strips
        //o.Albedo = xColor;      // 2 vertical strips
        
        o.Albedo = xColor + yColor;  // mixing vertical and horizontal strips
        
      }

      ENDCG
    }
    Fallback "Diffuse"
}
