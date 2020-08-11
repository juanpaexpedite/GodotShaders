shader_type canvas_item;

uniform sampler2D inputpalette;
uniform sampler2D outputpalette;
uniform int palettesize = 16;
uniform int offset = 0;
uniform float tolerance : hint_range(0.0, 1.0, 0.001) = float(0.3);

int getpaletteidx(vec3 color)
{
	for(int x=0;x<palettesize;x++)
	{
		ivec2 coord = ivec2(x,0);
		vec3 pixelcolor = texelFetch(inputpalette, coord, 0).rgb;	
		if(distance(color,pixelcolor) == 0.0 )
		{
			return x;
		}
	}
	
	return -1;
}

vec3 getpalettecolor(int x)
{
	ivec2 coord = ivec2(x,0);
	return texelFetch(outputpalette, coord, 0).rgb;	
}

void fragment() {
	
	vec4 incolor = texture(TEXTURE, UV);
	
	int idx = getpaletteidx(incolor.rgb);
	
	 //- TIME * 10.0
	float fdelta = float(idx + offset);
	float mod2 = mod(fdelta,float(palettesize));
	int delta = int(mod2);
	
	vec3 color = getpalettecolor(delta);
	
	if(idx > -1)
	{
		COLOR.rgb = color.rgb;	
	}
	else	
	{
		COLOR.rgb = vec3(0,0,0);
	}
	COLOR.a = incolor.a;
}