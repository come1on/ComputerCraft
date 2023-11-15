local monitor = peripheral.find("monitor")
local chest = peripheral.find("minecraft:chest")
local totalSlots = chest.size()
--local redstoneOutput = rs.getSides("top")

print(monitor.isColor())


function getItemCount()
local totalHammers = 0
for slot, item in pairs(chest.list()) do
        totalHammers = totalHammers + item.count
end

return totalHammers
end



-- Function to check if the item count is below the threshold
function isBelowThreshold()

	-- Threshold for the minimum number of items in the chest
	local threshold = 5
    return getItemCount() < threshold
end

-- Function to activate hammer production
function sendRedstoneSignal()

if isBelowThreshold() then
        -- If below the threshold, emit a redstone signal
        redstone.setOutput("top", true)  -- Replace "your_redstone_output_side" with the side of the redstone output
    else
        -- If not below the threshold, turn off the redstone signal
        redstone.setOutput("top", false)
    end
end	


-- Function to check the redstone signal is true (Machine on/off)
function isRedstoneOn()
    return rs.getInput("back")  -- Replace "your_redstone_side" with the side of the redstone input
end

-- Function to update the monitor display
function updateDisplay()
    local redstoneStatus = isRedstoneOn()
	local itemCount = getItemCount()
    
	-- Check if monitor supports color

	if monitor.isColor() == true then
	
	-- Set the background color based on redstone status
    if redstoneStatus then
        monitor.setBackgroundColor(colors.red)
    else
        monitor.setBackgroundColor(colors.green)
    end
	
	-- Set the text color to white (default color)
	monitor.setTextColor(colors.black)
	
    end
    -- Clear the monitor and set cursor position
    monitor.clear()
	
	-- Set the text scale to 1 (adjust as needed)
    monitor.setTextScale(1)
	
	-- Get the monitor size
    local monitorWidth, monitorHeight = monitor.getSize()
	
	-- Calculate the vertical position to center the text
    local yPos = math.floor((monitorHeight - 1) / 2) + 1
    
    -- Display the redstone status
    local redstoneText = "Machine Status: " .. (redstoneStatus and "Off" or "On")
    local redstoneXPos = math.floor((monitorWidth - string.len(redstoneText)) / 2) + 1
    monitor.setCursorPos(redstoneXPos, yPos)
    
    monitor.setTextColor(colors.white)
    monitor.write(redstoneText)
    
    -- Move cursor to the next line
    yPos = yPos + 1
    
    -- Display the item count
    local itemCountText = "Hammer Count: " .. itemCount
    local itemCountXPos = math.floor((monitorWidth - string.len(itemCountText)) / 2) + 1
    monitor.setCursorPos(itemCountXPos, yPos)
    
    monitor.write(itemCountText)
	
end


-- Main program loop
while true do
    updateDisplay()
	sendRedstoneSignal()
    sleep(1)  -- Adjust the sleep duration based on how frequently you want to update the display
end


