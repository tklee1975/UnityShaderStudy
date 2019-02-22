Shader "Unlit/Ex_Simple_Input"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ColorTint ("_ColorTint", Vector) = (0, 0, 0, 0)
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
			float4 _ColorTint;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				i.uv =  TRANSFORM_TEX(i.uv, _MainTex);
				fixed4 col = tex2D(_MainTex, i.uv);
				return _ColorTint;
			}
			ENDCG
		}
	}
}
