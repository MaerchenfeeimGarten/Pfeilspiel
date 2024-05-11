#Include Once "fbgfx.bi"
#Include once "../libs/Textbox/textbox.bi"
#Include once "../libs/Punkt.bi"
#Include once "../libs/MathHelf.bi"
#Include once "../libs/GrafikEi.bi"
#Include once "../libs/Bildschi.bi"
#Include once "../libs/GrafikHe.bi"
#Include once "../libs/GrafElem/Pfeil.bi"
#Include once "../libs/GrafElem/Rechteck.bi"
#Include once "../libs/i18n/Ueberset.bi"
#Include once "../libs/timer/delay.bi"
#Include once "../libs/SpielEle/AbbruchB.bi"
#Include once "../libs/SpielEle/Logo.bi"
#Include once "../libs/Bildschi.bi"

#Include once "../PfeilTNG.bi"

'========================================Menüführung=====================================

namespace MenueFuehrung
	Declare Function Weiterspielen() As Boolean
	Function Weiterspielen() As Boolean
		BildschirmHelfer.lockscreen
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		
		Color RGB(0,0,0),RGB(140,0,250)
		GrafikHelfer.schreibeSkaliertInsGitter(1,-1,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WOLLEN_NEUES_SPIEL), GrafikEinstellungen.skalierungsfaktor)
			dim as Integer j
			j = 2 'Anzahl der Buttons
			
		'Auswahlbuttons laden:
		Dim ButtonWeiterspielenJaNein(2) As rechteck
		Dim as Integer i
		For i = 1 To j
			ButtonWeiterspielenJaNein(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
			ButtonWeiterspielenJaNein(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
			ButtonWeiterspielenJaNein(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
			ButtonWeiterspielenJaNein(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i)
			ButtonWeiterspielenJaNein(i).farbe = RGB(0,100,255)
		Next
		
		ButtonWeiterspielenJaNein(1).beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.JA)
		ButtonWeiterspielenJaNein(2).beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.NEIN)
		
		'Auswahlbuttons anzeigen:
		ButtonWeiterspielenJaNein(1).anzeigen()
		ButtonWeiterspielenJaNein(2).anzeigen()
		
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden
		'Auswahlbuttons abfragen:

		Dim as integer Eingabe
		Do
			For i = 1 To j
				If ButtonWeiterspielenJaNein(i).wirdGeklickt() Then
					BildschirmHelfer.SchliessenButtonAbarbeiten()
					Eingabe = i
					Exit Do
				EndIf
			Next
			sleep 15
		Loop
		If eingabe = 1 Then 
			Sleep 800
			Return 1 
		Else 
			Sleep 800
			Return 0 
		EndIf
		Sleep 800
	End Function


	Declare sub Warten(AbbrechenAnbieten As Boolean = false) 
	sub Warten(AbbrechenAnbieten As Boolean = false)
		'Weiter-Button laden
		Dim Weiter As Rechteck
		Weiter.x1 = 0+GrafikEinstellungen.breite/20
		Weiter.y1 = GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/10
		Weiter.x2 = GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20
		Weiter.y2 =  GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/15 + 18
		Weiter.farbe = RGB(100,250,100)
		Weiter.beschriftung = Uebersetzungen.uebersetzterText( Uebersetzungen.Sprache,  Uebersetzungen.TextEnum.WEITER)
		

		
		'Anzeige
		BildschirmHelfer.lockScreen()
			Dim abbruchbutton as StandardAbbrechenButton
			if AbbrechenAnbieten then
				abbruchbutton.anzeigen()
			else
				Weiter.x2 = abbruchbutton.getAbbrechenRechteck.x2
				Weiter.y2 = abbruchbutton.getAbbrechenRechteck.y2
			end if
			Weiter.anzeigen()
		BildschirmHelfer.unlockScreen()
		
		'Logik
		Do
			BildschirmHelfer.SchliessenButtonAbarbeiten()
			If AbbrechenAnbieten Then
				If abbruchbutton.wurdeGeklickt() Then
					If Weiterspielen() Then
						Programm()
						BildschirmHelfer.FensterSchliessen()
						End
					else
						BildschirmHelfer.FensterSchliessen()
						end
					EndIf
				EndIf
			EndIf
			sleep 15
		Loop Until Weiter.wirdGeklickt()
	End Sub

	Declare function LevelCodeInput( TextField as TextBoxType) as string
	function LevelCodeInput( TextField as TextBoxType) as string
				get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
				dim as string letter, zurueck, ok
				dim  eingabefeld(1 to 3,1 to 4) as Rechteck
				dim as integer x,y
				
				zurueck = "<--"
				ok = "OK"
				
				for x = 1 to 3
					for y = 1 to 4 
						
						eingabefeld(x,y).x1 = GrafikEinstellungen.breite/20 + GrafikEinstellungen.breite/5*(x-1)
						eingabefeld(x,y).y1 = GrafikEinstellungen.hoehe/5+GrafikEinstellungen.hoehe/5.5*(y-1)
 						eingabefeld(x,y).x2 = GrafikEinstellungen.breite/20 + GrafikEinstellungen.breite/5*(x)-GrafikEinstellungen.breite/36
						eingabefeld(x,y).y2 =  GrafikEinstellungen.hoehe/5+GrafikEinstellungen.hoehe/5.5*(y)-GrafikEinstellungen.hoehe/36
						eingabefeld(x,y).farbe = RGB(0,150,150)
						
					next
				next
				
				eingabefeld(1,1).beschriftung = "1"
				eingabefeld(1,2).beschriftung = "4"
				eingabefeld(1,3).beschriftung = "7"
				eingabefeld(1,4).beschriftung = "0"
				             
				eingabefeld(2,1).beschriftung = "2"
				eingabefeld(2,2).beschriftung = "5"
				eingabefeld(2,3).beschriftung = "8"
				eingabefeld(2,4).beschriftung = zurueck
				             
				eingabefeld(3,1).beschriftung = "3"
				eingabefeld(3,2).beschriftung = "6"
				eingabefeld(3,3).beschriftung = "9"
				eingabefeld(3,4).beschriftung = ok
				
				TextField.SetPrompt(Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.LEVELCODE_PROMPT))
				TextField.CopyBackground()
				
				dim as boolean ersterDurchlauf = true
				DO
					BildschirmHelfer.SchliessenButtonAbarbeiten()
					BildschirmHelfer.lockscreen
					for x = 1 to 3
						for y = 1 to 4 
							eingabefeld(x,y).anzeigen()
						Next
					next 
						
					if ersterDurchlauf then
					    get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
						Put(0,0),BildschirmHelfer.img2,pset
						BildschirmHelfer.unlockscreen
						BildschirmHelfer.ueberblenden
						ersterDurchlauf = false
						else
						BildschirmHelfer.unlockscreen
					end if
					
					TextField.Redraw()
					
					letter=inkey 'Eingabe abfragen
					
					for x = 1 to 3
						for y = 1 to 4 
							if eingabefeld(x,y).wirdGeklickt() then
								letter = eingabefeld(x,y).beschriftung
							end if
						Next
					next 
					
					if letter<>"" and letter <> ok then 'Es wurde etwas eingeben.
						if letter = zurueck then letter = chr(8)'Löschtaste
						TextField.NewLetter(letter) 'Zeichen an Textbox weiterreichen.
						Dim As Integer MM,MDruck
						do' warten, bis die Maustaste wieder losgelassen wurde
							sleep 10
							GetMouse MM,MM,MM,MDruck
						loop until MDruck = 0
					end if
					if (asc(letter) = 27) then textfield.setstring("")
					sleep 10 'CPU-Auslastung reduzieren
					
				loop until  asc(letter)=13 or letter = ok 'Ende durch ENTER
				return TextField.GetString()
	End function 

	Declare Function Spielauswahl() as Short
	Function Spielauswahl() as Short
		BildschirmHelfer.lockscreen
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)

		Color RGB(0,0,0),RGB(140,0,250)
		
		ZeichneLogo(RGB(0,70,100))
		
		GrafikHelfer.schreibeSkaliertInsGitter(2,-1,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.BITTE_WAEHLE_SPIEL),GrafikEinstellungen.skalierungsfaktor)
		'GrafikHelfer.schreibeSkaliertInsGitter(2,3,"FR: Veuillez choisir une langue.",GrafikEinstellungen.skalierungsfaktor)

		dim as Integer j,i
		j = 2 'Anzahl der Spiele. 
		'Auswahlbuttons laden:
		Dim SpielAuswahlButton(100) As rechteck
		For i = 1 To j
			SpielAuswahlButton(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
			SpielAuswahlButton(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
			SpielAuswahlButton(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
			SpielAuswahlButton(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i)
			SpielAuswahlButton(i).farbe = RGB(0,100,255)
			
			Select Case i
				Case 1 
					SpielAuswahlButton(i).beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.STANDARD_SPIEL)
				Case 2
					SpielAuswahlButton(i).beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.VIELFALT_PPT)
			End select
		Next
		'Auswahlbuttons anzeigen:

		For i = 1 To j
			SpielAuswahlButton(i).anzeigen()
		Next
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden
		'Auswahlbuttons abfragen:

		Do
			BildschirmHelfer.SchliessenButtonAbarbeiten()
			For i = 1 To j
				If SpielAuswahlButton(i).wirdGeklickt() Then
					Return i
				EndIf
			Next
			sleep 15
		Loop
	End Function 'Spielauswahl

	Declare Sub Sprachauswahl()
	Sub Sprachauswahl()
		BildschirmHelfer.lockscreen
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		
		Color RGB(0,0,0),RGB(140,0,250)
		
		ZeichneLogo(RGB(0,70,100))
		dim as integer vorschub = 1
		vorschub = GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,vorschub,GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.SpracheEnum.DEUTSCH, Uebersetzungen.TextEnum.SPRACHE_WAEHLEN),GrafikEinstellungen.skalierungsfaktor) +1
		vorschub = GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,vorschub,GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.SpracheEnum.ENGLISCH, Uebersetzungen.TextEnum.SPRACHE_WAEHLEN),GrafikEinstellungen.skalierungsfaktor) +1
		vorschub = GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,vorschub,GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.SpracheEnum.FRANZOESISCH, Uebersetzungen.TextEnum.SPRACHE_WAEHLEN),GrafikEinstellungen.skalierungsfaktor) +1
		'GrafikHelfer.schreibeSkaliertInsGitter(2,3,"FR: Veuillez choisir une langue.",GrafikEinstellungen.skalierungsfaktor)

		dim as Integer j,i
		j = 3 'Anzahl der Sprachen. 
		'Auswahlbuttons laden:
		Dim SprachAuswahlButton(100) As rechteck
		For i = 1 To j
			SprachAuswahlButton(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
			SprachAuswahlButton(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
			SprachAuswahlButton(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
			SprachAuswahlButton(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i)
			SprachAuswahlButton(i).farbe = RGB(0,100,255)
			
			Select Case i
				Case 1 
					SprachAuswahlButton(i).beschriftung = "Deutsch"
				Case 2
					SprachAuswahlButton(i).beschriftung = "English"
				Case 3
					SprachAuswahlButton(i).beschriftung = "Francais"
			End select
		Next
		'Auswahlbuttons anzeigen:

		For i = 1 To j
			SprachAuswahlButton(i).anzeigen()
		Next
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen()
		BildschirmHelfer.ueberblenden()
		'Auswahlbuttons abfragen:

		Do
			BildschirmHelfer.SchliessenButtonAbarbeiten()
			For i = 1 To j
				If SprachAuswahlButton(i).wirdGeklickt() Then
					Uebersetzungen.Sprache = i
					Exit Do
				EndIf
			Next
			sleep 15
		Loop
	End Sub 'Sprachauswahl

	Declare Function FrageNachLevel(spiel as short) as Short
	Function FrageNachLevel(spiel as short) as Short
		BildschirmHelfer.lockscreen
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		Color RGB(0,0,0),RGB(140,0,250)
		GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,0,GrafikEinstellungen.umbruchNach, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WELCHES_LEVEL),GrafikEinstellungen.skalierungsfaktor)
		

		

		ZeichneLogo(RGB(0,70,100))
		Dim as Integer j, i
		if spiel = 1 then
				j = 6 'Anzahl der Level
		else
				j = 6
		end if
		'Auswahlbuttons laden:
		Dim LevelAuswahl(100) As rechteck
		For i = 1 To j
			LevelAuswahl(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
			LevelAuswahl(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
			LevelAuswahl(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
			LevelAuswahl(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/j * (i)
			LevelAuswahl(i).farbe = RGB(0,100,255)
			LevelAuswahl(i).beschriftung = "" & i
			
			Levelauswahl(i).anzeigen()
		Next

		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden

		'Auswahlbuttons abfragen:
		Dim as Short Level
		Do
			BildschirmHelfer.SchliessenButtonAbarbeiten()
			For i = 1 To j
				If Levelauswahl(i).wirdGeklickt() Then
					Level = i
					Exit Do
				EndIf
			Next
			sleep 15
		Loop
		

		return level
	End Function

	function ueberpruefeLevelCode(korrekterLevelCode as String, Level as Short) as boolean
		Dim as String SEingabe
		
		'init Textbox
		dim TextField as textboxtype=textboxtype(2,1,40) 'Neue Textbox erzeugen
		TextField.SetColour(rgb(0,0,0))
		
		If len(korrekterLevelCode) > 0 then
			SEingabe =  LevelCodeInput(TextField)
		end if
		if SEingabe = korrekterLevelCode or "" = korrekterLevelCode then
			GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,3, GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
			MenueFuehrung.Warten()
			return true
		else 
			GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(2,3, GrafikEinstellungen.umbruchNach, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
			MenueFuehrung.Warten()
			return false
		end if
		
	end function
end namespace 'MenueFuehrung
