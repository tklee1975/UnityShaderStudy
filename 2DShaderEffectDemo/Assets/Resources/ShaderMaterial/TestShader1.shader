// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Made with Digicrafts 2D Effects Shader Editor
// Available at the Unity Asset Store - http://u3d.as/QoP
Shader "2DShaderEditor/TestShader1"
{
Properties {
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
		uniform float4 _MainTexture_ST;
		uniform sampler2D _MainTexture;

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
/*DC_2DFX_START;<INFO>;version:1;width:2000;height:2000;scrollX:0;scrollY:0;</INFO>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.SpriteShaderNode;_x:350;_y:200;MultipleSpriteMode:False;PixelSnapEnable:False;SupportUnityUI:False;input:0.00,0.00,0.00,0.00;ShaderName:2DShaderEditor/TestShader1;Version:3.0;Cull:Off;ZWrite:On;ZTest:LEqual;LOD:0;AdvancedLighting:False;LightingModel:Standard;SteroEnable:False;GPUInstancing:False;CustomEditor:null;Fallback:null;RenderTypeTag:Transparent;RenderQueueTag:Transparent;BlendMode:Manual;BlendOp:Add;BlendSrc:SrcAlpha;BlendDis:OneMinusSrcAlpha;propertyPrecision:Float;ControlID:879627;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Sampler2DNode;_x:526;_y:162;inputTex:null;inputUV:0.00,0.00;outputRGBA:0.00,0.00,0.00,0.00;propertyPrecision:Float;ControlID:890932;Group:0;</NODE>;<NODE>;_type:Digicrafts.FXShader.Editor.Nodes.Texture2DNode;_x:721;_y:103;defaultValue:null;propertyType:Property;propertyName:_MainTexture;propertyLabel:MainTexture;propertyPriority:100;propertyPrecision:Float;ControlID:2831;Group:0;</NODE>;<WIRE>;in:input_879627;out:outputRGBA_890932;</WIRE>;<WIRE>;in:inputTex_890932;out:defaultValue_2831;</WIRE>;F0AD258DBAC171D76C7B641926B024AC;DC_2DFX_END*/