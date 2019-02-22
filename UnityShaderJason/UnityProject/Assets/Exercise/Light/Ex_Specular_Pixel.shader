
Shader "Unlit/Ex_Specular_Pixel"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_AmbientColor ("_AmbientColor", Color) = (1, 1, 1, 1)
		_SpecularColor ("_SpecularColor", Color) = (1, 1, 1, 1)
		_SpecularShininess ("SpecularShininess", Range(0.5,3)) = 1
		_SpecularIntensity ("SpecularIntensity", Range(0.5,10)) = 1
		//_AmbientColor ("_AmbientColor", Color) = (1, 1, 1, 1)
		//_LightPosition ("Light Position", Vector) = (1, 1, 1, 0)
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

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 wpos		: TEXCOORD7;
				float3 normal	: NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _GlobalLightPos;
			float4 _AmbientColor;
			float4 _SpecularColor;
			float _SpecularShininess;
			float _SpecularIntensity;
			

			//// ------
			float4 specularLighting(float3 wpos, float3 normal)
			{
				float3 L = normalize(_GlobalLightPos - wpos);		// Light Vector 
				float3 R = L - normal * dot(L, normal) * 2;		// Reflection Vector of the Light
				float3 V = normalize(wpos - _WorldSpaceCameraPos);	// surfacePos=wpos  eyePos=CameraPos
				float specularAngle = max(0, dot(R, V));

				
				//float4 specular = specularAngle * _SpecularColor;		// No Power Effect 
				float4 specular = _SpecularColor * pow(specularAngle, _SpecularShininess);	// with Power Effect
				specular *= _SpecularIntensity;


				return specular;
			}

			//// ------


			// Note:
			//		vert passing the wpos and normal to fragment shader
			v2f vert (appdata v)
			{
				v2f o;
				
				o.pos = UnityObjectToClipPos(v.pos);
				o.wpos = mul(UNITY_MATRIX_M, v.pos).xyz;

				o.normal = mul((float3x3)UNITY_MATRIX_M, v.normal);	// Normal in World Space 
				
				o.uv = v.uv;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return specularLighting(i.wpos, i.normal) + _AmbientColor;
			}
			ENDCG
		}
	}
}
