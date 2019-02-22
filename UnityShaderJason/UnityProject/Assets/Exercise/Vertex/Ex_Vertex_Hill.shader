Shader "Unlit/Ex_Vertex_Hill"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	//	_Locator ("Locator", Vector) = (0, 0, 0, 0)
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Locator;
			
			v2f vert (appdata v)
			{

				v2f o;

				float4 wpos = mul(unity_ObjectToWorld, v.pos);		// local -> world position 

				float4 diff = _Locator - wpos;

				wpos.y += clamp(1 - length(diff.zx), 0 , 1) * 5;

				o.pos = mul(UNITY_MATRIX_VP, wpos);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				i.uv =  TRANSFORM_TEX(i.uv, _MainTex);
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
