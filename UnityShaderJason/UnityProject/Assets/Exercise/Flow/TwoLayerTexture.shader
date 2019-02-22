﻿
Shader "Unlit/TwoLayerTexture"
{
	Properties
	{
		_Texture ("Texture", 2D) = "white" {}
		_FlowMap ("FlowMap", 2D) = "white" {}
		_Intensity ("Intensity", Range(0, 1.0)) = 0.1
		_Speed ("Speed", Range(-1.0,1.0)) = 0.5
		
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

			sampler2D _Texture;
			sampler2D _FlowMap;
			float4 _Texture_ST;
			float _Intensity;
			float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}

			float4 detailTexColor(sampler2D tex, float4 st, float2 offset, float2 uv)
			{
				float2 tiling = st.xy;

				return tex2D(tex, uv * tiling + offset);
			}

			// https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
			
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//o.uv = TRANSFORM_TEX(v.uv, _Tex_R);
				float4 f = tex2D(_FlowMap, i.uv) * 2 - 1;

				float2 offset = f.xy * _Intensity;
				// float timeFactor = frac(_Time.y * _Speed);	// Too Ugly
				//float timeFactor = frac(_Time.y * _Speed);	// Not Good	 
				float timeFactor = frac(_Time.y * _Speed) - 0.5;	// Not Good	 
				// float timeFactor = _SinTime.y * _Speed;	// So weird
				offset += float2(0, timeFactor);

				float4 color = detailTexColor(_Texture, _Texture_ST, offset, i.uv);
				return color;
			}
			ENDCG
		}
	}
}
