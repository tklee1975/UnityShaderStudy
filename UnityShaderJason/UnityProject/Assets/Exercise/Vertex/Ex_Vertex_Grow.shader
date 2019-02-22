Shader "Unlit/Ex_Vertex_Grow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Grow ("Grow", Range(0, 5.0)) = 0
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
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Grow;
			

			// Reference:
			//		https://pastebin.com/2Di01FMc
			v2f vert (appdata v)
			{
				v2f o;

				// 
				v.pos.xyz += v.normal * _Grow;

				// 
				o.pos = UnityObjectToClipPos(v.pos);		// local to clip
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
