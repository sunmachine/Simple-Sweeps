Shader "Custom Mobile/Simple Sweeps (Unlit Transparent)" {

    // OpenGL ES 2.0 Compatible shader, used to animate pulses and shines.
    // Future versions will come with vertex color support.

    // Default Material Properties
    Properties {
        _MainTex ("Texture (RGBA)", 2D) = "white" {}
        _FXMaskTex ("Effect Mask (RGB)", 2D) = "black" {}
        _FX1Tex ("Effect (A)", 2D) = "black" {}
        _FX1Val ("Velocity (xy) and Brightness (z)", Vector) = (1, 1, 1, 0)
        _FX2Tex ("Effect (A)", 2D) = "black" {}
        _FX2Val ("Velocity (xy) and Brightness (z)", Vector) = (1, 1, 1, 0)
        _FX3Tex ("Effect (RGBA)", 2D) = "black" {}
        _FX3Val ("Velocity (xy) and Brightness (z)", Vector) = (1, 1, 1, 0)
    }

    // Single pass, unlit.
    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
        }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back

            CGPROGRAM
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 n3ds wiiu
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma target 2.0
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }

    Fallback "Unlit/Transparent"
	CustomEditor "SimpleSweepsEditor"


    CGINCLUDE

    #include "UnityCG.cginc"

    // MainTex and FXMaskTex use the same UVs.
    uniform sampler2D _MainTex;
    uniform sampler2D _FXMaskTex;
    uniform half4 _MainTex_ST;

    // Texture samples for effect cookies.
    uniform sampler2D _FX1Tex;
    uniform half4 _FX1Tex_ST;
    uniform sampler2D _FX2Tex;
    uniform half4 _FX2Tex_ST;
    uniform sampler2D _FX3Tex;
    uniform half4 _FX3Tex_ST;

    // Individual effect properties.
    uniform half4 _FX1Val;
    uniform half4 _FX2Val;
    uniform half4 _FX3Val;

    struct vertexInput {
        float4 vertex : POSITION;
        float4 texcoord : TEXCOORD0;
    };

    // I get picky with my semantics, and try to cram two UV pairs into each.
    struct vertexOutput {
        float4 pos : SV_POSITION;
        float4 uv : TEXCOORD0;
        float4 uv2 : TEXCOORD1;
    };

    // This snippet composites texture samples, so the vertex program is going to be ligher.
    vertexOutput vert(vertexInput v) {
        vertexOutput o;

        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

        // Main texture atlas UV, with tile & offset.
        o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

        // UV for Effect Textures.
        o.uv.zw = TRANSFORM_TEX(v.texcoord, _FX1Tex);
        o.uv2.xy = TRANSFORM_TEX(v.texcoord, _FX2Tex);
        o.uv2.zw = TRANSFORM_TEX(v.texcoord, _FX3Tex);

        // Define UV animation velocities.
        o.uv.zw += _FX1Val.xy * _Time.y;
        o.uv2.xy += _FX2Val.xy * _Time.y;
        o.uv2.zw += _FX3Val.xy * _Time.y;

        return o;
    }

    // Fragment shader
    fixed4 frag(vertexOutput i) : SV_Target {
        // Set up diffuse sample and effect masks.
        fixed4 mainTex = tex2D(_MainTex, i.uv.xy);
        fixed4 maskTex = tex2D(_FXMaskTex, i.uv.xy);

        // Set up FX texture samples. Each var corresponds to one of the mask's RGB channels.
        fixed3 fx1 = tex2D(_FX1Tex, i.uv.zw).a * mainTex.rgb * maskTex.r * _FX1Val.z;
        fixed3 fx2 = tex2D(_FX2Tex, i.uv2.xy).a * mainTex.rgb * maskTex.g * _FX2Val.z;
        fixed4 fx3 = tex2D(_FX3Tex, i.uv2.zw) * maskTex.b * _FX3Val.z;

        // Saturate alpha, Src * OneMinusSrc, and final composite. 
        mainTex.a += saturate(Luminance(fx1 + fx2) + fx3.a);
        mainTex.rgb *= (1 - fx3.a);
        mainTex.rgb += (fx3.rgb * fx3.a) + fx1 + fx2;

        // Return the result.
        return mainTex;
    }
    ENDCG
}
