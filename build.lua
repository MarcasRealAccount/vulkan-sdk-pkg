local sdk = require("shared")

local function validate()
	if sdk.path and sdk.path:len() > 0 then
		local searchPath = sdk.path .. sdk.libDir
		
		local nr               = 0
		local missingLibs      = {}
		local missingDebugLibs = false
		local message          = ""
		for _, v in ipairs(sdk.requiredSDKLibs.all) do
			if not common:hasLib(v, searchPath) then
				missingLibs[v] = true
				nr = nr + 1
			end
		end
		for _, v in ipairs(sdk.requiredSDKLibs.dist) do
			if not common:hasLib(v, searchPath) then
				missingLibs[v] = true
				nr = nr + 1
			end
		end
		for _, v in ipairs(sdk.requiredSDKLibs.debug) do
			if not common:hasLib(v, searchPath) then
				missingLibs[v]   = true
				missingDebugLibs = true
				nr = nr + 1
			end
		end
		
		if nr > 0 then
			message = "vulkan-sdk package error: Missing required sdk libraries.\nIf you think this is an issue with the premake-sdk package, please open an issue on github."
		end
		
		if missingDebugLibs then
			message = message .. "\nMissing required debug sdk libraries.\nIf you haven't installed the \"Shader Toolchain Debug Symbols - 64 bit\" sdk component, go add that in the maintenancetool.exe in the sdk."
		end
		
		if nr > 0 then
			for k, v in pairs(missingLibs) do
				message = message .. "\n  " .. k
			end
		end
		
		if message:len() > 0 then
			term.pushColor(term.errorColor)
			print(message)
			term.popColor()
			
			return false
		end
		
		return true
	else
		message = "vulkan-sdk package error: It doesn't appear like you have installed the vulkan sdk.\nPlease go to https://vulkan.lunarg.com/sdk/home and download the sdk installer for your os.\nAlso ensure the VULKAN_SDK environment variable (system one is best, but local is fine) is set to the path to your sdk install (on unix oses you can run the setup-env.sh script with 'source' to add it automatically, tho you will have to cd in and out on macosx)."
		term.pushColor(term.errorColor)
		print(message)
		term.popColor()
		
		io.write("Please write the full sdk path ('Q' to quit): ")
		sdk.path = io.read()
		
		return false
	end
	
	return true
end

while not validate() do
	if sdk.path == "Q" then
		error("Quit", 0)
	end
end

return true