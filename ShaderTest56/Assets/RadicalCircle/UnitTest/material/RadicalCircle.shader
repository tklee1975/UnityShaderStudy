Shader "Unlit/RadicalCircle"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			inline float2 GetTransformUV(float2 uv, float ratio)
			{								
				uv.x /= ratio;
				return uv;
			}

			// DrawCircle
			inline float DrawCircle(float2 uv, float radius, float2 center, float fade, float ratio)
			{				
				float2 cc = GetTransformUV(uv-center, ratio);				

				float dist = length(cc);

				float r = 0.5 * radius;				

				return (1-smoothstep(r-fade, r, dist));			
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 color = fixed4(1, 0, 0, 1);


				fixed4 col = fixed4(1, 0, 0, 1); // tex2D(_MainTex, i.uv);
				
				return col;
			}
			ENDCG
		}
	}
}
