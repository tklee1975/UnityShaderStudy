Shader "Unlit/TestingShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		  _ColorA ("Color A", Color) = (0,0,0,1)
  _ColorB ("Color B", Color) = (1,1,1,1)
		_Color ("Color", Color) = (1,0,0,1) // Red
		  _Speed ("Wave Speed", Range(0.1, 80)) = 5
  _Frequency ("Wave Frequency", Range(0, 10)) = 2
  _Amplitude ("Wave Amplitude", Range(-1, 1)) = 1
	}
	SubShader
	{
		GrabPass{  }
		Tags{ "RenderType" = "Opaque" }
		LOD 500

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 vertColor : COLOR;
				//float4 normal : TEXCOORD0;
			};

			sampler2D _MainTex;
			half4 _Color;
			float4 _MainTex_ST;
			 float _Speed;
float _Frequency;
float _Amplitude;
float _OffsetVal;
float4 _ColorA;
float4 _ColorB;
			
			v2f vert (appdata v)
			{
				v2f o;

				 float time = _Time * _Speed;
  

	o.uv = v.uv;


	float wavePowerSin = sin(time + v.vertex.x * _Frequency);
	float wavePower = wavePowerSin * _Amplitude;
	float diffY = wavePower;



  	v.vertex.xyz = float3(v.vertex.x, v.vertex.y + diffY, v.vertex.z);
  	//v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
  	//so.vertColor = float4(0.5,0.5,waveValueA+0.5,1);
  	o.vertColor = float4(0.5, 0.5, 0.5+wavePowerSin, 1);

  		
  			v.vertex = UnityObjectToClipPos(v.vertex);

  	o.vertex = v.vertex;

				return o;
			}
			
			fixed3 frag (v2f i) : SV_Target
			{

			 //float3 tintColor = lerp(_ColorA, _ColorB, i.vertColor).rgb; 
				// sample the texture
				//fixed4 col = fixed4(tintColor, 1); //tex2D(_MainTex, i.uv);

				return i.vertColor;
			}
			ENDCG
		}
	}
}
