shader_type canvas_item;

uniform sampler2D noise;
uniform sampler2D gradient;

uniform float speed = 0.2;
uniform float scale = 1.0;
uniform float scale2 = 0.1;

uniform float pixelation : hint_range(0,180,1) = 128.0;

void fragment()
{
	
	vec2 uv = vec2(UV.x, UV.y);
	
	//1. Create noise texture
	vec4 originalTex = texture(noise, uv);
	
	//The += is to avoid repetition after a while
	uv.x = uv.x+TIME*speed;
	uv.y = uv.y+TIME*speed;
	vec4 noiseTex1 = texture(noise, uv);
	
	//3. Animate UVs
	vec2 uv2 = uv* vec2(scale);
	uv2.x = uv2.x-TIME*speed;
	uv2.y = uv2.y-TIME*speed;
	vec4 noiseTex2 = texture(noise, uv2);
	
	//4. Duplicate, Reverse, Add
	vec4 added = (noiseTex1 + noiseTex2);
	
	//5. Add Original Noise
	vec4 final = (added + originalTex);
	
	//6. Plug that into the UV Offset of the original noise
	vec2 uv3 = uv * final.r * scale2;
	final = texture(noise, uv3);
	
	//7. Multiply with the animated noise of before
	final = final * added;
	
	//8. Gradient, I had to search for this line
	//https://www.youtube.com/watch?v=i7VljTl4I3w 11:00
	vec4 sampled_color = texture(gradient,vec2(final.r,0.0)).rgba;
	
	COLOR.rgba = sampled_color;
}