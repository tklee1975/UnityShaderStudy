Shader "ShaderTest/LightedColorShader"
{
	Properties
	{
		_MainColor ("Main Color",Color) = (0.55,0.78,0.78,1.00)
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

			float4 _MainColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;

			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 vertexColor : COLOR1;	// 	intensity
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.vertex = UnityObjectToClipPos(v.vertex);

				// given that y plane receive most light, z the second and x the least
				float intensity = v.normal.x *0.3 + v.normal.y * 1 + v.normal.z * 0.5;
				o.vertexColor = _MainColor * intensity;

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
