Shader "Ciconia Studio/CS_Wet Animation/Builtin/Rainy Puddles/Pro"
{
	Properties
	{
		[Space(35)][Header(Main Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalXYTilingXYZWOffsetXY("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		_Color("Color ", Color) = (1,1,1,0)
		[Toggle]_InvertABaseColor("Invert Alpha", Float) = 0
		_MainTex("Base Color  -->(Mask A)", 2D) = "white" {}
		_Saturation("Saturation", Float) = 0
		_Brightness("Brightness", Range( 1 , 8)) = 1
		[Space(35)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Intensity", Float) = 0.3
		[Space(35)]_MetallicGlossMapMAHS("Mask Map  -->M(R) - Ao(G) - H(B) - S(A)", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0
		_Glossiness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(15)]_Parallax("Height Scale", Range( -0.1 , 0.1)) = 0
		_AoIntensity("Ao Intensity", Range( 0 , 2)) = 0
		[HDR][Space(45)]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionIntensity("Intensity", Range( 0 , 2)) = 1
		[Space(35)][Header(Rain Dots Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GradientTex("Gradient Tex", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0
		_Tiling("Tiling", Float) = 100
		_SplashSpeed("Splash Speed", Range( 0 , 1)) = 0.1
		_Size("Size", Range( 0 , 1)) = 0.5
		[Space(35)][Header(Mask Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)][Toggle]_VisualizeMask("Visualize Mask", Float) = 0
		[Toggle]_ExcludeMask("Exclude - Use BaseColorAlpha", Float) = 0
		[Space(15)][Toggle]_InvertMask("Invert Mask", Float) = 0
		_DetailMask("Detail Mask", 2D) = "black" {}
		_IntensityMask("Intensity", Range( 0 , 1)) = 1
		[Space(15)]_ContrastDetailMap("Contrast", Float) = 0
		_SpreadDetailMap("Spread", Range( 0 , 1)) = 0.5
		[Space(35)][Header(Reflection Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________) ][Space(15)]_ColorCubemap("Color ", Color) = (1,1,1,1)
		[HDR]_Cubemap("Cubemap", CUBE) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Space(10)]_ReflectionIntensity("Intensity", Range( 0 , 10)) = 0.2
		_BlurReflection("Blur", Range( 0 , 7)) = 0.5
		[Toggle]_UseMainNormalMapasNormalDirection("Use Main Normal Map as Normal Direction", Float) = 1
		[Space(35)][Header(Puddle Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_DetailColor("Color", Color) = (0.5019608,0.5019608,0.5019608,0)
		[Toggle(_USEMAINBASECOLORMAP_ON)] _UseMainBaseColorMap("Use Main BaseColor Map", Float) = 1
		_DetailAlbedoMap("Base Color", 2D) = "white" {}
		_DetailSaturation("Saturation", Float) = 0
		_DetailBrightness("Brightness", Range( 1 , 8)) = 1
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
		_Glossiness2("Roughness", Range( 0 , 2)) = 0.95
		[Space(35)][Header(Rain Ripples Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_XColumnsYRowsZSpeedWStrartFrameNormal("X(Columns) - Y(Rows) - Z(Speed) - W(Strart Frame)", Vector) = (8,8,0.25,0)
		_TextureAtlasNormal("Texture Atlas Normal", 2D) = "bump" {}
		_FlipBTilingNormal("FlipBook Tiling", Float) = 1
		_IntensityScaleNormal1("Intensity", Range( 0 , 1)) = 0.4
		[Space(35)][Toggle]_DuplicateTextureAtlasNormal("Duplicate Texture Atlas", Float) = 1
		_IntensityScaleNormal2("Intensity", Range( 0 , 1)) = 0.3
		_ScaleFBDetailsNormal("Scale", Float) = 1
		_FBDetailsNormal("Rotate Details", Float) = 45
		_OffsetFBDetailsNormal("Offset XY", Vector) = (1.5,1.5,0,0)
		[Space(10)]_Distortion("Distortion", Range( 0 , 1)) = 0
		[Space(15)][Toggle]_UseAoFromMainProperties("Use Ao From Main Properties", Float) = 1
		[Toggle]_UseEmissionFromMainProperties("Use Emission From Main Properties", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
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
		};

		uniform float _BlendMainNormal;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float4 _GlobalXYTilingXYZWOffsetXY;
		uniform sampler2D _MetallicGlossMapMAHS;
		uniform float4 _MetallicGlossMapMAHS_ST;
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
		uniform float _DuplicateTextureAtlasNormal;
		uniform sampler2D _TextureAtlasNormal;
		uniform float _FlipBTilingNormal;
		uniform float4 _XColumnsYRowsZSpeedWStrartFrameNormal;
		uniform float _IntensityScaleNormal1;
		uniform float _ScaleFBDetailsNormal;
		uniform float2 _OffsetFBDetailsNormal;
		uniform float _FBDetailsNormal;
		uniform float _IntensityScaleNormal2;
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
		uniform float _VisualizeMask;
		uniform float _Brightness;
		uniform float4 _Color;
		uniform float _Saturation;
		uniform float _DetailBrightness;
		uniform float4 _DetailColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform float _Distortion;
		uniform float _DetailSaturation;
		uniform float _UseEmissionFromMainProperties;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _EmissionIntensity;
		uniform samplerCUBE _Cubemap;
		uniform float _UseMainNormalMapasNormalDirection;
		uniform float _BlurReflection;
		uniform float _ReflectionIntensity;
		uniform float4 _ColorCubemap;
		uniform float _Metallic;
		uniform float _Metallic2;
		uniform float _Glossiness;
		uniform sampler2D _GradientTex;
		uniform float _SplashSpeed;
		uniform float _Tiling;
		uniform float _Size;
		uniform float _Intensity;
		uniform float _Glossiness2;
		uniform float _UseAoFromMainProperties;
		uniform float _AoIntensity;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float2 voronoihash58_g923( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi58_g923( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash58_g923( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 break26_g922 = uv_BumpMap;
			float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
			float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
			float2 appendResult14_g922 = (float2(( break26_g922.x * GlobalTilingX11 ) , ( break26_g922.y * GlobalTilingY8 )));
			float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
			float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
			float2 appendResult13_g922 = (float2(( break26_g922.x + GlobalOffsetX10 ) , ( break26_g922.y + GlobalOffsetY9 )));
			float2 uv_MetallicGlossMapMAHS = i.uv_texcoord * _MetallicGlossMapMAHS_ST.xy + _MetallicGlossMapMAHS_ST.zw;
			float2 break26_g894 = uv_MetallicGlossMapMAHS;
			float2 appendResult14_g894 = (float2(( break26_g894.x * GlobalTilingX11 ) , ( break26_g894.y * GlobalTilingY8 )));
			float2 appendResult13_g894 = (float2(( break26_g894.x + GlobalOffsetX10 ) , ( break26_g894.y + GlobalOffsetY9 )));
			float4 tex2DNode3_g893 = tex2D( _MetallicGlossMapMAHS, ( ( appendResult14_g894 + appendResult13_g894 ) + float2( 0,0 ) ) );
			float2 paralaxOffset38_g893 = ParallaxOffset( tex2DNode3_g893.b , _Parallax , i.viewDir );
			float2 switchResult37_g893 = (((i.ASEVFace>0)?(paralaxOffset38_g893):(0.0)));
			float2 Parallaxe494 = switchResult37_g893;
			float3 tex2DNode4_g921 = UnpackScaleNormal( tex2D( _BumpMap, ( ( appendResult14_g922 + appendResult13_g922 ) + Parallaxe494 ) ), _BumpScale );
			float3 temp_output_495_0 = tex2DNode4_g921;
			float2 temp_cast_0 = (_TranslationSpeed1).xx;
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float cos54_g919 = cos( radians( _RotationAngle1 ) );
			float sin54_g919 = sin( radians( _RotationAngle1 ) );
			float2 rotator54_g919 = mul( ( uv_DetailNormalMap * _TilingWave1 ) - float2( 0.5,0.5 ) , float2x2( cos54_g919 , -sin54_g919 , sin54_g919 , cos54_g919 )) + float2( 0.5,0.5 );
			float2 panner86_g919 = ( _Time.x * temp_cast_0 + rotator54_g919);
			#ifdef _MAINWAVE_ON
				float3 staticSwitch109_g919 = UnpackScaleNormal( tex2D( _DetailNormalMap, panner86_g919 ), _NormalWaveIntensity1 );
			#else
				float3 staticSwitch109_g919 = float3(0,0,1);
			#endif
			float2 temp_cast_1 = (_TranslationSpeed2).xx;
			float cos83_g919 = cos( radians( _RotationAngle2 ) );
			float sin83_g919 = sin( radians( _RotationAngle2 ) );
			float2 rotator83_g919 = mul( ( uv_DetailNormalMap * _TilingWave2 ) - float2( 0.5,0.5 ) , float2x2( cos83_g919 , -sin83_g919 , sin83_g919 , cos83_g919 )) + float2( 0.5,0.5 );
			float2 panner88_g919 = ( _Time.x * temp_cast_1 + rotator83_g919);
			#ifdef _DETAILWAVE_ON
				float3 staticSwitch56_g919 = BlendNormals( staticSwitch109_g919 , UnpackScaleNormal( tex2D( _DetailNormalMap, panner88_g919 ), _NormalWaveIntensity2 ) );
			#else
				float3 staticSwitch56_g919 = staticSwitch109_g919;
			#endif
			float3 NormalPuddles459 = staticSwitch56_g919;
			float FlipBookTiling100_g918 = _FlipBTilingNormal;
			float2 temp_cast_2 = (FlipBookTiling100_g918).xx;
			float2 uv_TexCoord114_g918 = i.uv_texcoord * temp_cast_2;
			float2 appendResult124_g918 = (float2(frac( uv_TexCoord114_g918.x ) , frac( uv_TexCoord114_g918.y )));
			float XColumns119_g918 = _XColumnsYRowsZSpeedWStrartFrameNormal.x;
			float YRows118_g918 = _XColumnsYRowsZSpeedWStrartFrameNormal.y;
			float ZSpeed121_g918 = ( ( _XColumnsYRowsZSpeedWStrartFrameNormal.x * _XColumnsYRowsZSpeedWStrartFrameNormal.y ) * _XColumnsYRowsZSpeedWStrartFrameNormal.z );
			float WStrartFrame122_g918 = _XColumnsYRowsZSpeedWStrartFrameNormal.w;
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles130_g918 = XColumns119_g918 * YRows118_g918;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset130_g918 = 1.0f / XColumns119_g918;
			float fbrowsoffset130_g918 = 1.0f / YRows118_g918;
			// Speed of animation
			float fbspeed130_g918 = _Time[ 1 ] * ZSpeed121_g918;
			// UV Tiling (col and row offset)
			float2 fbtiling130_g918 = float2(fbcolsoffset130_g918, fbrowsoffset130_g918);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex130_g918 = round( fmod( fbspeed130_g918 + WStrartFrame122_g918, fbtotaltiles130_g918) );
			fbcurrenttileindex130_g918 += ( fbcurrenttileindex130_g918 < 0) ? fbtotaltiles130_g918 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox130_g918 = round ( fmod ( fbcurrenttileindex130_g918, XColumns119_g918 ) );
			// Multiply Offset X by coloffset
			float fboffsetx130_g918 = fblinearindextox130_g918 * fbcolsoffset130_g918;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy130_g918 = round( fmod( ( fbcurrenttileindex130_g918 - fblinearindextox130_g918 ) / XColumns119_g918, YRows118_g918 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy130_g918 = (int)(YRows118_g918-1) - fblinearindextoy130_g918;
			// Multiply Offset Y by rowoffset
			float fboffsety130_g918 = fblinearindextoy130_g918 * fbrowsoffset130_g918;
			// UV Offset
			float2 fboffset130_g918 = float2(fboffsetx130_g918, fboffsety130_g918);
			// Flipbook UV
			half2 fbuv130_g918 = appendResult124_g918 * fbtiling130_g918 + fboffset130_g918;
			// *** END Flipbook UV Animation vars ***
			float3 tex2DNode132_g918 = UnpackScaleNormal( tex2D( _TextureAtlasNormal, fbuv130_g918 ), _IntensityScaleNormal1 );
			float2 temp_cast_3 = (( FlipBookTiling100_g918 / _ScaleFBDetailsNormal )).xx;
			float2 uv_TexCoord105_g918 = i.uv_texcoord * temp_cast_3 + _OffsetFBDetailsNormal;
			float cos111_g918 = cos( _FBDetailsNormal );
			float sin111_g918 = sin( _FBDetailsNormal );
			float2 rotator111_g918 = mul( uv_TexCoord105_g918 - float2( 0.5,0.5 ) , float2x2( cos111_g918 , -sin111_g918 , sin111_g918 , cos111_g918 )) + float2( 0.5,0.5 );
			float2 break112_g918 = rotator111_g918;
			float2 appendResult123_g918 = (float2(frac( break112_g918.x ) , frac( break112_g918.y )));
			float fbtotaltiles129_g918 = XColumns119_g918 * YRows118_g918;
			float fbcolsoffset129_g918 = 1.0f / XColumns119_g918;
			float fbrowsoffset129_g918 = 1.0f / YRows118_g918;
			float fbspeed129_g918 = _Time[ 1 ] * ZSpeed121_g918;
			float2 fbtiling129_g918 = float2(fbcolsoffset129_g918, fbrowsoffset129_g918);
			float fbcurrenttileindex129_g918 = round( fmod( fbspeed129_g918 + WStrartFrame122_g918, fbtotaltiles129_g918) );
			fbcurrenttileindex129_g918 += ( fbcurrenttileindex129_g918 < 0) ? fbtotaltiles129_g918 : 0;
			float fblinearindextox129_g918 = round ( fmod ( fbcurrenttileindex129_g918, XColumns119_g918 ) );
			float fboffsetx129_g918 = fblinearindextox129_g918 * fbcolsoffset129_g918;
			float fblinearindextoy129_g918 = round( fmod( ( fbcurrenttileindex129_g918 - fblinearindextox129_g918 ) / XColumns119_g918, YRows118_g918 ) );
			fblinearindextoy129_g918 = (int)(YRows118_g918-1) - fblinearindextoy129_g918;
			float fboffsety129_g918 = fblinearindextoy129_g918 * fbrowsoffset129_g918;
			float2 fboffset129_g918 = float2(fboffsetx129_g918, fboffsety129_g918);
			half2 fbuv129_g918 = appendResult123_g918 * fbtiling129_g918 + fboffset129_g918;
			float3 RainDotsNormal739 = (( _DuplicateTextureAtlasNormal )?( BlendNormals( tex2DNode132_g918 , UnpackScaleNormal( tex2D( _TextureAtlasNormal, fbuv129_g918 ), _IntensityScaleNormal2 ) ) ):( tex2DNode132_g918 ));
			float3 temp_output_740_0 = BlendNormals( NormalPuddles459 , RainDotsNormal739 );
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float4 tex2DNode27_g934 = tex2D( _DetailMask, uv_DetailMask );
			float4 temp_cast_4 = (( (( _InvertMask )?( ( 1.0 - tex2DNode27_g934.r ) ):( tex2DNode27_g934.r )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
			float4 temp_output_35_0_g934 = CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_4);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 break26_g917 = uv_MainTex;
			float2 appendResult14_g917 = (float2(( break26_g917.x * GlobalTilingX11 ) , ( break26_g917.y * GlobalTilingY8 )));
			float2 appendResult13_g917 = (float2(( break26_g917.x + GlobalOffsetX10 ) , ( break26_g917.y + GlobalOffsetY9 )));
			float4 tex2DNode7_g916 = tex2D( _MainTex, ( ( appendResult14_g917 + appendResult13_g917 ) + Parallaxe494 ) );
			float BaseColorAlpha46 = (( _InvertABaseColor )?( ( 1.0 - tex2DNode7_g916.a ) ):( tex2DNode7_g916.a ));
			float4 clampResult38_g934 = clamp( (( _ExcludeMask )?( ( temp_output_35_0_g934 * ( 1.0 - BaseColorAlpha46 ) ) ):( temp_output_35_0_g934 )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Mask158 = ( clampResult38_g934 * _IntensityMask );
			float3 lerpResult137 = lerp( temp_output_495_0 , temp_output_740_0 , Mask158.rgb);
			float3 lerpResult205 = lerp( temp_output_495_0 , BlendNormals( temp_output_495_0 , temp_output_740_0 ) , Mask158.rgb);
			float3 Normal27 = (( _BlendMainNormal )?( lerpResult205 ):( lerpResult137 ));
			o.Normal = Normal27;
			float clampResult27_g916 = clamp( _Saturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g916 = ( _Color * tex2DNode7_g916 ).rgb;
			float desaturateDot29_g916 = dot( desaturateInitialColor29_g916, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g916 = lerp( desaturateInitialColor29_g916, desaturateDot29_g916.xxx, -clampResult27_g916 );
			float4 temp_output_836_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g916 , 0.0 ));
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float lerpResult777 = lerp( 0.0 , 0.9 , _Distortion);
			float2 temp_cast_10 = (lerpResult777).xx;
			float4 tex2DNode7_g924 = tex2D( _DetailAlbedoMap, ( uv_DetailAlbedoMap + ( RainDotsNormal739.xy * temp_cast_10 ) ) );
			float4 BaseColorRGB403 = temp_output_836_0;
			#ifdef _USEMAINBASECOLORMAP_ON
				float4 staticSwitch38_g924 = BaseColorRGB403;
			#else
				float4 staticSwitch38_g924 = tex2DNode7_g924;
			#endif
			float clampResult27_g924 = clamp( _DetailSaturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g924 = ( _DetailColor * staticSwitch38_g924 ).rgb;
			float desaturateDot29_g924 = dot( desaturateInitialColor29_g924, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g924 = lerp( desaturateInitialColor29_g924, desaturateDot29_g924.xxx, -clampResult27_g924 );
			float4 AlbedoDetail153 = CalculateContrast(_DetailBrightness,float4( desaturateVar29_g924 , 0.0 ));
			float4 lerpResult365 = lerp( temp_output_836_0 , AlbedoDetail153 , Mask158);
			float4 Albedo26 = (( _VisualizeMask )?( Mask158 ):( lerpResult365 ));
			o.Albedo = Albedo26.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 break26_g926 = uv_EmissionMap;
			float2 appendResult14_g926 = (float2(( break26_g926.x * GlobalTilingX11 ) , ( break26_g926.y * GlobalTilingY8 )));
			float2 appendResult13_g926 = (float2(( break26_g926.x + GlobalOffsetX10 ) , ( break26_g926.y + GlobalOffsetY9 )));
			float4 temp_output_503_0 = ( _EmissionColor * tex2D( _EmissionMap, ( ( appendResult14_g926 + appendResult13_g926 ) + Parallaxe494 ) ) * _EmissionIntensity );
			float4 temp_cast_16 = (0.0).xxxx;
			float4 lerpResult394 = lerp( temp_output_503_0 , temp_cast_16 , Mask158);
			float4 texCUBENode27_g927 = texCUBElod( _Cubemap, float4( normalize( WorldReflectionVector( i , (( _UseMainNormalMapasNormalDirection )?( Normal27 ):( NormalPuddles459 )) ) ), _BlurReflection) );
			float clampResult39_g927 = clamp( _ReflectionIntensity , 0.0 , 100.0 );
			float4 Emission110 = ( (( _UseEmissionFromMainProperties )?( temp_output_503_0 ):( lerpResult394 )) + ( ( texCUBENode27_g927 * ( texCUBENode27_g927.a * clampResult39_g927 ) * _ColorCubemap ) * Mask158 ) );
			o.Emission = Emission110.rgb;
			float DetailMetallic381 = _Metallic2;
			float lerpResult382 = lerp( ( tex2DNode3_g893.r * _Metallic ) , DetailMetallic381 , Mask158.r);
			float Metallic41 = lerpResult382;
			o.Metallic = Metallic41;
			float temp_output_1_0_g893 = ( tex2DNode3_g893.a * _Glossiness );
			float2 temp_cast_21 = (_SplashSpeed).xx;
			float time58_g923 = ( 1.0 * 0.001 );
			float2 voronoiSmoothId0 = 0;
			float2 coords58_g923 = float4( i.uv_texcoord, 0.0 , 0.0 ).xy * _Tiling;
			float2 id58_g923 = 0;
			float2 uv58_g923 = 0;
			float fade58_g923 = 0.5;
			float voroi58_g923 = 0;
			float rest58_g923 = 0;
			for( int it58_g923 = 0; it58_g923 <2; it58_g923++ ){
			voroi58_g923 += fade58_g923 * voronoi58_g923( coords58_g923, time58_g923, id58_g923, uv58_g923, 0,voronoiSmoothId0 );
			rest58_g923 += fade58_g923;
			coords58_g923 *= 2;
			fade58_g923 *= 0.5;
			}//Voronoi58_g923
			voroi58_g923 /= rest58_g923;
			float2 myVarName60_g923 = id58_g923;
			float2 panner63_g923 = ( 1.0 * _Time.y * temp_cast_21 + ( step( voroi58_g923 , 0.1 ) * myVarName60_g923 ));
			float RainDotsRoughness606 = ( saturate( ( tex2D( _GradientTex, panner63_g923 ).g * step( voroi58_g923 , (0.0 + (_Size - 0.0) * (0.05 - 0.0) / (1.0 - 0.0)) ) ) ) * _Intensity );
			float DetailSmoothness374 = _Glossiness2;
			float lerpResult377 = lerp( ( ( temp_output_1_0_g893 * ( 1.0 - RainDotsRoughness606 ) ) + RainDotsRoughness606 ) , DetailSmoothness374 , Mask158.r);
			float Smoothness40 = lerpResult377;
			o.Smoothness = Smoothness40;
			float blendOpSrc34_g893 = tex2DNode3_g893.g;
			float blendOpDest34_g893 = ( 1.0 - _AoIntensity );
			float AoG822 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc34_g893 ) * ( 1.0 - blendOpDest34_g893 ) ) ));
			float lerpResult389 = lerp( AoG822 , 1.0 , Mask158.r);
			float AmbientOcclusion94 = (( _UseAoFromMainProperties )?( AoG822 ):( lerpResult389 ));
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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