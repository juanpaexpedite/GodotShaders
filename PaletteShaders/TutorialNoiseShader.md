# 1.- Create noise texture

```
shader_type canvas_item;
uniform sampler2D noise;
void fragment()
{
	vec2 uv = UV;
	vec4 noiseTex = texture(noise, uv);
	COLOR = noiseTex;
}
```

# 2.- Scale really big

```
void fragment()
{
	vec2 uv = UV* vec2(0.25,0.25);
	vec4 noiseTex = texture(noise, uv);
	COLOR = noiseTex;
}
```

# 3.- Animate UVs

```
void fragment()
{
	vec2 uv = UV* vec2(0.25,0.25);
	uv.x = uv.x-TIME*0.1;
	uv.y = uv.y+TIME*0.1;
	vec4 noiseTex1 = texture(noise, uv);
	COLOR = noiseTex1;
}
```
# 4.- Duplicate, Reverse, Add

```
void fragment()
{
	vec2 uv = UV* vec2(0.25,0.25);
	uv.x = uv.x-TIME*0.1;
	uv.y = uv.y+TIME*0.1;
	vec4 noiseTex1 = texture(noise, uv);
	
	vec2 uv2 = UV* vec2(0.25,0.25);
	uv2.x = uv2.x+TIME*0.1;
	uv2.y = uv2.y-TIME*0.1;
	vec4 noiseTex2 = texture(noise, uv2);
	
	vec4 final = (noiseTex1 + noiseTex2) * 0.5;
	
	COLOR = final;
}
```
# 5.- Add Original Noise
```
void fragment()
{
	vec4 originalTex = texture(noise, UV);
	
	vec2 uv = UV* vec2(0.25,0.25);
	uv.x = uv.x-TIME*0.1;
	uv.y = uv.y+TIME*0.1;
	vec4 noiseTex1 = texture(noise, uv);
	
	vec2 uv2 = UV* vec2(0.25,0.25);
	uv2.x = uv2.x+TIME*0.1;
	uv2.y = uv2.y-TIME*0.1;
	vec4 noiseTex2 = texture(noise, uv2);
	
	vec4 final = (noiseTex1 + noiseTex2) * 0.5;
	final = (final + originalTex) * 0.5;
	
	COLOR = final;
}
```
# 6.- Plug that into the UV Offset of the original noise
```
void fragment()
{
	vec4 originalTex = texture(noise, UV);
	
	vec2 uv = UV* vec2(0.25,0.25);
	uv.x = uv.x-TIME*0.1;
	uv.y = uv.y+TIME*0.1;
	vec4 noiseTex1 = texture(noise, uv);
	
	vec2 uv2 = UV* vec2(0.25,0.25);
	uv2.x = uv2.x+TIME*0.1;
	uv2.y = uv2.y-TIME*0.1;
	vec4 noiseTex2 = texture(noise, uv2);
	
	vec4 final = (noiseTex1 + noiseTex2) * 0.5;
	final = (final + originalTex) * 0.5;
	
	vec2 uv3 = uv * final.r * 0.01;
	final = texture(noise, uv3);
		
	COLOR = final;
}
```
# 7.- Multiply with the animated noise from before
```
void fragment()
{
	//1. Create noise texture
	vec4 originalTex = texture(noise, UV);
	
	//2. Scale really big
	vec2 uv = UV* vec2(0.25,0.25);
	uv.x = uv.x-TIME*0.1;
	uv.y = uv.y+TIME*0.1;
	vec4 noiseTex1 = texture(noise, uv);
	
	//3. Animate UVs
	vec2 uv2 = UV* vec2(0.25,0.25);
	uv2.x = uv2.x+TIME*0.1;
	uv2.y = uv2.y-TIME*0.1;
	vec4 noiseTex2 = texture(noise, uv2);
	
	//4. Duplicate, Reverse, Add
	vec4 added = (noiseTex1 + noiseTex2) * 0.5;
	
	//5. Add Original Noise
	vec4 final = (added + originalTex) * 0.5;
	
	//6. Plug that into the UV Offset of the original noise
	vec2 uv3 = uv * final.r * 0.01;
	final = texture(noise, uv3);
	
	//7. Multiply with the animated noise of before
	final = final * added;
	
	COLOR = final;
}
```
# 8.- Add Color
```
shader_type canvas_item;

uniform sampler2D noise;

const float speed = 0.2;
const float scale = 1.0;

void fragment()
{
	//1. Create noise texture
	vec4 originalTex = texture(noise, UV);
	
	//2. Scale really big
	vec2 uv = UV* vec2(scale);
	uv.x += uv.x-TIME*speed;
	uv.y += uv.y+TIME*speed;
	vec4 noiseTex1 = texture(noise, uv);
	
	//3. Animate UVs
	vec2 uv2 = UV* vec2(scale);
	uv2.x = uv2.x+TIME*speed;
	uv2.y = uv2.y-TIME*speed;
	vec4 noiseTex2 = texture(noise, uv2);
	
	//4. Duplicate, Reverse, Add
	vec4 added = (noiseTex1 + noiseTex2) * 0.5;
	
	//5. Add Original Noise
	vec4 final = (added + originalTex) * 0.5;
	
	//6. Plug that into the UV Offset of the original noise
	vec2 uv3 = uv * final.r * 0.01;
	final = texture(noise, uv3);
	
	//7. Multiply with the animated noise of before
	final = final * added;
	
	final.r = final.r * 0.1;
	final.b = final.b * 4.0;
	final.g = final.g * 3.0;
	
	COLOR = final;
}
```
# 9.- Final
```
shader_type canvas_item;

uniform sampler2D noise;
uniform sampler2D gradient;

uniform float speed = 0.2;
uniform float scale = 1.0;
uniform float scale2 = 0.1;

void fragment()
{
	//1. Create noise texture
	vec4 originalTex = texture(noise, UV);
	
	//2. Scale really big
	vec2 uv = UV* vec2(scale);
	
	//The += is to avoid repetition after a while
	uv.x += uv.x+TIME*speed;
	uv.y += uv.y+TIME*speed;
	vec4 noiseTex1 = texture(noise, uv);
	
	//3. Animate UVs
	vec2 uv2 = UV* vec2(scale);
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
	vec3 sampled_color = texture(gradient,vec2(final.r,0.0)).rgb;
	
	COLOR.rgb = sampled_color;
}
```

