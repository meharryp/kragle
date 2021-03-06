net.Receive('fw.notif.conprint', function()
	-- i never said it was pretty
	local function printHelper(a, ...)
		fw.print('[notif] ' .. (a or ''), ...)
	end
	printHelper(unpack(net.ReadTable()))
end)

net.Receive('fw.notif.chatprint', function()
	local table = net.ReadTable()
	chat.AddText(color_black, '[' .. GAMEMODE.Name .. ']', color_white, unpack(table))
end)


local nextNotification = 0

net.Receive('fw.notif.screenCenter', function()
	local color = net.ReadColor()
	local time = net.ReadFloat()
	local title = net.ReadString()
	local text = net.ReadString()

	local function display()
		local p = sty.ScreenScale(5)

		local notificationWrapper = vgui.Create('DPanel')

		timer.Simple(time, function()
			if IsValid(notificationWrapper) then
				notificationWrapper:AlphaTo(0, 0.5, 0, function()
					notificationWrapper:Remove()
				end)
			end
		end)

		notificationWrapper:SetSize(sty.ScrW, sty.ScreenScale(50))
		notificationWrapper.Paint = function(w, h)
			surface.SetDrawColor(color)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(0, p, w, h - 2 * p)
		end

		notificationWrapper.Think = function() self:MoveToFront() end

		local notification = vgui.Create('fwNotification', notificationWrapper)
		notification:SetPos(0, p)
		notification:SetSize(notificationWrapper:GetWide(), notificationWrapper:GetTall() - 2 * p)

		notification:SetTitle(title)
		notification:SetMessage(text)
	end

	if nextNotification < os.time() then
		display()
		nextNotification = os.time() + time + 1
	else
		timer.Simple(nextNotification - os.time(), function()
			display()
		end)
		nextNotification = nextNotification + time + 1
	end

end)

vgui.Register('fwNotification', {
		Init = function(self)
			self.titleLabel = sty.With(Label('', self))
				:SetTextColor(Color(20, 20, 20)) ()
			self.messageLabel = sty.With(Label('', self))
				:SetTextColor(Color(20, 20, 20)) ()
		end,

		SetTitle = function(self, text)
			self.titleLabel:SetText(text)

			self:InvalidateLayout()
		end,

		SetMessage = function(self, text)
			self.messageLabel:SetText(text)

			self:InvalidateLayout()
		end,

		SetTimeout = function(self, timer, onDistroy)
			timer.Simple(timer, function()
				self:AlphaTo(0, 0.5, 0, function()
					if IsValid(self) then self:Remove() end
					if onDistroy then onDistory() end
				end)
			end)
		end,

		PerformLayout = function(self)
			self:SetSize(sty.ScrW, sty.ScreenScale(100))

			local p = sty.ScreenScale(4) * 2 -- padding

			self.titleLabel:SetSize(self:GetWide(), self:GetTall() * 0.6)
			self.messageLabel:SetSize(self:GetWide(), self:GetTall() * 0.4)
			self.messageLabel:SetPos(0, self.titleLabel:GetTall())

			self.titleLabel:SetFont(
					fw.fonts.default:fitToView(
						self.titleLabel:GetWide() - p, 
						self.titleLabel:GetWide() - p, 
						self.titleLabel:GetText()
				))

			self.messageLabel:SetFont(
					fw.fonts.default:fitToView(
						self.titleLabel:GetWide() - p, 
						self.titleLabel:GetWide() - p, 
						self.titleLabel:GetText()
				))
		end,

		Paint = function(self, w, h) 
			surface.SetDrawColor(240, 240, 240, 240)
			surface.DrawRect(0, 0, w, h)
		end,

	}, 'STYPanel')

