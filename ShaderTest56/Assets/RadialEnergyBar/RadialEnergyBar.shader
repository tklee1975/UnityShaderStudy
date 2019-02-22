// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Made with Digicrafts 2D Effects Shader Editor
// Available at the Unity Asset Store - http://u3d.as/QoP
Shader "2DShaderEditor/Examples/RadialEnergyBar/Type1"
{
Properties {
	_NoiseScale ("Noise Scale",Float) = 2
	_Color1 ("Color 1",Color) = (0.55,0.78,0.78,1.00)
	_Color2 ("Color 2",Color) = (0.74,0.95,0.95,1.00)
	_RadialBarPercent ("Percentage",Range(-1,1)) = 0.5
	[Toggle]_RadialBarRounded ("Rounded End",Float) = 1
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
		uniform float _NoiseScale;
		uniform fixed4 _Color1;
		uniform fixed4 _Color2;
		uniform float _RadialBarPercent;
		uniform float _RadialBarRounded;
		uniform float4 _MainTex_ST;
		uniform float4 _TextureSampleAdd;
		uniform float4 _ClipRect;

		inline float2 GetTransformUV(float2 uv, float ratio)
		{								
			uv.x/=ratio;
			return uv;
		}

		// This function is convert from https://github.com/ashima/webgl-noise/tree/master/src
		// GLSL textureless classic 2D noise cnoise,
		// with an RSL-style periodic variant pnoise.
		// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
		// Version: 2011-08-22
		//
		// Many thanks to Ian McEwan of Ashima Arts for the
		// ideas for permutation and gradient selection.
		//
		// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
		// Distributed under the MIT license. See LICENSE file.
		// https://github.com/stegu/webgl-noise
		//
		float4 mod289(float4 x)
		{
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}
		float3 mod289(float3 x)
		{
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}
		float2 mod289(float2 x) {
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		float3 permute(float3 x) {
			return mod289(((x*34.0)+1.0)*x);
		}
		float4 permute(float4 x)
		{
			return mod289(((x*34.0)+1.0)*x);
		}
		float4 taylorInvSqrt(float4 r)
		{
			return 1.79284291400159 - 0.85373472095314 * r;
		}
		float2 fade(float2 t) {
			return t*t*t*(t*(t*6.0-15.0)+10.0);
		}
		float3 fade(float3 t) {
 		 	return t*t*t*(t*(t*6.0-15.0)+10.0);
		}

		inline float SimplexNoise3D(float3 v)		
		{ 
			const float2  C = float2(1.0/6.0, 1.0/3.0) ;
			const float4  D = float4(0.0, 0.5, 1.0, 2.0);

			// First corner
			float3 i  = floor(v + dot(v, C.yyy) );
			float3 x0 =   v - i + dot(i, C.xxx) ;

			// Other corners
			float3 g = step(x0.yzx, x0.xyz);
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );

			//   x0 = x0 - 0.0 + 0.0 * C.xxx;
			//   x1 = x0 - i1  + 1.0 * C.xxx;
			//   x2 = x0 - i2  + 2.0 * C.xxx;
			//   x3 = x0 - 1.0 + 3.0 * C.xxx;
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
			float3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

			// Permutations
			i = mod289(i); 
			float4 p = permute( permute( permute( 
						i.z + float4(0.0, i1.z, i2.z, 1.0 ))
					+ i.y + float4(0.0, i1.y, i2.y, 1.0 )) 
					+ i.x + float4(0.0, i1.x, i2.x, 1.0 ));

			// Gradients: 7x7 points over a square, mapped onto an octahedron.
			// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
			float n_ = 0.142857142857; // 1.0/7.0
			float3  ns = n_ * D.wyz - D.xzx;

			float4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

			float4 x_ = floor(j * ns.z);
			float4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

			float4 x = x_ *ns.x + ns.yyyy;
			float4 y = y_ *ns.x + ns.yyyy;
			float4 h = 1.0 - abs(x) - abs(y);

			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );

			//float4 s0 = float4(lessThan(b0,0.0))*2.0 - 1.0;
			//float4 s1 = float4(lessThan(b1,0.0))*2.0 - 1.0;
			float4 s0 = floor(b0)*2.0 + 1.0;
			float4 s1 = floor(b1)*2.0 + 1.0;
			float4 sh = -step(h, float4(0,0,0,0));

			float4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
			float4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

			float3 p0 = float3(a0.xy,h.x);
			float3 p1 = float3(a0.zw,h.y);
			float3 p2 = float3(a1.xy,h.z);
			float3 p3 = float3(a1.zw,h.w);

			//Normalise gradients
			float4 norm = taylorInvSqrt(float4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
			p0 *= norm.x;
			p1 *= norm.y;
			p2 *= norm.z;
			p3 *= norm.w;

			// Mix final noise value
			float4 m = max(0.6 - float4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
			m = m * m;
			return 42.0 * dot( m*m, float4( dot(p0,x0), dot(p1,x1), 
											dot(p2,x2), dot(p3,x3) ) ) / 2+0.5;
		}

		inline float4 GetColorNormal(float4 col, float a)
		{								
			col.rgb*=a;
			return col;
		}

			inline float4 GetGradientMap(float4 col, float4 color1, float4 color2, float dark, float light)
			{
				float l = sqrt(col.r*col.r*0.299+col.g*col.g*0.587+col.b*col.b*0.114);
				l = smoothstep(dark,light,l);
				col.rgb = lerp(color1.rgb,color2.rgb,l);
				return col;
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
			float4 var_8594 = GetColorNormal(fixed4(1,1,1,1),SimplexNoise3D(float3(GetTransformUV(i.texcoord,1)*_NoiseScale,_Time.z*0.7)));
			float4 var_29224 = GetGradientMap(var_8594,_Color1,_Color2,0,1);
			float4 var_39549 = GetColorTransparent(var_29224,DrawRadialBar(i.texcoord,0.5,0.3,90,_RadialBarPercent,fixed2(0.5,0.5),_RadialBarRounded,1));
			float4 var_39733 = GetColorTransparent(fixed4(0.92,0.97,0.98,0.43),DrawRadialBar(i.texcoord,0.54,0.26,90,1,fixed2(0.5,0.5),true,1));
			float4 var_39736 = ApplyBlendingNormal(var_39549,var_39733);
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
/*DC_2DFX_START;<INFO>;version:1;width:2000;height:2000;scrollX:-313.4433;scrollY:-321.2045;</INFO>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SpriteShaderNode;_x:-464.7368;_y:40.30258;MultipleSpriteMode:False;PixelSnapEnable:False;SupportUnityUI:True;input:0.00,0.00,0.00,0.00;ShaderName:2DShaderEditor/Examples/RadialEnergyBar/Type1;Version:3.0;Cull:Off;ZWrite:On;ZTest:LEqual;LOD:0;AdvancedLighting:False;LightingModel:Standard;SteroEnable:False;GPUInstancing:False;CustomEditor:null;Fallback:null;RenderTypeTag:Transparent;RenderQueueTag:Transparent;BlendMode:Manual;BlendOp:Add;BlendSrc:SrcAlpha;BlendDis:OneMinusSrcAlpha;propertyPrecision:Float;ControlID:2249;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SimplexNoise3DGenNode;_x:624.6208;_y:-220.7021;scale:2:1;time:0;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;inputUV:0.00,0.00;transparent:False;ControlID:8594;Group:4963;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.TimeNode;_x:871.238;_y:-18.84283;t20:0;t:0;tx2:0;tx3:0;scale:0.7;ControlID:8598;Group:4963;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.GradientMapNode;_x:400.1551;_y:-29.76343;color1:0.55,0.78,0.89,1.00:1;color2:0.74,0.95,1.00,1.00:1;dark:0;light:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;ControlID:29224;Group:4963;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.RadialBarGenNode;_x:154.0948;_y:-243.8752;radiusOuter:0.5;radiusInner:0.3;angle:90;percent:0.5:1;center:0.50,0.50;rounded:True:1;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;inputUV:0.00,0.00;transparent:True;ControlID:39549;Group:4963;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.RadialBarGenNode;_x:63.23407;_y:217.3218;radiusOuter:0.54;radiusInner:0.26;angle:90;percent:1;center:0.50,0.50;rounded:True;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:0.92,0.97,0.98,0.43;inputUV:0.00,0.00;transparent:True;ControlID:39733;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.CombineLayerNode;_x:-264.0817;_y:41.92969;topLayer:1.00,1.00,1.00,1.00;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;ControlID:39736;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.CommentNode;_x:109.0815;_y:-344.4427;_w:960.4764;_h:494.524;comments:Create top Radial Bar with noise background.;ControlID:4963;Group:4963;</NODE>;<WIRE>;in:time_8594;out:tx2_8598;</WIRE>;<WIRE>;in:inputRGBA_29224;out:outputRGBA_8594;</WIRE>;<WIRE>;in:inputRGBA_39736;out:outputRGBA_39733;</WIRE>;<WIRE>;in:topLayer_39736;out:outputRGBA_39549;</WIRE>;<WIRE>;in:input_2249;out:outputRGBA_39736;</WIRE>;<WIRE>;in:inputRGBA_39549;out:outputRGBA_29224;</WIRE>;81E16C58BADCF0FA029B52619277EF8E;DC_2DFX_END*/