-- Test script to verify the Blue Lock Rivals script functionality
print("\nTesting Blue Lock Rivals Script...")

-- Let the BlueLocksRivals.lua script initialize everything
-- Load the script
local success, err = pcall(function()
    dofile("BlueLocksRivals.lua")
end)

if success then
    print("Script loaded successfully!")
    -- Simply verify that Library was exported
    if Library then
        print("Library object is accessible")
        -- Add basic logging
        for k, v in pairs(Library) do
            print("Library has method/property: " .. k)
        end
    else
        print("Warning: Library object is not accessible")
    end
else
    print("Error loading script: " .. tostring(err))
end

print("\nTest complete!")
print("Note: This is a test environment, full functionality requires Roblox.")