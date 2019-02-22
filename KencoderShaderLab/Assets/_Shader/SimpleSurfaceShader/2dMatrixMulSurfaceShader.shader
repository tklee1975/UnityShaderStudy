Shader "Kencoder/2dMatrixMulSurfaceShader" {
	Properties {
        _MainTex ("Primary (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic 	("Metallic", Range(0,1)) = 0.0
		_Offset ("Offset", Range(0,1)) = 0.0
		_TransformMatrix ("Transform Matrix", Vector) = (1, 0, 0, 1)
	}

	SubShader {
      Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM

	  // surface shader | func = surf(..) | lightingModel = Lambert
      #pragma surface surf Lambert vertex:vert
      struct Input {
        float2 uv_MainTex : TEXCOORD0;
      };

      sampler2D _MainTex;

	  fixed4 _Color;
	  half _Offset;
	  fixed4 _TransformMatrix;

	  void vert (inout appdata_full v) {
		v.texcoord.xy -= _Offset;  
		float2x2 rotationMatrix = float2x2(_TransformMatrix.x, _TransformMatrix.y, 
											_TransformMatrix.z, _TransformMatrix.w);
		v.texcoord.xy = mul ( v.texcoord.xy, rotationMatrix );											
	  }

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
		fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
		o.Albedo = c.rgb;
        //   fixed2 uv = IN.uv_MainTex;
        //   o.Albedo = fixed3(uv.x, uv.y, 0);
      }

      ENDCG
    }
    Fallback "Diffuse"
}