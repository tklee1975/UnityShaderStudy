// Author: kenlee
Shader "CustomShader/RadicalCircle/Type1"
{
Properties {
	_Color ("Color",Color) = (0.55,0.78,0.78,1.00)
	_RadialBarPercent ("Percentage",Range(-1,1)) = 0.5
	_InnerRadius ("InnerRadius",Range(0,1)) = 0.7
	_OuterRadius ("OuterRadius",Range(0,1)) = 1
	_Angle ("_Angle",Range(0,360)) = 0

	[Toggle]_RadialBarRounded ("Rounded End",Float) = 1
	[HideInInspector]_ColorMask ("_ColorMask",Float) = 15
	[PerRendererData]_MainTex ("Main Texture",2D) = "white" {}	
}

SubShader
{
	Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True"}
	ColorMask [_ColorMask]
	ZTest [unity_GUIZTestMode]
	ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off

	CGINCLUDE		
		#include "UnityUI.cginc"
		#include "UnityCG.cginc"

		// Constant 
		#define TWO_PI 6.28318530718f
		#define PI 3.14159265359f

		// color 
		uniform fixed4 _Color;

		// Percent of the Circle 
		uniform float _RadialBarPercent;

		// Shape Related 
		uniform float _InnerRadius;
		uniform float _OuterRadius;
		uniform float _Angle;
		uniform float _RadialBarRounded;


		// Texture 
		uniform float4 _MainTex_ST;
		

		// 
		// Utility 
		//
		inline float2 GetTransformUV(float2 uv, float ratio)
		{								
			uv.x/=ratio;
			return uv;
		}

		inline float4 GetColorTransparent(float4 col, float a)
		{				
			col.a *= a;
			return col;
		}

		inline float2 RotateUV(fixed2 uv, float rotation, float2 position) 
		{
			uv=uv-position;
			float sinX = sin (rotation);
			float cosX = cos (rotation);
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul ( uv, rotationMatrix ) + position;
		}
		inline float2 RotateUV(fixed2 uv, float rotation) 
		{			
			float sinX = sin (rotation);
			float cosX = cos (rotation);
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul ( uv, rotationMatrix );
		}

		//
		// DrawRadialBar Logic 
		// 
		inline float DrawRadialBar(float2 uv, float r1, float r2, float angle,
								 float percent, float2 center, bool rounded, float ratio)
		{						
			uv = RotateUV(uv, radians(angle), center);					
			float2 cc = GetTransformUV(uv-center, ratio);			
			float l = length(cc);
			r1 = 0.5*r1;
			r2 = 0.5*r2;
			float a = acos(cc.x/l);
			float result = 0;
			
			if(l>=r2&&l<=r1){
				if(percent>0){
					if(cc.y>0){					
						if(a<percent*TWO_PI) result=1;
					} else {					
						if(a>(1-percent)*TWO_PI) result=1;
					}
				} else {
					if(cc.y<0){					
						if(a<-percent*TWO_PI) result=1;
					} else {					
						if(a>(1+percent)*TWO_PI) result=1;
					}
				}
			}

			// Draw round conrner
			if(rounded)
			{			
				float rr = (r1-r2)*0.5;			
				float2 cr = center+float2(r1-rr,0);
				float2 c1 = GetTransformUV(uv-cr, ratio);			
				if(length(c1)<rr) {
					result=1;
				} else {
					float2 c2 = RotateUV(uv,percent*TWO_PI,center);
					c2 = GetTransformUV(c2-cr, ratio);
					if(length(c2)<rr) result=1;		
				}
			}

			return result;
		}

	ENDCG

	Pass {
		Name "Base"
		CGPROGRAM
		#pragma target 3.0
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile __ UNITY_UI_ALPHACLIP


		struct appdata
		{
			float4 color:COLOR;
			float4 vertex:POSITION;
			float2 texcoord:TEXCOORD0;
		};

		struct v2f
		{
			float4 color:COLOR;
			float4 worldPos:VERTEX;
			float4 pos:SV_POSITION;
			half2 texcoord:TEXCOORD0;
		};

		v2f vert(appdata i)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.texcoord = i.texcoord;
			o.color = i.color;
			return o;
		}

		float4 frag(v2f i):COLOR
		{			

			// float percent, float2 center, bool rounded, float ratio)
			float4 givenColor = _Color;

			float4 output = GetColorTransparent(givenColor, 
								DrawRadialBar(i.texcoord, _OuterRadius, _InnerRadius,   	// 0.5, 0.3 -> r1, r2
									_Angle ,				// center ??? starting angle 
									_RadialBarPercent, 
									fixed2(0.5,0.5),   				// center 
									_RadialBarRounded, 1));			// round, x:y ratio			

			return output;					
		}
		ENDCG
	}

}
}
