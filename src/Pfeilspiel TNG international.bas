#Include Once "fbgfx.bi"
#Include once "libs/Textbox/textbox.bi"
#Include once "libs/Punkt.bi"
#Include once "libs/MathHelf.bi"
#Include once "libs/GrafikEi.bi"
#Include once "libs/Bildschi.bi"
#Include once "libs/GrafikHe.bi"
#Include once "libs/GrafElem/Pfeil.bi"
#Include once "libs/GrafElem/Rechteck.bi"
#Include once "libs/i18n/Ueberset.bi"
#Include once "libs/timer/delay.bi"
#Include once "libs/SpielEle/AbbruchB.bi"
#Include once "libs/SpielEle/Logo.bi"
#Include once "libs/Bildschi.bi"

#Include once "pfeiltng/menue.bi"
#Include once "pfeiltng/SpielAuf/DasLezte.bi"
#Include once "pfeiltng/SpielAuf/MitFarbe.bi"
#Include once "pfeiltng/SpielAuf/Saufgabe.bi"
#Include once "pfeiltng/SpielAuf/WurfAufg.bi"
#Include once "pfeiltng/Spiel.bi"



#ifdef __FB_DOS__ 
ScreenRes  640,480 ,32,2, &h04 Or 8 
#endif

#include once "PfeilTNG.bi"

'=========================================Programm=======================================

Sub Programm()
	Do
		MenueFuehrung.Sprachauswahl()

		Dim as Short spielnummer = MenueFuehrung.Spielauswahl()
		Dim as SpielInterface pointer spielobjekt = new StandardSpiel
		Dim as Short level
		
		level = MenueFuehrung.FrageNachLevel(spielnummer)
		
		Dim as boolean levelcodeKorrekt
		levelcodeKorrekt = MenueFuehrung.ueberpruefeLevelCode(spielobjekt->getLevelCode(level, spielnummer),level)
		
		if levelcodeKorrekt then
			spielobjekt->Spielen(level, spielnummer)
		end if
	Loop Until not MenueFuehrung.Weiterspielen()
End Sub


'=======================================Programm===================================
BildschirmHelfer.FensterOeffnen()
Programm()
BildschirmHelfer.FensterSchliessen()
End
