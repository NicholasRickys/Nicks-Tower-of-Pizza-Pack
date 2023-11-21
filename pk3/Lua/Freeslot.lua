// SHIT FOR GRABBING

freeslot('MT_GRABBEDMOBJ')

mobjinfo[MT_GRABBEDMOBJ] = {
	doomednum = -1,
	spawnstate = S_PLAY_WAIT,
	flags = MF_NOGRAVITY
}

// MOBJ (EFFECTS, PARTICLES) SHIT

freeslot('MT_NTOPP_AFTERIMAGE')

freeslot('MT_LINEPARTICLE')
freeslot('MT_PARTICLE')

freeslot('S_LINEPARTICLE_MACHDUST')
freeslot('SPR_MCDS')

freeslot('S_LINEPARTICLE_RUNDUST')
freeslot('SPR_SDSC')

freeslot("S_DASHCLOUD","SPR_DSHC","S_SMALLDASHCLOUD","S_CLOUDEFFECT","SPR_CLEF")
freeslot("S_PJUMPDUST", "SPR_JPDT", "sfx_pjump")

freeslot("S_PSTNDJUMPDUST", "SPR_JPDU")

states[S_LINEPARTICLE_MACHDUST] = {SPR_MCDS, FF_PAPERSPRITE|FF_ANIMATE|A, 6*2, nil, 5, 2, S_NULL}
states[S_LINEPARTICLE_RUNDUST] = {SPR_SDSC, FF_PAPERSPRITE|FF_ANIMATE|A, 5*2, nil, 4, 2, S_NULL}
states[S_PJUMPDUST] = {SPR_JPDT, FF_PAPERSPRITE|FF_ANIMATE|A, 6, nil, 5, 1, S_NULL}
states[S_PSTNDJUMPDUST] = {SPR_JPDU, FF_ANIMATE|A, 7, nil, 6, 1, S_NULL}

mobjinfo[MT_LINEPARTICLE] = {
	doomednum = -1,
	spawnstate = S_LINEPARTICLE_MACHDUST,
	flags = MF_NOCLIP|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

mobjinfo[MT_NTOPP_AFTERIMAGE] = {
	doomednum = -1,
	spawnstate = S_LINEPARTICLE_MACHDUST,
	flags = MF_NOCLIP|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

// PLAYER SHIT

freeslot('sfx_pstep')

freeslot('sfx_mach1')
freeslot('sfx_mach2')
freeslot('sfx_mach3')
freeslot('sfx_mach4')

freeslot('sfx_pskid')
freeslot('sfx_drift')

freeslot('sfx_pgrab')

freeslot('sfx_kenem')
freeslot('sfx_parry')
freeslot('sfx_taunt')

freeslot('sfx_sjpre')
freeslot('sfx_sjhol')
freeslot('sfx_sjrel')
freeslot('sfx_sjcan')
freeslot('sfx_phalo')

freeslot('sfx_grpo')
freeslot('sfx_mabmp')

freeslot('sfx_pain1')
freeslot('sfx_pain2')
freeslot('sfx_eyaow')

freeslot('sfx_upcut')
freeslot('sfx_upcu2')

freeslot('sfx_breda')
freeslot('sfx_brdam')

freeslot('sfx_strea')

freeslot('sfx_gploop','sfx_gpstar')
sfxinfo[sfx_gploop].caption = "Body Slam Loop"
sfxinfo[sfx_gpstar].caption = "Body Slam Start"
sfxinfo[sfx_grpo].caption = "Body Slam"

freeslot('SPR2_SPDH')
freeslot('SPR2_SDHA')

freeslot('SPR2_LOJU')

freeslot('SPR2_HLID')
freeslot('SPR2_HLFL')
freeslot('SPR2_HLLA')
freeslot('SPR2_HLWA')

freeslot('SPR2_CRTR')
freeslot('SPR2_CRCH')
freeslot('SPR2_CRAL')
freeslot('SPR2_CRFA')

freeslot('SPR2_SJPR')
freeslot('SPR2_SJRE')
freeslot('SPR2_SJGO')
freeslot('SPR2_SJCS')
freeslot('SPR2_SJCA')

freeslot('SPR2_BSST')
freeslot('SPR2_BSFL')
freeslot('SPR2_BSLD')

freeslot('SPR2_DVBM')
freeslot('SPR2_DVBE')
freeslot('SPR2_UPCE')

freeslot('SPR2_WJEN')

freeslot('SPR2_KNFU')
freeslot('SPR2_KNF2')
freeslot('SPR2_KNF3')

freeslot('SPR2_WLSP')
freeslot('SPR2_SJLA')
freeslot('SPR2_M3HW')

freeslot('SPR2_PIDR')
freeslot('SPR2_PIDL')

freeslot('SPR2_TAUN')

freeslot('SPR2_PARR')
freeslot('SPR2_PAR2')

freeslot('SPR2_BRD1')
freeslot('SPR2_BRD2')
freeslot('SPR2_BTAT')

freeslot('SPR2_PRAM')

freeslot('SPR2_STA1')
freeslot('SPR2_STA2')
freeslot('SPR2_STA3')
freeslot('SPR2_STA4')

freeslot('S_PEPPINO_JUMPTRNS')
freeslot('S_PEPPINO_FALLTRNS')

freeslot('S_PEPPINO_MACH1')
freeslot('S_PEPPINO_MACH2')
freeslot('S_PEPPINO_MACH3')
freeslot('S_PEPPINO_MACH4')

freeslot('S_PEPPINO_SECONDJUMP')

freeslot('S_PEPPINO_MACH3JUMP')

freeslot('S_PEPPINO_MACH3HIT')

freeslot('S_PEPPINO_MACHSKID')

freeslot('S_PEPPINO_MACHDRIFTTRNS2')
freeslot('S_PEPPINO_MACHDRIFTTRNS3')

freeslot('S_PEPPINO_MACHDRIFT2')
freeslot('S_PEPPINO_MACHDRIFT3')

freeslot('S_PEPPINO_SUPLEXDASH')
freeslot('S_PEPPINO_AIRSUPLEXDASH')

freeslot('S_PEPPINO_LONGJUMP')

freeslot('S_PEPPINO_HAULINGIDLE')
freeslot('S_PEPPINO_HAULINGFALL')
freeslot('S_PEPPINO_HAULINGWALK')

freeslot('S_PEPPINO_WALLCLIMB')

freeslot('S_PEPPINO_CROUCH')
freeslot('S_PEPPINO_CROUCHWALK')
freeslot('S_PEPPINO_CROUCHFALL')

freeslot('S_PEPPINO_ROLL')

freeslot('S_PEPPINO_DIVE')

freeslot('S_PEPPINO_SUPERJUMPSTARTTRNS')
freeslot('S_PEPPINO_SUPERJUMPSTART')
freeslot('S_PEPPINO_SUPERJUMP')
freeslot('S_PEPPINO_SUPERJUMPCANCELTRNS')
freeslot('S_PEPPINO_SUPERJUMPCANCEL')

freeslot('S_PEPPINO_BODYSLAMSTART')
freeslot('S_PEPPINO_BODYSLAM')
freeslot('S_PEPPINO_BODYSLAMLAND')

freeslot('S_PEPPINO_DIVEBOMB')
freeslot('S_PEPPINO_DIVEBOMBEND')

freeslot('S_PEPPINO_UPPERCUTEND')

freeslot('S_PEPPINO_WALLJUMP')

freeslot('S_PEPPINO_PILEDRIVER')
freeslot('S_PEPPINO_PILEDRIVERLAND')

freeslot('S_PEPPINO_TAUNT')

freeslot('S_PEPPINO_BREAKDANCE1')
freeslot('S_PEPPINO_BREAKDANCE2')
freeslot('S_PEPPINO_BREAKDANCELAUNCHTRNS')
freeslot('S_PEPPINO_BREAKDANCELAUNCH')

freeslot('S_PEPPINO_BOOGIE')

// call me lazy but no reason to type a shit ton of code when you can just
for i = 1,5 do
	freeslot('SPR2_FIB'..i)
	freeslot('S_PEPPINO_FINISHINGBLOW'..i)
end

freeslot('S_PEPPINO_BELLYSLIDE')

freeslot('S_PEPPINO_KUNGFU_1')
freeslot('S_PEPPINO_KUNGFU_2')
freeslot('S_PEPPINO_KUNGFU_3')

freeslot('S_PEPPINO_PARRY1')
freeslot('S_PEPPINO_PARRY2')

freeslot('S_PEPPINO_UPSTUN')
freeslot('S_PEPPINO_MACH2STUN')
freeslot('S_PEPPINO_MACH3STUN')

freeslot('S_PEPPINO_BREAKDANCELAUNCHTRNS')
freeslot('S_PEPPINO_BREAKDANCELAUNCH')

freeslot('S_PEPPINO_SLOPEJUMP')

freeslot('S_PEPPINO_SUPERTAUNT1')
freeslot('S_PEPPINO_SUPERTAUNT2')
freeslot('S_PEPPINO_SUPERTAUNT3')
freeslot('S_PEPPINO_SUPERTAUNT4')

freeslot("S_EXPLOSIONEFFECT","SPR_EPLO","S_MACH4RING","SPR_M4RI")

sfxinfo[sfx_pstep].caption = "Step"
sfxinfo[sfx_mach1].caption = "Mach 1"
sfxinfo[sfx_mach2].caption = "Mach 2"
sfxinfo[sfx_mach3].caption = "Mach 3"
sfxinfo[sfx_mach4].caption = "Mach 4"
sfxinfo[sfx_pskid].caption = "Skid"
sfxinfo[sfx_drift].caption = "Drift"
sfxinfo[sfx_pgrab].caption = "Grab"
sfxinfo[sfx_pain1].caption = "Painful yelp"
sfxinfo[sfx_pain2].caption = "Painful yelp"
sfxinfo[sfx_parry].caption = "Pow!"
sfxinfo[sfx_phalo].caption = "HA!"
sfxinfo[sfx_eyaow].caption = "EYAAAAOAOAOAOAOAOW!"
sfxinfo[sfx_breda].caption = "Er-Er-Ere!"
sfxinfo[sfx_brdam].caption = "Breakdance Music"

states[S_MACH4RING] = {
	sprite = SPR_M4RI,
	frame = A|FF_PAPERSPRITE
}

states[S_DASHCLOUD] = {
	sprite = SPR_DSHC,
	frame = A|FF_ANIMATE|FF_PAPERSPRITE,
	tics = 16,
	var1 = 8,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_SMALLDASHCLOUD] = {
	sprite = SPR_SDSC,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	tics = 10,
	var1 = 5,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_CLOUDEFFECT] = {
	sprite = SPR_CLEF,
	frame = A|FF_ANIMATE,
	tics = 28,
	var1 = 14,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_EXPLOSIONEFFECT] = {
	sprite = SPR_EPLO,
	frame = A|FF_ANIMATE,
	tics = 18,
	var1 = 9,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_PEPPINO_MACH1] = {SPR_PLAY, SPR2_RUN_, 2, nil, 0, 0, S_PEPPINO_MACH1}
states[S_PEPPINO_MACH2] = {SPR_PLAY, SPR2_MLEL, 2, nil, 0, 0, S_PEPPINO_MACH2}
states[S_PEPPINO_MACH3] = {SPR_PLAY, SPR2_SPIN, 2, nil, 0, 0, S_PEPPINO_MACH3}
states[S_PEPPINO_MACH4] = {SPR_PLAY, SPR2_DASH, 1, nil, 0, 0, S_PEPPINO_MACH4}

states[S_PEPPINO_SECONDJUMP] = {SPR_PLAY, SPR2_FLY_, 2, nil, 0, 0, S_PEPPINO_SECONDJUMP}
states[S_PEPPINO_MACHSKID] = {SPR_PLAY, SPR2_MLEE, 2, nil, 0, 0, S_PEPPINO_MACHSKID}

states[S_PEPPINO_MACHDRIFTTRNS2] = {SPR_PLAY, SPR2_TWIN|FF_ANIMATE|A, 11*2, nil, 10, 2, S_PEPPINO_MACHDRIFT2}
states[S_PEPPINO_MACHDRIFTTRNS3] = {SPR_PLAY, SPR2_BNCE|FF_ANIMATE|A, 13*2, nil, 12, 2, S_PEPPINO_MACHDRIFT3}

states[S_PEPPINO_MACHDRIFT2] = {SPR_PLAY, SPR2_FIRE, 2, nil, 0, 0, S_PEPPINO_MACHDRIFT2}
states[S_PEPPINO_MACHDRIFT3] = {SPR_PLAY, SPR2_FLT_, 2, nil, 0, 0, S_PEPPINO_MACHDRIFT3}

states[S_PEPPINO_SUPLEXDASH] = {SPR_PLAY, SPR2_SPDH, 2, nil, 0, 0, S_PEPPINO_SUPLEXDASH}

states[S_PEPPINO_AIRSUPLEXDASH] = {SPR_PLAY, SPR2_SDHA, 2, nil, 0, 0, S_PEPPINO_AIRSUPLEXDASH}

states[S_PEPPINO_LONGJUMP] = {SPR_PLAY, SPR2_LOJU, 2, nil, 0, 0, S_PEPPINO_LONGJUMP}

states[S_PEPPINO_HAULINGIDLE] = {SPR_PLAY, SPR2_HLID, 2, nil, 0, 0, S_PEPPINO_HAULINGIDLE}
states[S_PEPPINO_HAULINGFALL] = {SPR_PLAY, SPR2_HLFL, 2, nil, 0, 0, S_PEPPINO_HAULINGFALL}
states[S_PEPPINO_HAULINGWALK] = {SPR_PLAY, SPR2_HLWA, 2, nil, 2, 2, S_PEPPINO_HAULINGWALK}

states[S_PEPPINO_CROUCH] = {SPR_PLAY, SPR2_CRCH, 2, nil, 2, 2, S_PEPPINO_CROUCH}
states[S_PEPPINO_CROUCHWALK] = {SPR_PLAY, SPR2_CRAL, 2, nil, 2, 2, S_PEPPINO_CROUCHWALK}
states[S_PEPPINO_CROUCHFALL] = {SPR_PLAY, SPR2_CRFA, 2, nil, 2, 2, S_PEPPINO_CROUCHFALL}

states[S_PEPPINO_ROLL] = {SPR_PLAY, SPR2_ROLL, 2, nil, 0, 0, S_PEPPINO_ROLL}

states[S_PEPPINO_DIVE] = {SPR_PLAY, SPR2_LAND, 2, nil, 0, 0, S_PEPPINO_DIVE}

states[S_PEPPINO_BELLYSLIDE] = {SPR_PLAY, SPR2_CLMB, 2, nil, 0, 0, S_PEPPINO_BELLYSLIDE}
states[S_PEPPINO_WALLCLIMB] = {SPR_PLAY, SPR2_SWIM, 2, nil, 2, 2, S_PEPPINO_WALLCLIMB}

states[S_PEPPINO_SUPERJUMPSTARTTRNS] = {SPR_PLAY, SPR2_SJPR|FF_ANIMATE|A, 8*2, nil, 7, 2, S_PEPPINO_SUPERJUMPSTART}
states[S_PEPPINO_SUPERJUMPSTART] = {SPR_PLAY, SPR2_SJRE, 2, nil, 0, 0, S_PEPPINO_SUPERJUMPSTART}
states[S_PEPPINO_SUPERJUMP] = {SPR_PLAY, SPR2_SJGO, 2, nil, 0, 0, S_PEPPINO_SUPERJUMP}
states[S_PEPPINO_SUPERJUMPCANCELTRNS] = {SPR_PLAY, SPR2_SJCS|FF_ANIMATE|A, 13*2, nil, 12, 2, S_PEPPINO_SUPERJUMPCANCEL}
states[S_PEPPINO_SUPERJUMPCANCEL] = {SPR_PLAY, SPR2_SJCA, 2, nil, 0, 0, S_PEPPINO_SUPERJUMPCANCEL}

states[S_PEPPINO_BODYSLAMSTART] = {SPR_PLAY, SPR2_BSST|FF_ANIMATE|A, 9*2, nil, 8, 2, S_PEPPINO_BODYSLAM}
states[S_PEPPINO_BODYSLAM] = {SPR_PLAY, SPR2_BSFL, 2, nil, 0, 0, S_PEPPINO_BODYSLAM}
states[S_PEPPINO_BODYSLAMLAND] = {SPR_PLAY, SPR2_BSLD|FF_ANIMATE|A, 4*2, nil, 3, 2, S_PLAY_STND}

states[S_PEPPINO_DIVEBOMB] = {SPR_PLAY, SPR2_DVBM, 2, nil, 0, 0, S_PEPPINO_DIVEBOMB}
states[S_PEPPINO_DIVEBOMBEND] = {SPR_PLAY, SPR2_DVBE|FF_ANIMATE|A, 4*2, nil, 3, 2, S_PLAY_STND}

states[S_PEPPINO_UPPERCUTEND] = {SPR_PLAY, SPR2_UPCE, 2, nil, 0, 0, S_PEPPINO_UPPERCUTEND}

states[S_PEPPINO_WALLJUMP] = {SPR_PLAY, SPR2_WJEN, 2, nil, 0, 0, S_PEPPINO_WALLJUMP}
// unfortunately the same cant be applied here
states[S_PEPPINO_FINISHINGBLOW1] = {SPR_PLAY, SPR2_FIB1, 2, nil, 0, 0, S_PEPPINO_FINISHINGBLOW1}
states[S_PEPPINO_FINISHINGBLOW2] = {SPR_PLAY, SPR2_FIB2, 2, nil, 0, 0, S_PEPPINO_FINISHINGBLOW2}
states[S_PEPPINO_FINISHINGBLOW3] = {SPR_PLAY, SPR2_FIB3, 2, nil, 0, 0, S_PEPPINO_FINISHINGBLOW3}
states[S_PEPPINO_FINISHINGBLOW4] = {SPR_PLAY, SPR2_FIB4, 2, nil, 0, 0, S_PEPPINO_FINISHINGBLOW4}
states[S_PEPPINO_FINISHINGBLOW5] = {SPR_PLAY, SPR2_FIB5, 2, nil, 0, 0, S_PEPPINO_FINISHINGBLOW5}

local time = 12

states[S_PEPPINO_TAUNT] = {SPR_PLAY, SPR2_TAUN, time, nil, 0, 0, S_PEPPINO_TAUNT}

states[S_PEPPINO_KUNGFU_1] = {SPR_PLAY, SPR2_KNFU, 2, nil, 0, 0, S_PEPPINO_KUNGFU_1}
states[S_PEPPINO_KUNGFU_2] = {SPR_PLAY, SPR2_KNF2, 2, nil, 0, 0, S_PEPPINO_KUNGFU_2}
states[S_PEPPINO_KUNGFU_3] = {SPR_PLAY, SPR2_KNF3, 2, nil, 0, 0, S_PEPPINO_KUNGFU_3}

states[S_PEPPINO_PARRY1] = {SPR_PLAY, SPR2_PARR, 2, nil, 0, 0, S_PEPPINO_PARRY1}
states[S_PEPPINO_PARRY2] = {SPR_PLAY, SPR2_PAR2, 2, nil, 0, 0, S_PEPPINO_PARRY2}

states[S_PEPPINO_UPSTUN] = {SPR_PLAY, SPR2_SJLA|FF_ANIMATE|A, 8*2, nil, 20, 2, S_PLAY_STND}
states[S_PEPPINO_MACH3STUN] = {SPR_PLAY, SPR2_M3HW|FF_ANIMATE|A, 12*2, nil, 11, 2, S_PLAY_STND}

states[S_PEPPINO_MACH2STUN] = {SPR_PLAY, SPR2_WLSP|FF_ANIMATE|A, 7*2, nil, 6, 2, S_PLAY_STND}

states[S_PEPPINO_PILEDRIVER] = {SPR_PLAY, SPR2_PIDR, 2, nil, 0, 0, S_PEPPINO_PILEDRIVER}
states[S_PEPPINO_PILEDRIVERLAND] = {SPR_PLAY, SPR2_PIDL|FF_ANIMATE|A, 6*2, nil, 5, 2, S_PLAY_STND}

states[S_PEPPINO_BREAKDANCE1] = {SPR_PLAY, SPR2_BRD1, 2, nil, 0, 0, S_PEPPINO_BREAKDANCE1}
states[S_PEPPINO_BREAKDANCE2] = {SPR_PLAY, SPR2_BRD2, 2, nil, 0, 0, S_PEPPINO_BREAKDANCE2}
states[S_PEPPINO_BREAKDANCELAUNCH] = {SPR_PLAY, SPR2_BTAT, 2, nil, 0, 0, S_PEPPINO_BREAKDANCELAUNCH}

states[S_PEPPINO_BOOGIE] = {SPR_PLAY, SPR2_TIRE, 3, nil, 0, 0, S_PEPPINO_BOOGIE}

states[S_PEPPINO_SLOPEJUMP] = {SPR_PLAY, SPR2_PRAM, 2, nil, 0, 0, S_PEPPINO_SLOPEJUMP}

states[S_PEPPINO_SUPERTAUNT1] = {SPR_PLAY, SPR2_STA1|FF_ANIMATE|A, 10*2, nil, 9, 2, S_PLAY_STND}
states[S_PEPPINO_SUPERTAUNT2] = {SPR_PLAY, SPR2_STA2|FF_ANIMATE|A, 10*2, nil, 9, 2, S_PLAY_STND}
states[S_PEPPINO_SUPERTAUNT3] = {SPR_PLAY, SPR2_STA3|FF_ANIMATE|A, 10*2, nil, 9, 2, S_PLAY_STND}
states[S_PEPPINO_SUPERTAUNT4] = {SPR_PLAY, SPR2_STA4|FF_ANIMATE|A, 10*2, nil, 9, 2, S_PLAY_STND}