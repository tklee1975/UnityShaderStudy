Shader "Unlit/ShiningShader"
{
	Properties
	{
		  _Speed ("Wave Speed", Range(0.1, 80)) = 5
		  _Frequency ("Frequency", Range(0, 10)) = 2
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
				float4 bloomColor : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;

				// _Time is a data given by unity 
				float time = _Time * _Speed;

				// the wave information. 
  				float sinTime = sin(time);

  				if(sinTime > 0.5) {
  					o.bloomColor = float4(sinTime, sinTime, sinTime, 0) 0 ;
  				} else {
  					o.bloomColor = float4(0, 0, 0, 0);
  				}


				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				col += i.bloomColor;

				return col;
			}
			ENDCG
		}
	}
}
