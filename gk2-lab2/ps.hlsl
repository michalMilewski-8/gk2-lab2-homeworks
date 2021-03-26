struct Light
{
	float4 position;
	float4 color;
};

struct Lighting
{
	float4 ambient;
	float4 surface;
	Light lights[3];
};

cbuffer cbSurfaceColor : register(b0) //Pixel Shader constant buffer slot 0 - matches slot in psBilboard.hlsl
{
	float4 surfaceColor;
}

cbuffer cbLighting : register(b1) //Pixel Shader constant buffer slot 1
{
	Lighting lighting;
}

//TODO : 0.8. Modify pixel shader input structure to match vertex shader output
struct PSInput
{
	float4 pos : SV_POSITION;
	float3 worldPos : POSITION0;
	float3 norm : NORMAL;
	float3 view : VIEW;
	//float4 col : COLOR; // Remove once no longer used
};

float4 main(PSInput ik) : SV_TARGET
{
	//TODO : 0.9. Calculate output color using Phong Illumination Model

	float3 norm = normalize(ik.norm);
	float3 view = normalize(ik.view);

	float3 color3 = lighting.ambient.xyz * lighting.surface.x;
	float specAlpha = 0.0f;
	for (int i = 0; i < 3; i++) {
		Light l = lighting.lights[i];
		if (l.color.w != 0) {
			float3 lightVec = normalize(l.position.xyz - ik.worldPos);
			float3 halfVec = normalize(view + lightVec);
			color3 += l.color.xyz * surfaceColor.xyz * lighting.surface.y * clamp(dot(norm, lightVec), 0.0f, 1.0f);
			float nh = dot(norm, halfVec);
			nh = clamp(nh, 0.0f, 1.0f);
			nh = pow(nh, lighting.surface.w);
			nh *= lighting.surface.z;
			specAlpha += nh;
			color3 += l.color.xyz * nh;
		}
	}

	//float4 L1 = normalize(lighting.lights[0].position - i.pos);
	//float4 L2 = normalize(lighting.lights[1].position - i.pos);
	//float4 L3 = normalize(lighting.lights[2].position - i.pos);

	//float L1N = dot(norm, L1);
	//float L2N = dot(norm, L2);
	//float L3N = dot(norm, L3);




	//color = lighting.ambient * lighting.surface.x +
	//	lighting.lights[0].color * L1N * lighting.surface.y * surfaceColor + lighting.surface.z * pow(dot(norm, (L1 + i.view) / 2), lighting.surface.w) * lighting.lights[0].color +
	//	lighting.lights[1].color * L2N * lighting.surface.y * surfaceColor + lighting.surface.z * pow(dot(norm, (L2 + i.view) / 2), lighting.surface.w) * lighting.lights[1].color +
	//	lighting.lights[2].color * L3N * lighting.surface.y * surfaceColor + lighting.surface.z * pow(dot(norm, (L3 + i.view) / 2), lighting.surface.w) * lighting.lights[2].color;

	return saturate(float4(color3, surfaceColor.w + specAlpha)); // Replace with correct implementation
}