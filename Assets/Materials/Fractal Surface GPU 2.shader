Shader "Fractal/Fractal Surface GPU2"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _BaseColor ("BaseColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_Smoothness ("Smoothness", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            // Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
            #pragma exclude_renderers gles
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma instancing_options procedural:setup
            #pragma multi_compile_instancing
            #pragma editor_sync_compilation
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _BaseColor;
    
// TEXTURE2D(_MainTex); 
// SAMPLER(sampler_MainTex);

// UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
//         UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
//         UNITY_DEFINE_INSTANCED_PROP (float4, _BaseColor)
//         UNITY_DEFINE_INSTANCED_PROP (float, _Smoothness)
// UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)
          #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
               StructuredBuffer<float3x4> _Matrices;
           #endif

            void setup()
            {
                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                    float3x4 m = _Matrices[unity_InstanceID];
                    unity_ObjectToWorld._m00_m01_m02_m03 = m._m00_m01_m02_m03;
                    unity_ObjectToWorld._m10_m11_m12_m13 = m._m10_m11_m12_m13;
                    unity_ObjectToWorld._m20_m21_m22_m23 = m._m20_m21_m22_m23;
                    unity_ObjectToWorld._m30_m31_m32_m33 = float4(0.0, 0.0, 0.0, 1.0);

                #endif
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            v2f vert (appdata v)
            {
                v2f o;
                 UNITY_SETUP_INSTANCE_ID(v);
	             UNITY_TRANSFER_INSTANCE_ID(v, o);
            
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal  = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                 UNITY_SETUP_INSTANCE_ID(i);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
                 fixed Ndol =  dot(i.worldNormal, worldLightDir);
                // sample the texture
               // fixed4 col =UNITY_ACCESS_INSTANCED_PROP( UnityPerMaterial, _BaseColor); 
               fixed4 col =_BaseColor*Ndol;
              // col.rgb*=i.worldPos.rgb;
                return col;
            }
            ENDCG
        }
    }
}