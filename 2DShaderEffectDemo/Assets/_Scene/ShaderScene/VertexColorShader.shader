Shader "ShaderTest/VertexColorShader"
{
	Properties
	{
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 vertColor : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 vertColor : COLOR;
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertColor = v.vertColor;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.vertColor;
			}
			ENDCG
		}
	}
}
