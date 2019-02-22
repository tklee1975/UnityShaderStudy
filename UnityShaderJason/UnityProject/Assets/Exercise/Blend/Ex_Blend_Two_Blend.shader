Shader "Unlit/Ex_Blend_Two_Blend"
{
	Properties
	{
		_TestColor("Test Color", Color) = (1,1,1,1)		
	}
	SubShader
	{
		// Case 1: Queue not correct
		//  Tags { "Queue"="Transparent" }
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		Pass
		{
			Cull Off
			ZWrite Off
			//ZTest Always

			// Reference: https://docs.unity3d.com/Manual/SL-Blend.html
			// Blend SrcAlpha OneMinusSrcAlpha, SrcColor OneMinusSrcColor	// most common: 
												// , SrcAlpha OneMinusSrcAlpha
			//Blend SrcAlpha OneMinusSrcAlpha, SrcColor OneMinusSrcColor	// most common: 												
			Blend One OneMinusSrcAlpha, SrcColor OneMinusSrcColor	// most common: 

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

			float4 _TestColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _TestColor;
			}
			ENDCG
		}
	}
}
