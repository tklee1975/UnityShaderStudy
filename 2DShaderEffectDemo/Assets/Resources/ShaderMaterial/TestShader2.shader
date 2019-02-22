// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Made with Digicrafts 2D Effects Shader Editor
// Available at the Unity Asset Store - http://u3d.as/QoP
Shader "2DShaderEditor/TestShader2"
{
Properties {
	_blurX ("_blurX",Range(0,1)) = 0
	_blurY ("_blurY",Range(0,1)) = 0
	_MainTexture ("MainTexture",2D) = "white" {}
}

SubShader
{
Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True"}
ZWrite On
Blend SrcAlpha OneMinusSrcAlpha
Cull Off

	CGINCLUDE		
		#include "UnityCG.cginc"
		uniform float _blurX;
		uniform float _blurY;
		uniform float4 _MainTexture_ST;
		uniform sampler2D _MainTexture;
		
		inline float4 BlurXYUV(float bx, float by, float2 uv, sampler2D tex)
		{
			float u = 0.00390625f * bx;
			float v = 0.00390625f * by;
			float4 result = float4 (0,0,0,0);				
			result += 4.0 * tex2D(tex,uv);
			uv.x-=u;result += 2.0 * tex2D(tex,uv);
			uv.y-=v;result += tex2D(tex,uv);
			uv.x+=u;result += 2.0 * tex2D(tex,uv);
			uv.x+=u;result += tex2D(tex,uv);
			uv.y+=v;result += 2.0 * tex2D(tex,uv);
			uv.y+=v;result += tex2D(tex,uv);
			uv.x-=u;result += 2.0 * tex2D(tex,uv);
			uv.x-=u;result += tex2D(tex,uv);
			return result*0.0625;
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
			float4 tex_890932 = tex2D(_MainTexture, TRANSFORM_TEX(i.texcoord,_MainTexture));
			float4 output = tex_890932;
			output*=i.color;
			return output;
					
		}
		ENDCG
	}

}
}
/*DC_2DFX_START;<INFO>;version:1;width:2000;height:2000;scrollX:0;scrollY:0;</INFO>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SpriteShaderNode;_x:83;_y:165;MultipleSpriteMode:False;PixelSnapEnable:False;SupportUnityUI:False;input:0.00,0.00,0.00,0.00;ShaderName:2DShaderEditor/TestShader2;Version:3.0;Cull:Off;ZWrite:On;ZTest:LEqual;LOD:0;AdvancedLighting:False;LightingModel:Standard;SteroEnable:False;GPUInstancing:False;CustomEditor:null;Fallback:null;RenderTypeTag:Transparent;RenderQueueTag:Transparent;BlendMode:Manual;BlendOp:Add;BlendSrc:SrcAlpha;BlendDis:OneMinusSrcAlpha;propertyPrecision:Float;ControlID:879627;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Sampler2DNode;_x:202;_y:69;inputTex:null;inputUV:0.00,0.00;outputRGBA:0.00,0.00,0.00,0.00;propertyPrecision:Float;ControlID:890932;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Texture2DNode;_x:671;_y:91;defaultValue:null;propertyType:Property;propertyName:_MainTexture;propertyLabel:MainTexture;propertyPriority:100;propertyPrecision:Float;ControlID:2831;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.BlurXYNode;_x:447;_y:266;blurX:0.5;blurY:0.5;inputUV:0.00,0.00;inputTex:null;outputTex:null;outputRGBA:0.00,0.00,0.00,0.00;ControlID:3522;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.FloatNode;_x:691;_y:290;defaultValue:0;minLimit:0;maxLimit:1;propertyType:Property;propertyName:_blurY;propertyLabel:_blurY;propertyPriority:100;propertyPrecision:Float;ControlID:3525;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.FloatNode;_x:715;_y:244;defaultValue:0;minLimit:0;maxLimit:1;propertyType:Property;propertyName:_blurX;propertyLabel:_blurX;propertyPriority:100;propertyPrecision:Float;ControlID:3527;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.InputUVNode;_x:702;_y:379;outputUV:0.00,0.00;outputX:0;outputY:0;offsetX:0;offsetY:0;ControlID:3623;Group:0;</NODE>;<WIRE>;in:input_879627;out:outputRGBA_890932;</WIRE>;<WIRE>;in:inputTex_3522;out:defaultValue_2831;</WIRE>;<WIRE>;in:inputTex_890932;out:outputTex_3522;</WIRE>;<WIRE>;in:blurX_3522;out:defaultValue_3527;</WIRE>;<WIRE>;in:blurY_3522;out:defaultValue_3525;</WIRE>;<WIRE>;in:inputUV_3522;out:outputUV_3623;</WIRE>;FED219C42E79C62CEE7FF05DC047FAC8;DC_2DFX_END*/