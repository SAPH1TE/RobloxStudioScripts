-- i mean there isnt much to say about this, it just displays how many parts are in the game into the console
-- i have a feeling i can just see this somewhere and this is really redundant...
-- belongs in server script service!

local function countParts()
	local parts = workspace:GetDescendants()
	local count = 0

	for _, obj in ipairs(parts) do
		if obj:IsA("BasePart") then
			count += 1
		end
	end

	print("🌐 Total Parts: " .. count)
end

countParts()

