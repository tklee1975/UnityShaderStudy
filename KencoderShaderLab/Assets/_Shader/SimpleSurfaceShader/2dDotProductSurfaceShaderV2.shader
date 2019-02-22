Shader "Kencoder/2dDotProductSurfaceShaderV2" {
	Properties {
    _MainTex ("Primary (RGB)", 2D) = "white" {}
		_x ("portion x", Range (0,1)) = 0.5
    _y ("portion y", Range (0,1)) = 0.5
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
	  fixed _x;
    fixed _y;


	//   void vert (inout appdata_full v) {
    // 	v.texcoord.xy -=0.5;
    //             float s = sin ( _RotationSpeed * _Time );
    //             float c = cos ( _RotationSpeed * _Time );
    //             float2x2 rotationMatrix = float2x2( c, -s, s, c);
    //             rotationMatrix *=0.5;
    //             rotationMatrix +=0.5;
    //             rotationMatrix = rotationMatrix * 2-1;
    //             v.texcoord.xy = mul ( v.texcoord.xy, rotationMatrix );
    //             v.texcoord.xy += 0.5;
    //         }


    void surf (Input IN, inout SurfaceOutput o) {
      fixed2 unitVector = normalize(fixed2(_x, _y));
      fixed2 newUV = dot(IN.uv_MainTex, unitVector);  // * unitVector;											
		  
      fixed4 c = tex2D (_MainTex, newUV);
		  o.Albedo = c.rgb;
      //fixed2 uv = IN.uv_MainTex;
      //o.Albedo = fixed3(uv.x, uv.y, 0);
    }

    ENDCG
  }
  Fallback "Diffuse"
}