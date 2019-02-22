// https://paste.ofcode.org/pgUwTn3H8ZnEizDJy5JChS
Shader "Unlit/WorkingShader"
{
	Properties
	{
		  _Speed ("Wave Speed", Range(0.1, 80)) = 5
		  _Frequency ("Frequency", Range(0, 10)) = 2
  		  _Amplitude ("Wave Amplitude", Range(-1, 1)) = 1
	}
	SubShader
	{
		GrabPass{  }
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


			// Data Structure 
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 vertColor : COLOR;
				//float4 normal : TEXCOORD0;
			};

			// Internal Variable 
			float _Speed;
			float _Frequency;
			float _Amplitude;

			v2f vert (appdata v)
			{
				v2f o;

//				/v.vertex = UnityObjectToClipPos(v.vertex);
				o.vertColor = float4(v.vertex.x, v.vertex.y, v.vertex.y, 1);

				v.vertex = UnityObjectToClipPos(v.vertex);

				o.vertex = v.vertex;
				

				// Wave Form 

//				// _Time is a data given by unity 
//				float time = _Time * _Speed;
//
//				// the wave information. 
//  				float wavePowerSin = sin(time + v.vertex.x * _Frequency);
//				float wavePower = wavePowerSin * _Amplitude;
//				float diffY = wavePower;
//
//				// Modification to the vertex, that make wave form
//  				v.vertex.xyz = float3(v.vertex.x, v.vertex.y + diffY, v.vertex.z);
//
//  				// Modification to the color, make it a bit sexy
//			  	o.vertColor = float4(0.8, 0.8, 0.5+wavePowerSin, 1);
//
//  				// Transform Clip coordinate as usual 
//	  			o.vertex = UnityObjectToClipPos(v.vertex);
//
				return o;
			}
			
			fixed3 frag (v2f i) : SV_Target
			{
				return i.vertColor;
			}
			ENDCG
		}
	}
}
