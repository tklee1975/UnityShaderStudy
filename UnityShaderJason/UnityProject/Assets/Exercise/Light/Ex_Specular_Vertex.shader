Shader "Unlit/Ex_Specular_Vertex"
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
				fixed4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _GlobalLightPos;
			float4 _AmbientColor;
			float4 _SpecularColor;
			float _SpecularIntensity;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);

				float4 wpos = mul(unity_ObjectToWorld, v.pos);	// vertex to world position

				//o.vertex ;
				
				
				
				float3 L = normalize(_GlobalLightPos - wpos);		// Light Vector 
				float3 R = L - v.normal * dot(L, v.normal) * 2;		// Reflection Vector of the Light
				float3 V = normalize(wpos - _WorldSpaceCameraPos);	// surfacePos=wpos  eyePos=CameraPos
				float specularAngle = max(0, dot(R, V));

				// No power effect
				//float4 specular = specularAngle * _SpecularColor;		// No Power Effect 
				float4 specular = _SpecularColor * pow(specularAngle, _SpecularIntensity);	// with Power Effect
				specular *= _SpecularIntensity;
				//float4 diffuse = _DiffuseColor * max(0, dot(lightDir, v.normal));



				float4 color = 0;
				color += _AmbientColor;				
				color += specular;


				// output 
				o.pos =  mul(UNITY_MATRIX_VP, wpos);	// TRANSFORM_TEX(v.uv, _MainTex);
				o.color = color; 
				
				o.uv = v.uv;


				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				// i.uv =  TRANSFORM_TEX(i.uv, _MainTex);
				// fixed4 col = tex2D(_MainTex, i.uv);
				// return col;

				return i.color;
			}
			ENDCG
		}
	}
}
