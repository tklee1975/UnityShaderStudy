// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Made with Digicrafts 2D Effects Shader Editor
// Available at the Unity Asset Store - http://u3d.as/QoP
Shader "2DShaderEditor/Testing"
{
Properties {
	_name ("_name",2D) = "white" {}
}

SubShader
{
Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True"}
ZWrite On
Blend SrcAlpha OneMinusSrcAlpha
Cull Off

	CGINCLUDE		
		#include "UnityCG.cginc"
		uniform float4 _name_ST;
		uniform sampler2D _name;

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

		// Classic Perlin noise
		float PerlinNoise2D(float2 P)
		{
			float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
			float4 Pf = frac(P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
			Pi = mod289(Pi); // To avoid truncation effects in permutation
			float4 ix = Pi.xzxz;
			float4 iy = Pi.yyww;
			float4 fx = Pf.xzxz;
			float4 fy = Pf.yyww;

			float4 i = permute(permute(ix) + iy);

			float4 gx = frac(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
			float4 gy = abs(gx) - 0.5 ;
			float4 tx = floor(gx + 0.5);
			gx = gx - tx;

			float2 g00 = float2(gx.x,gy.x);
			float2 g10 = float2(gx.y,gy.y);
			float2 g01 = float2(gx.z,gy.z);
			float2 g11 = float2(gx.w,gy.w);

			float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
			g00 *= norm.x;  
			g01 *= norm.y;  
			g10 *= norm.z;  
			g11 *= norm.w;  

			float n00 = dot(g00, float2(fx.x, fy.x));
			float n10 = dot(g10, float2(fx.y, fy.y));
			float n01 = dot(g01, float2(fx.z, fy.z));
			float n11 = dot(g11, float2(fx.w, fy.w));

			float2 fade_xy = fade(Pf.xy);
			float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
			float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
			return 2.3 * n_xy/2+0.5;
		}

		inline float4 GetColorNormal(float4 col, float a)
		{								
			col.rgb*=a;
			return col;
		}

	ENDCG

	Pass {
		Name "Base"
		CGPROGRAM
		#pragma target 3.0
		#pragma vertex vert
		#pragma fragment frag


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
			float4 tex_284664 = tex2D(_name, TRANSFORM_TEX(i.texcoord,_name));
			float4 var_1522 = GetColorNormal(tex_284664,PerlinNoise2D(GetTransformUV(i.texcoord,_SinTime.w )*10));
			float4 output = var_1522;
			output*=i.color;
			return output;
					
		}
		ENDCG
	}

}
}
/*DC_2DFX_START;<INFO>;version:1;width:2000;height:2000;scrollX:0;scrollY:0;</INFO>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SpriteShaderNode;_x:16;_y:39;MultipleSpriteMode:False;PixelSnapEnable:False;SupportUnityUI:False;input:0.00,0.00,0.00,0.00;ShaderName:2DShaderEditor/Testing;Version:3.0;Cull:Off;ZWrite:On;ZTest:LEqual;LOD:0;AdvancedLighting:False;LightingModel:Standard;SteroEnable:False;GPUInstancing:False;CustomEditor:null;Fallback:null;RenderTypeTag:Transparent;RenderQueueTag:Transparent;BlendMode:Manual;BlendOp:Add;BlendSrc:SrcAlpha;BlendDis:OneMinusSrcAlpha;propertyPrecision:Float;ControlID:445415;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Sampler2DNode;_x:430;_y:30;inputTex:null;inputUV:0.00,0.00;outputRGBA:0.00,0.00,0.00,0.00;propertyPrecision:Float;ControlID:284664;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Texture2DNode;_x:646.5;_y:105;defaultValue:null;propertyType:Property;propertyName:_name;propertyLabel:_name;propertyPriority:100;propertyPrecision:Float;ControlID:1206;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.PerlinNoise2DGenNode;_x:131;_y:235.5;scale:10;aspectRatio:1;outputRGBA:1.00,1.00,1.00,1.00;inputRGBA:1.00,1.00,1.00,1.00;inputUV:0.00,0.00;transparent:False;ControlID:1522;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SinTimeNode;_x:446;_y:307.5;t8:0;t4:0;t2:0;t:0;scale:1;ControlID:1575;Group:0;</NODE>;<WIRE>;in:inputTex_284664;out:defaultValue_1206;</WIRE>;<WIRE>;in:inputRGBA_1522;out:outputRGBA_284664;</WIRE>;<WIRE>;in:input_445415;out:outputRGBA_1522;</WIRE>;<WIRE>;in:aspectRatio_1522;out:t_1575;</WIRE>;F6ADCE010BC92DF44F27AA827B02631C;DC_2DFX_END*/