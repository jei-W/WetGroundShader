Shader "Custom/WetGroundShader_Surf"
{
    Properties
    {
		_MainTex ("MainTexture", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_MainTex2 ("SubTexture", 2D) = "white" {}
		_BumpMap2 ("SubNormalMap", 2D) = "bump" {}
		_BlendTex ("BlendTexture", 2D) = "black" {}
		_WetDegree ("WetDegree", Range(0, 1)) = 0.3 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

		sampler2D _MainTex;
		sampler2D _MainTex2;
		sampler2D _BumpMap;
		sampler2D _BumpMap2;
		sampler2D _BlendTex;
		half _WetDegree;

        struct Input
        {
			float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 blendmapColor = tex2D(_BlendTex, IN.uv_MainTex);

			//각각의 albedo color와 normal color를 blendTexture의 red값에 따라 합쳐준다
			fixed4 c = lerp( tex2D(_MainTex, IN.uv_MainTex), tex2D(_MainTex2, IN.uv_MainTex), blendmapColor.r);
			fixed4 normal = lerp( tex2D(_BumpMap, IN.uv_BumpMap), tex2D(_BumpMap2, IN.uv_BumpMap), blendmapColor.r );

			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(normal);
			o.Smoothness = 0.3 + blendmapColor.g * 0.7 * _WetDegree; // 전체 smoothness=0.3, wetDegree가 1이어도 합해서 1이 넘지 않도록 0.7을 곱해준다.
        }
        ENDCG
    }
    FallBack "Diffuse"
}
