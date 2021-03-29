cbuffer cbSurfaceColor : register(b0) //Pixel Shader constant buffer slot 0 - matches slot in psBilboard.hlsl
{
	float4 surfaceColor;
}


//cbuffer cbBilboardDimension : register(b1) //Pixel Shader constant buffer slot 1
//{
//	float bilboardDimension;
//	float2 bilboardCenter;
//}

struct PSInput
{
	float4 pos : SV_POSITION;
	float2 tex : TEXCOORD0;
	float2 originalpos : SCRCENT;
};

float4 main(PSInput i) : SV_TARGET
{
	//TODO : 1.32. Calculate billboard pixel color
	float a = 1.0f;
	float d = length(i.originalpos);
	float color_intensity = max(0,1 - d / (0.5 * a));

	return surfaceColor * color_intensity; //Replace with correct implementation
}