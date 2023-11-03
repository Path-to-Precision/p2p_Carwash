local Slider = {
	Background = {Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76},
	Text = {
		Left = {X = 18, Y = 8, Scale = 0.32},
		Right = {X = 380, Y = 8, Scale = 0.32},
		Upper = {X = 230, Y = 8, Scale = 0.32},
	},
	Bar = {X = 25, Y = 36, Width = 250, Height = 16},
	Slider = {X = 20, Y = 14.5, Width = 35, Height = 9},
	LeftArrow = {Dictionary = "commonmenu", Texture = "arrowleft", X = 12, Y = 32.5, Width = 25, Height = 25},
	RightArrow = {Dictionary = "commonmenu", Texture = "arrowright", X = 389, Y = 32.5, Width = 25, Height = 25},
}

function RageUI.SliderPanel(Value, MinValue, UpperText, MaxValue, Actions, Index)
	local CurrentMenu = RageUI.CurrentMenu
	if CurrentMenu ~= nil then
		if CurrentMenu() and ((CurrentMenu.Index == Index)) then
			Value = Value or 0
			Slider.Bar.Width = Slider.RightArrow.X- Slider.LeftArrow.X - Slider.LeftArrow.Width - 5 + CurrentMenu.WidthOffset
			Slider.Bar.X = Slider.LeftArrow.X + Slider.LeftArrow.Width
			Slider.Text.Upper.X = (Slider.Bar.Width) / 2 + Slider.Bar.X
			Slider.Text.Right.X = Slider.RightArrow.X + Slider.LeftArrow.Width
			local Hovered = false
			local LeftArrowHovered, RightArrowHovered = false, false
			local SliderW = Slider.Bar.Width / (64 + 1)
			local SliderX =  CurrentMenu.X + Slider.Bar.X + Value * Slider.Bar.Width / MaxValue
			Hovered = RageUI.IsMouseInBounds(CurrentMenu.X + Slider.Bar.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + Slider.Bar.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset - 4, Slider.Bar.Width, Slider.Bar.Height + 8)
			RenderSprite("commonmenu", "gradient_bgd", CurrentMenu.X, CurrentMenu.Y + Slider.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.Background.Width + CurrentMenu.WidthOffset, Slider.Background.Height, 0.0, 255, 255, 255, 255)
			RenderText(MinValue, CurrentMenu.X + Slider.Text.Left.X, CurrentMenu.Y + Slider.Text.Left.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, Slider.Text.Left.Scale, 255, 255, 255, 255)
			RenderText(UpperText, CurrentMenu.X + Slider.Text.Upper.X, CurrentMenu.Y + Slider.Text.Upper.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, Slider.Text.Upper.Scale, 255, 255, 255, 255, "Center")
			RenderText(MaxValue, CurrentMenu.X + Slider.Text.Right.X + CurrentMenu.WidthOffset, CurrentMenu.Y + Slider.Text.Right.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, Slider.Text.Right.Scale, 255, 255, 255, 255, "Right")
			RenderSprite(Slider.LeftArrow.Dictionary, Slider.LeftArrow.Texture, CurrentMenu.X + Slider.LeftArrow.X, CurrentMenu.Y + Slider.LeftArrow.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.LeftArrow.Width, Slider.LeftArrow.Height, 0.0,  255, 255, 255, 255)
			RenderSprite(Slider.RightArrow.Dictionary, Slider.RightArrow.Texture, CurrentMenu.X + Slider.RightArrow.X + CurrentMenu.WidthOffset , CurrentMenu.Y + Slider.RightArrow.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.RightArrow.Width, Slider.RightArrow.Height, 0.0, 255, 255, 255, 255)
			RenderRectangle(CurrentMenu.X + Slider.Bar.X, CurrentMenu.Y + Slider.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.Bar.Width, Slider.Bar.Height, 87, 87, 87, 255)
			RenderRectangle(SliderX, CurrentMenu.Y + Slider.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SliderW, Slider.Bar.Height, 245, 245, 245, 255)
			LeftArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + Slider.LeftArrow.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + Slider.LeftArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.LeftArrow.Width, Slider.LeftArrow.Height)
			RightArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + Slider.RightArrow.X + CurrentMenu.SafeZoneSize.X + CurrentMenu.WidthOffset, CurrentMenu.Y + Slider.RightArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Slider.RightArrow.Width, Slider.RightArrow.Height)
			if Hovered then
				if IsDisabledControlPressed(0, 24) then
					local GetControl_X = GetDisabledControlNormal
					Value = (math.round(GetControl_X(2, 239) * 1920) - CurrentMenu.SafeZoneSize.X - Slider.Bar.X )/ Slider.Bar.Width * MaxValue
					if Value < 0 then
						Value = 0
					elseif Value >= MaxValue then
						Value = MaxValue
					end
					Value = math.round(Value, 0)
					if (Actions.onSliderChange ~= nil) then
						Actions.onSliderChange(Value)
					end
				end
			elseif CurrentMenu.Controls.Click.Active and (LeftArrowHovered or RightArrowHovered) then
				local max = type(Items) == "table" and #Items or MaxValue
				Value = Value + (LeftArrowHovered and -1 or RightArrowHovered and 1)
				if Value < MinValue then
					Value = max
				elseif Value > max  then
					Value = MinValue
				end
				if (Actions.onSliderChange ~= nil) then
					Actions.onSliderChange(Value);
				end
				local Audio = RageUI.Settings.Audio
				RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
			end
		end
	end
end