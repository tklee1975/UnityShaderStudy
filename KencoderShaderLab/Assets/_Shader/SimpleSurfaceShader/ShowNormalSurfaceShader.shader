Shader "Kencoder/ShowNormalSurfaceShader" {
	Properties {
	}

	SubShader {
      Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM

	  // surface shader | func = surf(..) | lightingModel = Lambert
    #pragma surface surf Lambert
    struct Input {
      float2 uv_MainTex : TEXCOORD0;
    };



    void surf (Input IN, inout SurfaceOutput o) {
      // fixed2 unitVector = normalize(fixed2(_x, _y));
      // fixed2 newUV = dot(IN.uv_MainTex, unitVector);  // * unitVector;											
		  
      // fixed4 c = tex2D (_MainTex, newUV);
		  o.Albedo = abs(o.Normal);
      //fixed2 uv = IN.uv_MainTex;
      //o.Albedo = fixed3(uv.x, uv.y, 0);
    }

    ENDCG
  }
  Fallback "Diffuse"
}