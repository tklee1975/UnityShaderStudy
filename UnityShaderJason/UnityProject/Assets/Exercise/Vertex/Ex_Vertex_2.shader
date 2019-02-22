// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Ex_Vertex_2"
{
	// https://docs.unity3d.com/Manual/SL-Properties.html
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		testFloat ("testFloat", Range(0, 1)) = 0
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float testFloat;
			
			v2f vert (appdata v)
			{
				v2f o;

				// See: https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
				// o.vertex = UnityObjectToClipPos(v.vertex);
				// o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);	// will be converted by Unity....
				
				

				// Building the Transformation Matrix
				float s = sin(testFloat  * v.vertex.y);
				float c = cos(testFloat  * v.vertex.y) ;
				float2x2 rot = float2x2(c, -s, s, c);

				// Modify wpos
				v.vertex.xz = mul(rot, v.vertex.xz);
				// o.vertex = UnityObjectToClipPos(v.vertex + _Offset);

				float4 wpos = mul(unity_ObjectToWorld, v.vertex);	// vertex to world position

				//o.vertex ;
				o.vertex =  mul(UNITY_MATRIX_VP, wpos);	// TRANSFORM_TEX(v.uv, _MainTex);
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
