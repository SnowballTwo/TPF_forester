local tu = require "texutil"

function data()
return {
	detailTex = tu.makeTextureMipmapRepeat("ground_texture/snowball_forester_conifer.tga", false),
	detailSize = {128.0, 128.0},	
	colorTex = tu.makeTextureMipmapRepeat("ground_texture/snowball_forester_conifer.tga", false),
	colorSize = 128.0
}
end
