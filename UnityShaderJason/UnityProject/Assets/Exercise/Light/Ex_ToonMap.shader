Shader "Unlit/Ex_ToonMap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ToonTex ("Toon Texture", 2D) = "white" {}
		_ToonRange1 ("ToolRange 1", Range(0, 1)) = 0.8
		_ToonColor1 ("ToonColor1", Color) = (1, 0, 0, 1)

		_ToonRange2 ("ToolRange 2", Range(0, 1)) = 0.5
		_ToonColor2 ("ToonColor2", Color) = (0, 1, 0, 1)

		_ToonColor3 ("ToonColor3", Color) = (0, 0, 1, 1)
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv 		: TEXCOORD0;
				float4 pos 		: SV_POSITION;
				float3 wpos		: TEXCOORD7;
				float3 normal	: NORMAL;
			};

			sampler2D _MainTex;
			sampler2D _ToonTex;

			float4 _MainTex_ST;
			float4 _GlobalLightPos;

			float4 _ToonColor1;
			float4 _ToonColor2;
			float4 _ToonColor3;

			float _ToonRange1;
			float _ToonRange2;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.wpos = mul(UNITY_MATRIX_M, v.pos).xyz;				// World Position 
				o.normal = mul((float3x3)UNITY_MATRIX_M, v.normal);		// World Normal 			
				o.uv = v.uv;
				return o;
			}

			float4 toonShading(float3 pos, float3 normal) 
			{
				float3 N = normalize(normal);				// 
				float3 L = normalize(_GlobalLightPos - pos);		// 

				float angleDot = max(0, dot(N,L));		// dot(N, L) give (-1 ~ 1) , -1 ~ 0 can be ignored

				return tex2D(_ToonTex, float2(0.5, angleDot));	// use different color for different angle (y)
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return toonShading(i.wpos, i.normal);
			}
			ENDCG
		}
	}
}
