Shader "ShaderTest/AnimatedLineShader"
{
	Properties
	{
		_Speed ("Speed", Range(1,10)) = 5
		_LineSize ("Line Size", Range(0.01, 0.1)) = 0.01
		_LineColor ("Line Color", Color) = (0.8,0.8,0.1,1.00)
		[PerRendererData]_MainTex ("Texture Input",2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

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
			float _Speed;
			float4 _LineColor;
			float _LineSize;

		
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
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed modTime = fmod(_Time * _Speed, 1.0);
				fixed4 lineColor = _LineColor;
				fixed startY = modTime;
				fixed endY = startY + _LineSize;

				// if the uv.y fall in the drawLine range, use the line Color, else use the original pixel color
				fixed4 finalColor = (i.uv.y >= startY && i.uv.y < endY) ? lineColor : col;

				return finalColor;
			}
			ENDCG
		}
	}
}
