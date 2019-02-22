Shader "Unlit/DetailTexture"
{
	Properties
	{
		_Tex_R ("Texture R", 2D) = "white" {}
		_Tex_G ("Texture G", 2D) = "white" {}
		_Tex_B ("Texture B", 2D) = "white" {}
		_Tex_P ("Texture P", 2D) = "white" {}
		_Intensity ("Intensity", Range(-1.0, 1.0)) = 0
		_Mask ("Mask", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		//LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			// #pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color  : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 color  : COLOR;
				float4 vertex : SV_POSITION;
			};

			sampler2D _Tex_R;
			sampler2D _Tex_G;
			sampler2D _Tex_B;
			sampler2D _Tex_P;
			
			sampler2D _Mask;

			float4 _Tex_R_ST;
			float4 _Tex_G_ST;
			float4 _Tex_B_ST;
			float4 _Tex_P_ST;

			float _Intensity;
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.color = v.color;
						// this macro using _Tex_R_TS
				// UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float4 detailTexColor(sampler2D tex, float4 st, float2 uv)
			{
				float2 tiling = st.xy;
				float2 offset = st.zw;

				return tex2D(tex, uv * tiling + offset);
			}
			
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//o.uv = TRANSFORM_TEX(v.uv, _Tex_R);

				float4 col_R = detailTexColor(_Tex_R, _Tex_R_ST, i.uv);
				float4 col_G = detailTexColor(_Tex_G, _Tex_G_ST, i.uv);
				float4 col_B = detailTexColor(_Tex_B, _Tex_B_ST, i.uv);
				float4 col_P = detailTexColor(_Tex_P, _Tex_P_ST, i.uv);

				float4 maskValue = tex2D(_Mask, i.uv);		// control mask
				float parity = 1 -  maskValue.b - maskValue.g - maskValue.r; 

				// apply fog
				// UNITY_APPLY_FOG(i.fogCoord, col);
				float4 c = col_R * maskValue.r 
						+ col_G * maskValue.g
						+ col_B * maskValue.b
						+ col_P * parity;
				//float4 c = maskValue;
	// float4 c = maskValue.r 
	// 					+ maskValue.g
	// 					+ maskValue.b
	// 					+ maskValue.a;						
	// 			// return col_A * maskValue.a;
				return c + _Intensity;
			}
			ENDCG
		}
	}
}
