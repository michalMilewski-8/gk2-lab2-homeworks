cbuffer cbWorld : register(b0) //Vertex Shader constant buffer slot 0 - matches slot in vsBilboard.hlsl
{
	matrix worldMatrix;
};

cbuffer cbView : register(b1) //Vertex Shader constant buffer slot 1 - matches slot in vsBilboard.hlsl
{
	matrix viewMatrix;
	matrix invViewMatrix;
};

cbuffer cbProj : register(b2) //Vertex Shader constant buffer slot 2 - matches slot in vsBilboard.hlsl
{
	matrix projMatrix;
};

struct PSInput
{
	float4 pos : SV_POSITION;
	float2 tex : TEXCOORD0;
	float2 originalpos : SCRCENT;
};

PSInput main( float3 pos : POSITION )
{
	PSInput o;
	
	matrix modelView = mul(viewMatrix, worldMatrix);

	modelView[0][0] = 1.0;
	modelView[0][1] = 0.0;
	modelView[0][2] = 0.0;

	// Second colunm.
	modelView[1][0] = 0.0;
	modelView[1][1] = 1.0;
	modelView[1][2] = 0.0;

	// Thrid colunm.
	modelView[2][0] = 0.0;
	modelView[2][1] = 0.0;
	modelView[2][2] = 1.0;


	//TODO : 1.31. Calculate on-screen position of billboard vertex
	o.tex = pos.xy;
	o.originalpos = pos.xy;
	o.pos = mul(projMatrix, mul(modelView,float4(pos, 1.0f)));
	return o;
}

//
//cbuffer cbWorld : register(b0) //Vertex Shader constant buffer slot 0
//{
//	matrix worldMatrix;
//};
//
//cbuffer cbView : register(b1) //Vertex Shader constant buffer slot 1
//{
//	matrix viewMatrix;
//	matrix invViewMatrix;
//};
//
//cbuffer cbProj : register(b2) //Vertex Shader constant buffer slot 2
//{
//	matrix projMatrix;
//};
//
//struct PSInput
//{
//	float4 pos : SV_POSITION;
//	float2 tex : TEXCOORD0;
//	float2 screenPos : SCREENPOS;
//};
//
//PSInput main( float3 pos : POSITION )
//{
//	PSInput o;
//	
//	matrix modelView = mul(worldMatrix, viewMatrix);
//
//	modelView[0][0] = 1.0;
//	modelView[0][1] = 0.0;
//	modelView[0][2] = 0.0;
//
//	// Second colunm.
//	modelView[1][0] = 0.0;
//	modelView[1][1] = 1.0;
//	modelView[1][2] = 0.0;
//
//	// Thrid colunm.
//	modelView[2][0] = 0.0;
//	modelView[2][1] = 0.0;
//	modelView[2][2] = 1.0;
//
//	//TODO : 1.31. Calculate on-screen position of billboard vertex
//	float4 camPos = mul(modelView, float4(pos, 1.0f));
//	float4 screenPos = mul(projMatrix, camPos);
//	screenPos /= screenPos.w;
//	o.screenPos = screenPos.xy;
//	o.tex = pos.xy;
//	o.pos = mul(screenPos, float4(pos, 1.0f));
//	return o;
//}