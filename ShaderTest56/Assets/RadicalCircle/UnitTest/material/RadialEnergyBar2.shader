// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Made with Digicrafts 2D Effects Shader Editor
// Available at the Unity Asset Store - http://u3d.as/QoP
Shader "2DShaderEditor/Examples/RadialEnergyBar/Type2"
{
Properties {
	_RadialBarAngle ("Start Angle",Range(0,360)) = 0
	_RadialBarPercent ("Percentage",Range(-1,1)) = 0.5
	[Toggle]_RadialBarRounded ("Rounded End",Float) = 1
	_Color ("Color Input",Color) = (1.00,1.00,1.00,1.00)
	[HideInInspector]_StencilComp ("_StencilComp",Float) = 8
	[HideInInspector]_Stencil ("_Stencil",Float) = 0
	[HideInInspector]_StencilOp ("_StencilOp",Float) = 0
	[HideInInspector]_StencilWriteMask ("_StencilWriteMask",Float) = 255
	[HideInInspector]_StencilReadMask ("_StencilReadMask",Float) = 255
	[HideInInspector]_ColorMask ("_ColorMask",Float) = 15
	[PerRendererData]_MainTex ("Main Texture",2D) = "white" {}
	[Toggle(UNITY_UI_ALPHACLIP)]_UseUIAlphaClip ("Use Alpha Clip",Float) = 0
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
		#define TWO_PI 6.28318530718f
		#define PI 3.14159265359f
		uniform float _RadialBarAngle;
		uniform float _RadialBarPercent;
		uniform float _RadialBarRounded;
		uniform fixed4 _Color;
		uniform float4 _MainTex_ST;
		uniform float4 _TextureSampleAdd;
		uniform float4 _ClipRect;

		inline float2 GetTransformUV(float2 uv, float ratio)
		{								
			uv.x/=ratio;
			return uv;
		}

		// Rotating uv as position
		inline float2 RotateUV(fixed2 uv, float rotation, float2 position) 
		{
			uv=uv-position;
			float sinX = sin (rotation);
			float cosX = cos (rotation);
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul ( uv, rotationMatrix ) + position;
		}
		// Rotating uv as position as 0,0
		inline float2 RotateUV(fixed2 uv, float rotation) 
		{			
			float sinX = sin (rotation);
			float cosX = cos (rotation);
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul ( uv, rotationMatrix );
		}
		

		// DrawCircle
		inline float DrawCircle(float2 uv, float radius, float2 center, float fade, float ratio)
		{			
			float2 cc = GetTransformUV(uv-center,ratio);				
			float dist = length(cc);
			float r = 0.5*radius;				
			return (1-smoothstep(r-fade,r,dist));			
		}

		// DrawRadialBar
		inline float DrawRadialBar(float2 uv, float r1, float r2, float angle, float percent, float2 center, bool rounded, float ratio)
		{						
			uv = RotateUV(uv,radians(angle),center);					
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

		inline float4 GetColorTransparent(float4 col, float a)
		{				
			col.a*=a;
			return col;
		}

		inline float4 ApplyBlendingNormal(float4 src, float4 dis)
		{			    
			return src*src.a + dis*(1-src.a);
		}

	ENDCG

    Stencil
	{
		Ref [_Stencil]
		Comp [_StencilComp]
		Pass [_StencilOp]
		ReadMask [_StencilReadMask]
		WriteMask [_StencilWriteMask]
	}


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
			o.worldPos = i.vertex;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.texcoord = i.texcoord;
			o.color = i.color;
			return o;
		}
		float4 frag(v2f i):COLOR
		{			
			float4 var_39549 = GetColorTransparent(_Color,DrawRadialBar(i.texcoord,0.55,0.35,_RadialBarAngle,_RadialBarPercent,fixed2(0.5,0.5),_RadialBarRounded,1));
			float4 var_852 = GetColorTransparent(fixed4(1,1,1,1),DrawCircle(i.texcoord,0.3,fixed2(0.5,0.5),0,1));
			float4 var_39736 = ApplyBlendingNormal(var_39549,var_852);
			float4 output = var_39736;
			output*=i.color;
			output.a *= UnityGet2DClipping(i.worldPos.xy, _ClipRect);

			#ifdef UNITY_UI_ALPHACLIP
			clip (output.a - 0.001);
			#endif
			return output;
					
		}
		ENDCG
	}

}
}
/*DC_2DFX_START;<INFO>;version:1;width:2000;height:2000;scrollX:-637.0317;scrollY:-244.7551;</INFO>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SpriteShaderNode;_x:-443.457;_y:23.93359;MultipleSpriteMode:False;PixelSnapEnable:False;SupportUnityUI:True;input:0.00,0.00,0.00,0.00;ShaderName:2DShaderEditor/Examples/RadialEnergyBar/Type2;Version:3.0;Cull:Off;ZWrite:On;ZTest:LEqual;LOD:0;AdvancedLighting:False;LightingModel:Standard;SteroEnable:False;GPUInstancing:False;CustomEditor:null;Fallback:null;RenderTypeTag:Transparent;RenderQueueTag:Transparent;BlendMode:Manual;BlendOp:Add;BlendSrc:SrcAlpha;BlendDis:OneMinusSrcAlpha;propertyPrecision:Float;ControlID:2249;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.RadialBarGenNode;_x:76.65765;_y:-138.7888;radiusOuter:0.55;radiusInner:0.35;angle:0:1;percent:0.5:1;center:0.50,0.50;rounded:True:1;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00:1;inputUV:0.00,0.00;transparent:True;ControlID:39549;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.CombineLayerNode;_x:-212.8911;_y:35.97754;topLayer:1.00,1.00,1.00,1.00;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;ControlID:39736;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.CircleGenNode;_x:82.5932;_y:144.1822;radius:0.3;fade:0;center:0.50,0.50;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;inputUV:0.00,0.00;transparent:True;ControlID:852;Group:0;</NODE>;<WIRE>;in:inputRGBA_39736;out:outputRGBA_852;</WIRE>;<WIRE>;in:topLayer_39736;out:outputRGBA_39549;</WIRE>;<WIRE>;in:input_2249;out:outputRGBA_39736;</WIRE>;6F9DC2A45CA3E65A24CD31CF904F9BC4;DC_2DFX_END*/