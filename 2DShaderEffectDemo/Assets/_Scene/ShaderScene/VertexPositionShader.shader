Shader "ShaderTest/VertexPositionShader"
{
	Properties
	{
	}
	SubShader
	{
		Tags { 
			"RenderType"="Opaque" 
			 "DisableBatching" = "True"
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

			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 vertexColor : COLOR;
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.vertexColor = v.vertex + float4(0.5, 0.5, 0.5, 0.0); // v.vertex range from -0.5 to 0.5 

				//v.vertex += 

				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = i.vertexColor;
				return col;
			}
			ENDCG
		}
	}
}
