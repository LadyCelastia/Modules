--[[
    LadyCelestia 8/27/2023
    Invoke RemoteFunction and BindableFunction without fearing infinite yield
--]]

return function(Function : any, Player : Player?, Timeout : number, arg1, arg2, arg3, arg4, arg5) -- yields until result or timeout
	local result, startTime, Timeout = nil, tick(), Timeout or 5
	if Function:IsA("RemoteFunction") then
		if Player ~= nil then
			task.spawn(function()
				result = Function:InvokeClient(Player, arg1, arg2, arg3, arg4, arg5)
			end)
		else
			task.spawn(function()
				result = Function:InvokeServer(arg1, arg2, arg3, arg4, arg5)
			end)
		end
	elseif Function:IsA("BindableFunction") then
		task.spawn(function()
			result = Function:Invoke(arg1, arg2, arg3, arg4, arg5)
		end)
	end
	repeat task.wait()
	until tick() >= (startTime + Timeout) or result ~= nil
	return result
end
