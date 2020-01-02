Shader "Explorer/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // first two numbers are center of area, second two - size of area
        _Area("Area", vector) = (0, 0, 4 ,4)
        _Angle("Ange", range(-3.1415, 3.1415)) = 0
        _MaxIter("Max Iterations", range(0, 255)) = 255
        _Color("Color", range(0,1)) = 0.5
        _Repeat("Repeat", float) =  1
        _Speed("Speed", range(0, 1)) = 0.1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            float _Angle;
            float _Color;
            float _Repeat;
            float _Speed;
            int _MaxIter;
            sampler2D _MainTex;

            float2 rot(float2 p, float2 pivot, float a) {
                float s = sin(a);
                float c = cos(a);
                p -= pivot;
                p = float2(p.x*c-p.y*s, p.x*s+p.y*c);
                p += pivot;

                return p;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = _Area.xy + (i.uv - 0.5) * _Area.zw;
                c = rot(c, _Area.xy, _Angle);
                // track pixel jumping across screen
                float2 z; 
                // escape radius
                float r = 20;
                float r2 = r*r;
                // track current iteration
                float iter;
                for (iter = 0; iter < _MaxIter; iter++) {
                    // update z based on previous z value and add original starting position
                    z = float2(z.x*z.x-z.y*z.y, 2*z.x*z.y) + c;
                    if (length(z) > r) {
                        break;
                    }
                }
                
             //float dist  = length(z); //distance from origin
             //float fracIter  = log2(log(dist) / log(r));
             //iter -= fracIter;
             //if (iter > _MaxIter) {
             //    return 0;
             //}
                float m = sqrt(iter / _MaxIter);
               //float col = tex2D(_MainTex, float2(m * _Repeat * _Time.y * _Speed, _Color));
               //return col;
                return m;
            }
            ENDCG
        }
    }
}
