local tu = require "texutil"

function data()
return {
	detailTex = tu.makeTextureMipmapClampVertical("ground_texture/snowball_forester_conifer_border.tga", false, true),
	detailSize = { 32.0, 2.0 },		
	priority = 1
}
end
