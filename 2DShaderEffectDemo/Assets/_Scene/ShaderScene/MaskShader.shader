Shader "ShaderTest/MaskShader"
{
	Properties
	{	
		[PerRendererData]_MainTex ("Texture Input",2D) = "white" {}
		_MaskTex ("Mask Texture", 2D)  = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _MaskTex;

			float _Intensity;
			float _Speed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color;		// 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mask = tex2D(_MaskTex, i.uv);
				col.a -= mask.r;

				return col;
			}
			ENDCG
		}
	}
}
