Shader "Unlit/Ex_MatCap"
{
	Properties
	{
		_MatCapTex ("Texture", 2D) = "white" {}
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 wpos : SV_POSITION;

				float3 viewDir :  TEXCOORD4;
				float3 viewNormal : TEXCOORD5;
			};

			sampler2D _MatCapTex;
			//float4 _MainTex_ST;
			

			// // https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
			v2f vert (appdata v)
			{
				v2f o;
				o.wpos = UnityObjectToClipPos(v.pos);	// Clip Position
				o.uv = v.uv;	// TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;

				o.viewNormal = UnityObjectToViewPos(v.normal);	// Normal in View Space
				o.viewDir = UnityObjectToViewPos(v.pos);		// mul((float3x3)UNITY_MATRIX_MV, v.pos);			// Position in View Space
				
				return o;
			}

			float4 matCap(float3 viewNormal, float3 viewDir)
			{
				float3 N = normalize(viewNormal);
				float3 V = normalize(viewDir);
				
				N -= V * dot(V,N);
				float2 uv = N.xy * 0.5 * 0.99 + 0.5;

				return tex2D(_MatCapTex, uv);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = matCap(i.viewNormal, i.viewDir);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
