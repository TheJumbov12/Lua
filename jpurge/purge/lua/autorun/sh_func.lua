if SERVER then
    resource.AddFile("sound/purge/alertsound.wav")
    util.AddNetworkString("JPurge_PurgeBool")
end

local countdownTime = 300 -- 5 minutes in seconds
local startTime = CurTime()
function CallPurge()
    if CLIENT then
        surface.PlaySound("/purge/alertsound.wav")
        local PurgeActive = true
        hook.Add("HUDPaint", "Purgeisactive", function()
            if PurgeActive then
                draw.SimpleText("PURGE IS ACTIVE", "CloseCaption_Bold", ScrW() / 2, 50, Color( 255, 0, 0, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                local timeLeft = countdownTime - (CurTime() - startTime)
                if timeLeft > 0 then
                    local minutes = math.floor(timeLeft / 60)
                    local seconds = timeLeft % 60
                    local text = string.format("%02d:%02d", minutes, seconds)
                    draw.SimpleText(text, "CloseCaption_Bold", ScrW() / 1.99, ScrH() / 10, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    PurgeActive = false
                end
            else
                hook.Remove("HUDPaint", "Purgeisactive")
            end
        end)
    end
end

concommand.Add("JPurge_Test", function()
    CallPurge()
    print("Test Purge Successful")
end)

JThinkCooldown = CurTime()
hook.Add("Think", "JTimeChecker", function()
    if JThinkCooldown == CurTime() then return end
    JThinkCooldown = JThinkCooldown + 1
    local hour = os.date("%H")
    local minute = os.date("%M")
    if hour == 2 and minute == 55 then
        CallPurge()
    end
end)