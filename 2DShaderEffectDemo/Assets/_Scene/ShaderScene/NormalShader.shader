Shader "ShaderTest/NormalShader"
{
	Properties
	{
	}
	SubShader
	{
		Tags { 	"RenderType"="Opaque" 
		}
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
				float4 normal : NORMAL;

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
				o.vertColor.xyz = v.normal * 0.5 + 0.5;
                o.vertColor.w = 1.0;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = i.vertColor;
				return col;
			}
			ENDCG
		}
	}
}
