Config = {
	LANGS = GetConvar('esx:locale', 'EN'),
	JobName = "police",
	ModificationLocation = vector3(-1040.15, -855.43, 4.41),
	

}

configLang = Config.LANGS

ConfigModifVehicleSAPD = {
    Main = {
        Position = Config.ModificationLocation,
        Text3D = "[~b~E~s~] Open Menu",
        Distance = 8,
        Marker = {dirX = 0.0, dirY = 0.0, dirZ = 0.0, rotX = -90.0, rotY = 145.0, rotZ = 0.0, scaleX = 1.5, scaleY = 1.5, scaleZ = 1.5},
        Color = {red = 46, green = 183, blue = 234, alpha = 100},
    },  
}

configVehicleList = {
	'18chargerw',
	'11cvpiw',
	'16chargerw',
	'PBUFFALO4',
	'16exp',
	'police',
	'police2',
	'police3',
	'police4',
	'POLICE4',
	'18chargerw',
	'16fpiuw'

}
