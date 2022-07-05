Shader "Ciconia Studio/CS_Wet Animation/Builtin/Flood/Transparent"
{
	Properties
	{
		[Space(35)][Header(Main Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalXYTilingXYZWOffsetXY("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		_Color("Color", Color) = (1,1,1,0)
		[Toggle]_InvertABaseColor("Invert Alpha", Float) = 0
		_MainTex("Base Color  -->(Transparency A)", 2D) = "white" {}
		_Saturation("Saturation", Float) = 0
		_Brightness("Brightness", Range( 1 , 8)) = 1
		[Space(35)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Intensity", Float) = 0.3
		[Space(35)]_MetallicGlossMap("Metallic Map  -->(Smoothness A)", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0
		_Glossiness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(10)][KeywordEnum(MetallicAlpha,BaseColorAlpha)] _Source("Source", Float) = 0
		[Space(35)]_ParallaxMap("Height Map", 2D) = "white" {}
		_Parallax("Height Scale", Range( -0.1 , 0.1)) = 0
		[Space(35)]_OcclusionMap("Ambient Occlusion Map", 2D) = "white" {}
		_AoIntensity("Ao Intensity", Range( 0 , 2)) = 1
		[HDR][Space(45)]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionIntensity("Intensity", Range( 0 , 2)) = 1
		[Space(35)][Header(Mask Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)][Toggle]_VisualizeMask1("Visualize Mask", Float) = 0
		[Toggle]_ExcludeMask("Exclude - Use BaseColorAlpha", Float) = 0
		[Space(15)][Toggle]_InvertMask("Invert Mask", Float) = 0
		_DetailMask("Detail Mask", 2D) = "black" {}
		_IntensityMask("Intensity", Range( 0 , 1)) = 1
		[Space(15)]_ContrastDetailMap("Contrast", Float) = 0
		_SpreadDetailMap("Spread", Range( 0 , 1)) = 0.5
		[Space(35)][Header(Reflection Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________) ][Space(15)]_ColorCubemap("Color ", Color) = (1,1,1,1)
		[HDR]_Cubemap("Cubemap", CUBE) = "black" {}
		[Space(10)]_ReflectionIntensity("Intensity", Range( 0 , 10)) = 0.2
		_BlurReflection("Blur", Range( 0 , 7)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Space(35)][Header(Puddle Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_DetailColor("Color", Color) = (0.5019608,0.5019608,0.5019608,0)
		[Toggle(_USEMAINBASECOLORMAP_ON)] _UseMainBaseColorMap("Use Main BaseColor Map", Float) = 1
		_DetailAlbedoMap("Base Color", 2D) = "white" {}
		_DetailSaturation("Saturation", Float) = 0
		_DetailBrightness("Brightness", Range( 1 , 8)) = 1
		[Toggle]_UseMainNormalMapasNormalDirection1("Use Main Normal Map as Normal Direction", Float) = 1
		[Space(35)][Toggle]_BlendMainNormal("Blend Main Normal", Float) = 0
		_DetailNormalMap("Wave Normal Map", 2D) = "bump" {}
		[Space(15)][Toggle(_MAINWAVE_ON)] _MainWave("Main Wave", Float) = 1
		_NormalWaveIntensity1("Intensity", Float) = 0.5
		_TranslationSpeed1("Speed", Float) = 1
		_RotationAngle1("Rotation", Float) = 0
		_TilingWave1("Tiling", Float) = 1
		[Space(25)][Toggle(_DETAILWAVE_ON)] _DetailWave("Detail Wave", Float) = 1
		_NormalWaveIntensity2("Intensity", Float) = 0.3
		_TranslationSpeed2("Speed", Float) = 1
		_RotationAngle2("Rotation", Float) = 90
		_TilingWave2("Tiling", Float) = 1
		[Space(15)]_Metallic2("Metallic", Range( 0 , 2)) = 0
		_Glossiness2("Smoothness", Range( 0 , 2)) = 0.95
		[Space(15)][Toggle]_UseAoFromMainProperties("Use Ao From Main Properties", Float) = 1
		[Toggle]_UseEmissionFromMainProperties("Use Emission From Main Properties", Float) = 1
		[Space(45)][Header(Transparency Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)][KeywordEnum(None,DetailMask,BaseColorAlpha)] _MaskSelection("Mask Selection", Float) = 1
		[Toggle]_InvertTransparencyMask("Invert", Float) = 0
		[Space(15)]_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_Refraction("Refraction", Range( 0 , 2)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ "_ScreenGrab0" }
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _DETAILWAVE_ON
		#pragma shader_feature_local _MAINWAVE_ON
		#pragma shader_feature_local _USEMAINBASECOLORMAP_ON
		#pragma shader_feature_local _MASKSELECTION_NONE _MASKSELECTION_DETAILMASK _MASKSELECTION_BASECOLORALPHA
		#pragma shader_feature_local _SOURCE_METALLICALPHA _SOURCE_BASECOLORALPHA
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float3 worldRefl;
			float4 screenPos;
			float3 worldNormal;
		};

		uniform float _BlendMainNormal;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float4 _GlobalXYTilingXYZWOffsetXY;
		uniform sampler2D _ParallaxMap;
		uniform float4 _ParallaxMap_ST;
		uniform float _Parallax;
		uniform float _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float _TranslationSpeed1;
		uniform float4 _DetailNormalMap_ST;
		uniform float _TilingWave1;
		uniform float _RotationAngle1;
		uniform float _NormalWaveIntensity1;
		uniform float _TranslationSpeed2;
		uniform float _TilingWave2;
		uniform float _RotationAngle2;
		uniform float _NormalWaveIntensity2;
		uniform float _ExcludeMask;
		uniform float _ContrastDetailMap;
		uniform float _InvertMask;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform float _SpreadDetailMap;
		uniform float _InvertABaseColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _IntensityMask;
		uniform float _VisualizeMask1;
		uniform float _Brightness;
		uniform float4 _Color;
		uniform float _Saturation;
		uniform float _DetailBrightness;
		uniform float4 _DetailColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform float _DetailSaturation;
		uniform float _UseEmissionFromMainProperties;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _EmissionIntensity;
		uniform samplerCUBE _Cubemap;
		uniform float _UseMainNormalMapasNormalDirection1;
		uniform float _BlurReflection;
		uniform float _ReflectionIntensity;
		uniform float4 _ColorCubemap;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _ScreenGrab0 )
		uniform float _Refraction;
		uniform float _InvertTransparencyMask;
		uniform float _Opacity;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _Metallic;
		uniform float _Metallic2;
		uniform float _Glossiness;
		uniform float _Glossiness2;
		uniform float _UseAoFromMainProperties;
		uniform sampler2D _OcclusionMap;
		uniform float4 _OcclusionMap_ST;
		uniform float _AoIntensity;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 break26_g502 = uv_BumpMap;
			float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
			float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
			float2 appendResult14_g502 = (float2(( break26_g502.x * GlobalTilingX11 ) , ( break26_g502.y * GlobalTilingY8 )));
			float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
			float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
			float2 appendResult13_g502 = (float2(( break26_g502.x + GlobalOffsetX10 ) , ( break26_g502.y + GlobalOffsetY9 )));
			float2 uv_ParallaxMap = i.uv_texcoord * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
			float2 break26_g457 = uv_ParallaxMap;
			float2 appendResult14_g457 = (float2(( break26_g457.x * GlobalTilingX11 ) , ( break26_g457.y * GlobalTilingY8 )));
			float2 appendResult13_g457 = (float2(( break26_g457.x + GlobalOffsetX10 ) , ( break26_g457.y + GlobalOffsetY9 )));
			float4 temp_cast_0 = (tex2D( _ParallaxMap, ( appendResult14_g457 + appendResult13_g457 ) ).g).xxxx;
			float2 paralaxOffset36_g456 = ParallaxOffset( temp_cast_0.x , _Parallax , i.viewDir );
			float2 switchResult47_g456 = (((i.ASEVFace>0)?(paralaxOffset36_g456):(0.0)));
			float2 Parallaxe519 = switchResult47_g456;
			float3 tex2DNode4_g501 = UnpackScaleNormal( tex2D( _BumpMap, ( ( appendResult14_g502 + appendResult13_g502 ) + Parallaxe519 ) ), _BumpScale );
			float3 temp_output_356_0 = tex2DNode4_g501;
			float2 temp_cast_2 = (_TranslationSpeed1).xx;
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float cos54_g499 = cos( radians( _RotationAngle1 ) );
			float sin54_g499 = sin( radians( _RotationAngle1 ) );
			float2 rotator54_g499 = mul( ( uv_DetailNormalMap * _TilingWave1 ) - float2( 0.5,0.5 ) , float2x2( cos54_g499 , -sin54_g499 , sin54_g499 , cos54_g499 )) + float2( 0.5,0.5 );
			float2 panner86_g499 = ( _Time.x * temp_cast_2 + rotator54_g499);
			#ifdef _MAINWAVE_ON
				float3 staticSwitch109_g499 = UnpackScaleNormal( tex2D( _DetailNormalMap, panner86_g499 ), _NormalWaveIntensity1 );
			#else
				float3 staticSwitch109_g499 = float3(0,0,1);
			#endif
			float2 temp_cast_3 = (_TranslationSpeed2).xx;
			float cos83_g499 = cos( radians( _RotationAngle2 ) );
			float sin83_g499 = sin( radians( _RotationAngle2 ) );
			float2 rotator83_g499 = mul( ( uv_DetailNormalMap * _TilingWave2 ) - float2( 0.5,0.5 ) , float2x2( cos83_g499 , -sin83_g499 , sin83_g499 , cos83_g499 )) + float2( 0.5,0.5 );
			float2 panner88_g499 = ( _Time.x * temp_cast_3 + rotator83_g499);
			#ifdef _DETAILWAVE_ON
				float3 staticSwitch56_g499 = BlendNormals( staticSwitch109_g499 , UnpackScaleNormal( tex2D( _DetailNormalMap, panner88_g499 ), _NormalWaveIntensity2 ) );
			#else
				float3 staticSwitch56_g499 = staticSwitch109_g499;
			#endif
			float3 NormalPuddles459 = staticSwitch56_g499;
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float4 tex2DNode27_g934 = tex2D( _DetailMask, uv_DetailMask );
			float4 temp_cast_4 = (( (( _InvertMask )?( ( 1.0 - tex2DNode27_g934.r ) ):( tex2DNode27_g934.r )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
			float4 temp_output_35_0_g934 = CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_4);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 break26_g485 = uv_MainTex;
			float2 appendResult14_g485 = (float2(( break26_g485.x * GlobalTilingX11 ) , ( break26_g485.y * GlobalTilingY8 )));
			float2 appendResult13_g485 = (float2(( break26_g485.x + GlobalOffsetX10 ) , ( break26_g485.y + GlobalOffsetY9 )));
			float4 tex2DNode7_g484 = tex2D( _MainTex, ( ( appendResult14_g485 + appendResult13_g485 ) + Parallaxe519 ) );
			float BaseColorAlpha46 = (( _InvertABaseColor )?( ( 1.0 - tex2DNode7_g484.a ) ):( tex2DNode7_g484.a ));
			float4 clampResult38_g934 = clamp( (( _ExcludeMask )?( ( temp_output_35_0_g934 * ( 1.0 - BaseColorAlpha46 ) ) ):( temp_output_35_0_g934 )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Mask158 = ( clampResult38_g934 * _IntensityMask );
			float3 lerpResult137 = lerp( temp_output_356_0 , NormalPuddles459 , Mask158.rgb);
			float3 lerpResult205 = lerp( temp_output_356_0 , BlendNormals( temp_output_356_0 , NormalPuddles459 ) , Mask158.rgb);
			float3 Normal27 = (( _BlendMainNormal )?( lerpResult205 ):( lerpResult137 ));
			o.Normal = Normal27;
			float clampResult27_g484 = clamp( _Saturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g484 = ( _Color * tex2DNode7_g484 ).rgb;
			float desaturateDot29_g484 = dot( desaturateInitialColor29_g484, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g484 = lerp( desaturateInitialColor29_g484, desaturateDot29_g484.xxx, -clampResult27_g484 );
			float4 temp_output_539_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g484 , 0.0 ));
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float4 tex2DNode7_g503 = tex2D( _DetailAlbedoMap, ( uv_DetailAlbedoMap + ( float2( 0,0 ) * float2( 0,0 ) ) ) );
			float4 BaseColorRGB403 = temp_output_539_0;
			#ifdef _USEMAINBASECOLORMAP_ON
				float4 staticSwitch38_g503 = BaseColorRGB403;
			#else
				float4 staticSwitch38_g503 = tex2DNode7_g503;
			#endif
			float clampResult27_g503 = clamp( _DetailSaturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g503 = ( _DetailColor * staticSwitch38_g503 ).rgb;
			float desaturateDot29_g503 = dot( desaturateInitialColor29_g503, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g503 = lerp( desaturateInitialColor29_g503, desaturateDot29_g503.xxx, -clampResult27_g503 );
			float4 AlbedoDetail153 = CalculateContrast(_DetailBrightness,float4( desaturateVar29_g503 , 0.0 ));
			float4 lerpResult365 = lerp( temp_output_539_0 , AlbedoDetail153 , Mask158);
			float4 Albedo26 = (( _VisualizeMask1 )?( Mask158 ):( lerpResult365 ));
			o.Albedo = Albedo26.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 break26_g505 = uv_EmissionMap;
			float2 appendResult14_g505 = (float2(( break26_g505.x * GlobalTilingX11 ) , ( break26_g505.y * GlobalTilingY8 )));
			float2 appendResult13_g505 = (float2(( break26_g505.x + GlobalOffsetX10 ) , ( break26_g505.y + GlobalOffsetY9 )));
			float4 temp_output_359_0 = ( _EmissionColor * tex2D( _EmissionMap, ( ( appendResult14_g505 + appendResult13_g505 ) + Parallaxe519 ) ) * _EmissionIntensity );
			float4 temp_cast_14 = (0.0).xxxx;
			float4 lerpResult394 = lerp( temp_output_359_0 , temp_cast_14 , Mask158);
			float4 texCUBENode27_g513 = texCUBElod( _Cubemap, float4( normalize( WorldReflectionVector( i , (( _UseMainNormalMapasNormalDirection1 )?( Normal27 ):( NormalPuddles459 )) ) ), _BlurReflection) );
			float clampResult39_g513 = clamp( _ReflectionIntensity , 0.0 , 100.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor502 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_ScreenGrab0,( (ase_grabScreenPosNorm).xyzw + float4( (( mul( float4( normalize( (WorldNormalVector( i , Normal27 )) ) , 0.0 ), UNITY_MATRIX_V ).xyz * (-1.0 + (_Refraction - 0.0) * (1.0 - -1.0) / (2.0 - 0.0)) )).xyz , 0.0 ) ).xy);
			float4 temp_cast_21 = (1.0).xxxx;
			float4 temp_cast_22 = (BaseColorAlpha46).xxxx;
			#if defined(_MASKSELECTION_NONE)
				float4 staticSwitch511 = temp_cast_21;
			#elif defined(_MASKSELECTION_DETAILMASK)
				float4 staticSwitch511 = Mask158;
			#elif defined(_MASKSELECTION_BASECOLORALPHA)
				float4 staticSwitch511 = temp_cast_22;
			#else
				float4 staticSwitch511 = Mask158;
			#endif
			float4 GrabSreenRefraction503 = ( ( screenColor502 * (( _InvertTransparencyMask )?( ( 1.0 - staticSwitch511 ) ):( staticSwitch511 )) ) * _Opacity );
			float4 Emission110 = ( (( _UseEmissionFromMainProperties )?( temp_output_359_0 ):( lerpResult394 )) + ( ( texCUBENode27_g513 * ( texCUBENode27_g513.a * clampResult39_g513 ) * _ColorCubemap ) * Mask158 ) + GrabSreenRefraction503 );
			o.Emission = Emission110.rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float2 break26_g515 = uv_MetallicGlossMap;
			float2 appendResult14_g515 = (float2(( break26_g515.x * GlobalTilingX11 ) , ( break26_g515.y * GlobalTilingY8 )));
			float2 appendResult13_g515 = (float2(( break26_g515.x + GlobalOffsetX10 ) , ( break26_g515.y + GlobalOffsetY9 )));
			float4 tex2DNode3_g514 = tex2D( _MetallicGlossMap, ( ( appendResult14_g515 + appendResult13_g515 ) + Parallaxe519 ) );
			float DetailMetallic381 = _Metallic2;
			float lerpResult382 = lerp( ( tex2DNode3_g514.r * _Metallic ) , DetailMetallic381 , Mask158.r);
			float Metallic41 = lerpResult382;
			o.Metallic = Metallic41;
			#if defined(_SOURCE_METALLICALPHA)
				float staticSwitch23_g514 = ( tex2DNode3_g514.a * _Glossiness );
			#elif defined(_SOURCE_BASECOLORALPHA)
				float staticSwitch23_g514 = ( _Glossiness * BaseColorAlpha46 );
			#else
				float staticSwitch23_g514 = ( tex2DNode3_g514.a * _Glossiness );
			#endif
			float DetailSmoothness374 = _Glossiness2;
			float lerpResult377 = lerp( staticSwitch23_g514 , DetailSmoothness374 , Mask158.r);
			float Smoothness40 = lerpResult377;
			o.Smoothness = Smoothness40;
			float2 uv_OcclusionMap = i.uv_texcoord * _OcclusionMap_ST.xy + _OcclusionMap_ST.zw;
			float2 break26_g507 = uv_OcclusionMap;
			float2 appendResult14_g507 = (float2(( break26_g507.x * GlobalTilingX11 ) , ( break26_g507.y * GlobalTilingY8 )));
			float2 appendResult13_g507 = (float2(( break26_g507.x + GlobalOffsetX10 ) , ( break26_g507.y + GlobalOffsetY9 )));
			float blendOpSrc2_g506 = tex2D( _OcclusionMap, ( ( appendResult14_g507 + appendResult13_g507 ) + Parallaxe519 ) ).r;
			float blendOpDest2_g506 = ( 1.0 - _AoIntensity );
			float temp_output_358_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc2_g506 ) * ( 1.0 - blendOpDest2_g506 ) ) ));
			float lerpResult389 = lerp( temp_output_358_0 , 1.0 , Mask158.r);
			float AmbientOcclusion94 = (( _UseAoFromMainProperties )?( temp_output_358_0 ):( lerpResult389 ));
			o.Occlusion = AmbientOcclusion94;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
}