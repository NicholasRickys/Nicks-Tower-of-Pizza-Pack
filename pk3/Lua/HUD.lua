local x = CV_RegisterVar({name = 'ntoppx', defaultvalue = 0})
local y = CV_RegisterVar({name = 'ntoppy', defaultvalue = 0})

addHook('HUD', function(v)
	local scale = FixedDiv((v.height()/v.dupy())*FU, 200*FU)
	local scale2 = FixedDiv(200*FU, 540*FU)
	v.drawFill()
	
	v.drawScaled((320*FU)/2, (200*FU)/2, FixedMul(scale2, scale), v.cachePatch('BACKGROUND_MM'))
	v.drawScaled((320*FU)/2, (200*FU)/2, FixedMul(scale2, scale), v.cachePatch('PEPPINO_MM'))
	v.drawScaled((320*FU)/2, (200*FU)/2, FixedMul(scale2, scale), v.cachePatch('NTOPP_MM'))
end, 'title')