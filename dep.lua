local sdk = require("shared")

externalincludedirs(sdk.path .. sdk.includeDir)

libdirs(sdk.path .. sdk.libDir)
links(sdk.requiredSDKLibs.all)
filter("configurations:Debug")
	links(sdk.requiredSDKLibs.debug)
filter("configurations:not Debug")
	links(sdk.requiredSDKLibs.dist)
filter({})

if common.host == "windows" then
	linkoptions({ "/IGNORE:4099" })
end