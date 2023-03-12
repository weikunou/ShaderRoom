Shader "Custom/WaterWave"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _WaveIntensity("Wave Intensity", Range(0.0, 1.0)) = 0.5  // 波动强度
        _Speed("Speed", Range(0.0, 10.0)) = 0.5                  // 波动速度
        _UVXX("UVXX", Range(0.0, 30.0)) = 30.0                   // UV X 正弦 x 振幅
        _UVXY("UVXY", Range(0.0, 30.0)) = 30.0                   // UV X 正弦 y 振幅
        _UVYX("UVYX", Range(0.0, 30.0)) = 30.0                   // UV Y 正弦 x 振幅
        _UVYY("UVYY", Range(0.0, 30.0)) = 30.0                   // UV Y 正弦 y 振幅
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _WaveIntensity;
            uniform float _Speed;
            uniform float _UVXX;
            uniform float _UVXY;
            uniform float _UVYX;
            uniform float _UVYY;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float2 uv = i.uv;
                uv.x += (sin(uv.x * _UVXX + _Time.y * _Speed) + sin(uv.y * _UVXY + _Time.y * _Speed)) * _WaveIntensity;
                uv.y += (sin(uv.x * _UVYX + _Time.y * _Speed) + sin(uv.y * _UVYY + _Time.y * _Speed)) * _WaveIntensity;
                return tex2D(_MainTex, uv);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}