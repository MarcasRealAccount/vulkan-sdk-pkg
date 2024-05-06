local sdk = require("shared")
sdk:getRequiredSDKLibraries()

externalincludedirs(sdk.path .. sdk.includeDir)

libdirs(sdk.path .. sdk.libDir)
links(sdk.requiredSDKLibs.all)
links(sdk.requiredSDKDynamicLibs.all)
filter("configurations:Debug")
	links(sdk.requiredSDKLibs.debug)
	links(sdk.requiredSDKDynamicLibs.debug)
filter("configurations:not Debug")
	links(sdk.requiredSDKLibs.dist)
	links(sdk.requiredSDKDynamicLibs.dist)
filter({})

if common.host == "windows" then
	linkoptions({ "/IGNORE:4099" })
end
