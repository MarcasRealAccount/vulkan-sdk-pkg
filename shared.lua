newoption({
	trigger     = "vulkan-sdk",
	description = "Overrides VULKAN_SDK environment variable",
	value       = "path",
	default     = os.getenv("VULKAN_SDK")
})

local isWindows = common.host == "windows"

local vulkansdk = {
	path       = path.translate(_OPTIONS["vulkan-sdk"], "/"),
	includeDir = iif(isWindows, "/include/", "/Include/"),
	libDir     = iif(isWindows, "/lib/", "/Lib/")
}

function vulkansdk:addDebuggableLib(libs, lib)
	if isWindows then
		table.insert(libs.dist, lib)
		table.insert(libs.debug, lib .. "d")
	else
		table.insert(libs.all, lib)
	end
end

function vulkansdk:getRequiredSDKLibraries()
	if common.host == "windows" then
		self.requiredSDKLibs = {
			all   = { "vulkan-1" },
			dist  = {},
			debug = {}
		}
	else
		self.requiredSDKLibs = {
			all   = { "vulkan" },
			dist  = {},
			debug = {}
		}
	end
	
	if _PKG_ARGS["shaderc"] == "true" then
		self:addDebuggableLib(self.requiredSDKLibs, "shaderc_combined")
	end
end

vulkansdk:getRequiredSDKLibraries()

return vulkansdk