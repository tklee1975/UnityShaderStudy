Shader "Unlit/TestingShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1) // Red
	}
	SubShader
	{
		GrabPass{  }
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float4 vertex : SV_POSITION;
				//float4 normal : TEXCOORD0;
			};

			sampler2D _MainTex;
			half4 _Color;
			float4 _MainTex_ST;
			 sampler2D _GrabTexture;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.uv = v.uv;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				// sample the texture
//				fixed4 col = tex2D(_MainTex, i.uv);
//				col *= _Color;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
        		return col + _Color;


				//return col;
			}
			ENDCG
		}
	}
}
