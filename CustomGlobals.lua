--[[
    LadyCelestia 7/24/2022
    Custom Lua Globals
--]]

local globals; globals = {
	Math = {
		num = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"},
		tens = {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"},
		bases = {{math.floor(1e21), " infinity"}, {math.floor(1e18), " quintillion"}, {math.floor(1e15), " quadrillion"}, {math.floor(1e12), " trillion"},
		{math.floor(1e9), " billion"}, {1000000, " million"}, {1000, " thousand"}, {100, " hundred"}},

		toword = function(int, bool) -- integer to word
			local self = globals.Math
			local str = {}
			if int < 0 then
				table.insert(str, "negative")
			end
			int = math.round(math.abs(tonumber(int)))
			if int == 0 then
				return "zero"
			end
			if int >= self.bases[1][1] then
				table.insert(str, "infinity")
			else
				for _, base in ipairs(self.bases) do
					local value = base[1]
					if int >= value then
						table.insert(str, self.word(int / value) .. base[2])
						int = int % value
					end
				end
				if int > 0 then
					table.insert(str, "and")
					table.insert(str, self.num[int] or self.tens[math.floor(int / 10) - 1] .. (int % 10 ~= 0 and "-" .. self.num[int % 10] or ""))
				end
			end
			str[1] = string.upper(string.sub(str[1], 1, 1)) .. string.sub(str[1], 2)
			return string.upper(table.concat(str, " "))
		end,
		
		lerp = function(a, b, t: number) -- linear interpolation
			return a + (b - a) * t
		end,
		
		quadbez = function(a, b, c, t: number) -- quadratic bezier equation
			return (1 - t)^2*a + 2*(1 - t)*t*b + t^2*c
		end,
		
		cubicbez = function(a, b, c, d, t: number) -- cubic bezier equation
			return (1 - t)^3*a + 3*(1 - t)^2*t*b + 3*(1 - t)*t^2*c + t^3+d
		end,
		
		seglen = function(segments: {Vector3}) -- combined length of segments
			local length = 0
			for i = 1, 10 do
				local this, next = segments[i], segments[i + 1]
				if not next then
					continue
				end
				length += (this - next).Magnitude
			end
			return length
		end,
		
		quadbezlen = function(start: Vector3, control: Vector3, finish: Vector3) -- quadratic bezier length
			local segments: {Vector3} = {}
			for i = 1, 10 do
				table.insert(segments, globals.Math.quadbez(start, control, finish, i / 10))
			end
			return globals.Math.seglen(segments)
		end,
		
		cubicbezlen = function(start: Vector3, control1: Vector3, control2: Vector3, finish: Vector3) -- cubic bezier length
			local segments: {Vector3} = {}
			for i = 1, 10 do
				table.insert(segments, globals.Math.cubicbez(start, control1, control2, finish, i / 10))
			end
			return globals.Math.seglen(segments)
		end,
		
		leftshiftsigned = function(value : number, bits : number) -- signed bit32.lshift
			local shiftedNum = bit32.lshift(value, bits)
			if value < 0 then
				return shiftedNum - 2 ^ 32
			else
				return shiftedNum
			end
		end,
		
		rightshiftsigned = function(value : number, bits : number) -- signed bit32.rshift
			local shiftedNum = bit32.rshift(value, bits)
			if value < 0 then
				return shiftedNum - 2 ^ 32
			else
				return shiftedNum
			end
		end,
		
		rgbtodecimal = function(rgb : Color3) -- color3 to decimal color
			return math.round(globals.Math.leftshiftsigned(rgb.R * 255, 16) + globals.Math.leftshiftsigned(rgb.G * 255, 8) + rgb.B * 255)
		end,
		
		cardinalconvert = function(dir : Vector3) -- convert directional vector to world space
			local angle = math.atan2(dir.X, -dir.Z)
			local quarterTurn = math.pi / 2
			angle = -math.round(angle / quarterTurn) * quarterTurn

			local newX = -math.sin(angle)
			local newZ = -math.cos(angle)
			if math.abs(newX) <= 1e-10 then
				newX = 0
			end
			if math.abs(newZ) <= 1e-10 then
				newZ = 0
			end
			return Vector3.new(newX, 0, newZ)
		end,
		
		relativeplanemovement = function(part : BasePart) -- convert velocity to plane movement (WARNING: deltaAngle can be nan)
			local centerDirection = part.CFrame.LookVector.Unit
			local velocityDirection = part.AssemblyLinearVelocity.Unit
			local deltaAngle = math.deg(math.acos(centerDirection:Dot(velocityDirection)))
			local relativeDirection = centerDirection:Cross(velocityDirection).Unit.Y
			if relativeDirection < 1e-8 and relativeDirection > 0 then
				relativeDirection = 0
			end
			
			return deltaAngle, relativeDirection
		end,
		
		margin = function(origin : number, target : number, margin : number) -- check if origin is within margain of target
			if math.abs(origin - target) / target < margin then
				return true
			end
			return false
		end,
		
		checknan = function(num : number) -- check if number is nan
			if num ~= num then
				return true
			end
			return false
		end,

		abs = math.abs,
		acos = math.acos,
		asin = math.asin,
		atan = math.atan,
		atan2 = math.atan2,
		cos = math.cos,
		ceil = math.ceil,
		cosh = math.cosh,
		clamp = math.clamp,
		deg = math.deg,
		exp = math.exp,
		floor = math.floor,
		frexp = math.frexp,
		fmod = math.fmod,
		huge = math.huge,
		log = math.log,
		log10 = math.log10,
		ldexp = math.ldexp,
		pi = math.pi,
		pow = math.pow,
		rad = math.rad,
		round = math.round,
		random = math.random,
		randomseed = math.randomseed,
		sin = math.sin,
		sign = math.sign,
		sinh = math.sinh,
		sqrt = math.sqrt,
		tan = math.tan,
		tanh = math.tanh,
	},
	
	String = {
		byte = string.byte,
		char = string.char,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		gmatch = string.gmatch,
		len = string.len,
		lower = string.lower,
		match = string.match,
		packsize = string.packsize,
		pack = string.pack,
		rep = string.rep,
		reverse = string.reverse,
		rev = string.reverse,
		sub = string.sub,
		split = string.split,
		unpack = string.unpack,
		upper = string.upper
	},

	Table = {
		cull = function(TableToCull : {any?}, IndexTable : {any?}) -- remove all indexes in TableToCull with value that is listed in IndexTable
			if TableToCull == nil or IndexTable == nil then
				warn("[CustomGlobals]: Invalid argument(s) for table.cull().")
				return TableToCull
			end
			if #IndexTable <= 0 then
				warn("[CustomGlobals]: Invalid table for table.cull().")
				return TableToCull
			end
			for i = 1, #TableToCull do
				local target = IndexTable[i]
				if TableToCull[target] then
					table.remove(TableToCull, target)
					for i2, v in ipairs(IndexTable) do
						if v > target then
							IndexTable[i2] -= 1
						end
					end
				end
			end
			return TableToCull
		end,
		
		concat = table.concat,
		clear = table.clear,
		clone = table.clone,
		create = table.create,
		find = table.find,
		freeze = table.freeze,
		insert = table.insert,
		isfrozen = table.isfrozen,
		maxn = table.maxn,
		move = table.move,
		pack = table.pack,
		remove = table.remove,
		sort = table.sort,
		unpack = table.unpack
	}
}

return setmetatable(globals, {
	__call = function(self)
		return self.Math, self.String, self.Table
	end,
})
