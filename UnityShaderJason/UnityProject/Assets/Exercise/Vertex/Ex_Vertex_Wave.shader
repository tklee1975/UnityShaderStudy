Shader "Unlit/Ex_Vertex_Wave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TestOffset ("Offset", Range(0, 100.0)) = 0
		_Amplitude ("Amplitude", Range(0, 3.0)) = 1
		_WaveLength("WaveLength", Range(0.01, 20)) = 1
		_Speed("Speed", Range(0.1, 5.0)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull Off 

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
			float _TestOffset;
			float _Amplitude;
			float _WaveLength;
			float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);

				float4 wpos = mul(unity_ObjectToWorld, v.pos);		// local -> world position 

				// Increase the Y 
				// wpos.y += sin(_TestOffset + v.uv.y/_WaveLength) * _Amplitude;	// testing 
				wpos.y += sin(_Time.y * _Speed + v.uv.y/_WaveLength) * _Amplitude;
				// wpos.y += sin(_Time.y + v.uv.y / waveLength) * amplitude;

				o.pos = mul(UNITY_MATRIX_VP, wpos);

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
