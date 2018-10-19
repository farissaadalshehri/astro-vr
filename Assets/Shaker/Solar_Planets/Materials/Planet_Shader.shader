// Upgrade NOTE: upgraded instancing buffer 'NewAmplifyShader' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_2k_mars("2k_mars", 2D) = "white" {}
		_RampColor("Ramp Color", Color) = (0.413,0.1056512,0,1)
		_Power("Power", Float) = 0
		_Scale("Scale", Float) = 0
		_Bias("Bias", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _2k_mars;
		uniform float4 _2k_mars_ST;

		UNITY_INSTANCING_BUFFER_START(NewAmplifyShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _RampColor)
#define _RampColor_arr NewAmplifyShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Power)
#define _Power_arr NewAmplifyShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Bias)
#define _Bias_arr NewAmplifyShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Scale)
#define _Scale_arr NewAmplifyShader
		UNITY_INSTANCING_BUFFER_END(NewAmplifyShader)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_2k_mars = i.uv_texcoord * _2k_mars_ST.xy + _2k_mars_ST.zw;
			o.Albedo = tex2D( _2k_mars, uv_2k_mars ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float _Bias_Instance = UNITY_ACCESS_INSTANCED_PROP(_Bias_arr, _Bias);
			float _Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Scale_arr, _Scale);
			float _Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Power_arr, _Power);
			float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2 = ( _Bias_Instance + _Scale_Instance * pow( 1.0 - fresnelNdotV2, _Power_Instance ) );
			float4 _RampColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_RampColor_arr, _RampColor);
			o.Emission = ( fresnelNode2 * _RampColor_Instance ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15700
0;583;1135;435;1576.185;-27.51273;1.501392;True;True
Node;AmplifyShaderEditor.RangedFloatNode;6;-1000.226,251.5436;Float;False;InstancedProperty;_Scale;Scale;3;0;Create;True;0;0;False;0;0;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-900.4283,158.4432;Float;False;InstancedProperty;_Bias;Bias;4;0;Create;True;0;0;False;0;0;-0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-924.8279,342.8432;Float;False;InstancedProperty;_Power;Power;2;0;Create;True;0;0;False;0;0;1.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-808.1193,422.8365;Float;False;InstancedProperty;_RampColor;Ramp Color;1;0;Create;True;0;0;False;0;0.413,0.1056512,0,1;0.1803921,0.2353827,0.2627451,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;2;-692.1501,235.6025;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-374.3761,311.2389;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-604.6506,-109.5578;Float;True;Property;_2k_mars;2k_mars;0;0;Create;True;0;0;False;0;cb3620e818a82eb47b50ec849c8aab36;84f2d97ee1f288444b4f11e63c68f578;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;1;5;0
WireConnection;2;2;6;0
WireConnection;2;3;7;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;0;0;1;0
WireConnection;0;2;4;0
ASEEND*/
//CHKSM=8148521337657ABB1EF3F747B7DEC52C53ED054A