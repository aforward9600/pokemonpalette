SFX_Shooting_Star_Ch4:
IF DEF(_REDGREENJP)
	duty 2
	pitchenvelope 5, -7
ELSE
	dutycycle 228
	pitchenvelope 2, -7
ENDC
	squarenote 4, 4, 0, 2016
	squarenote 4, 6, 0, 2016
	squarenote 4, 8, 0, 2016
	squarenote 8, 10, 0, 2016
	squarenote 8, 10, 0, 2016
	squarenote 8, 8, 0, 2016
	squarenote 8, 6, 0, 2016
	squarenote 8, 3, 0, 2016
	squarenote 15, 1, 2, 2016
	pitchenvelope 0, 0
	endchannel
