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

#ifdef __FB_DOS__ 
ScreenRes  640,480 ,32,2, &h04 Or 8 
#endif

'========================================Sub's==========================================
Declare sub Programm()


'========================================Men�f�hrung=====================================

namespace MenueFuehrung
	Declare Function Weiterspielen() As Boolean
	Function Weiterspielen() As Boolean
		BildschirmHelfer.lockscreen
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)

		Color RGB(0,0,0),RGB(140,0,250)
		GrafikHelfer.schreibeSkaliertInsGitter(1,-1, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WOLLEN_NEUES_SPIEL), GrafikEinstellungen.skalierungsfaktor)
			dim as Integer j
			j = 2 'Anzahl der Buttons
			
		'Auswahlbuttons laden:
		Dim ButtonWeiterspielenJaNein(100) As rechteck
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
					Eingabe = i
					Exit Do
				EndIf
			Next
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


	Declare Sub Warten(AbbrechenAnbieten As Boolean = false)
	Sub Warten(AbbrechenAnbieten As Boolean = false)
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
			Weiter.anzeigen()
			Dim abbruchbutton as StandardAbbrechenButton
			if AbbrechenAnbieten then
				abbruchbutton.anzeigen()
			end if
		BildschirmHelfer.unlockScreen()
		
		'Logik
		Do
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
		Loop Until Weiter.wirdGeklickt()
	End Sub


	Declare function LevelCodeInput( TextField as TextBoxType) as string
	function LevelCodeInput( TextField as TextBoxType) as string
				dim as string letter
				TextField.SetPrompt(Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.LEVELCODE_PROMPT))

				TextField.CopyBackground()
				DO
				BildschirmHelfer.lockscreen
					TextField.Redraw()
				BildschirmHelfer.unlockscreen
				letter=inkey 'Eingabe abfragen
				if letter<>"" then 'Es wurde etwas eingeben.
					TextField.NewLetter(letter) 'Zeichen an Textboxc	^ weiterreichen.
				end if
				if (asc(letter) = 27) then textfield.setstring("")
				sleep 1 'CPU-Auslastung reduzieren
					
				loop until  asc(letter)=13 'Ende durch ENTER
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
			For i = 1 To j
				If SpielAuswahlButton(i).wirdGeklickt() Then
					Return i
				EndIf
			Next
		Loop
	End Function 'Spielauswahl


	Declare Sub Sprachauswahl()
	Sub Sprachauswahl()
		BildschirmHelfer.lockscreen
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)

		Color RGB(0,0,0),RGB(140,0,250)
		
		ZeichneLogo(RGB(0,70,100))
		
		GrafikHelfer.schreibeSkaliertInsGitter(2,1,"DE: Bitte eine Sprache waehlen.",GrafikEinstellungen.skalierungsfaktor)
		GrafikHelfer.schreibeSkaliertInsGitter(2,2,"EN: Please choose a language.",GrafikEinstellungen.skalierungsfaktor)
		'GrafikHelfer.schreibeSkaliertInsGitter(2,3,"FR: Veuillez choisir une langue.",GrafikEinstellungen.skalierungsfaktor)

		dim as Integer j,i
		j = 2 'Anzahl der Sprachen. 
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
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden
		'Auswahlbuttons abfragen:

		Do
			For i = 1 To j
				If SprachAuswahlButton(i).wirdGeklickt() Then
					Uebersetzungen.Sprache = i
					Exit Do
				EndIf
			Next
		Loop
	End Sub 'Sprachauswahl

	Declare Function FrageNachLevel(spiel as short) as Short
	Function FrageNachLevel(spiel as short) as Short
		BildschirmHelfer.lockscreen
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		Color RGB(0,0,0),RGB(140,0,250)
		GrafikHelfer.schreibeSkaliertInsGitter(2,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WELCHES_LEVEL),GrafikEinstellungen.skalierungsfaktor)
		'init Textbox
		dim TextField as textboxtype=textboxtype(2,1,40) 'Neue Textbox erzeugen

		TextField.SetColour(rgb(0,0,0))

		ZeichneLogo(RGB(0,70,100))
		Dim as Integer j, i
		if spiel = 1 then
				j = 6 'Anzahl der Level
		else
				j = 3
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
			For i = 1 To j
				If Levelauswahl(i).wirdGeklickt() Then
					Level = i
					Exit Do
				EndIf
			Next
		Loop
		
		Dim as String SEingabe
		Dim levelcode(1 to 6) as String = {"","009662","286735","530147","592542","499469"}
		if spiel = 2 then
			levelcode(1) = ""
			levelcode(2) = "705001"
			levelcode(3) = "541227"
			levelcode(4) = "107528"
			levelcode(5) = "137526"
			levelcode(6) = "305191"
		end if
		
		If len(levelcode(Level)) > 0 then
			SEingabe =  LevelCodeInput(TextField)
		end if
		if Level = 1 or SEingabe = levelcode(Level) then
			GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
			MenueFuehrung.Warten()
			sleep 500
		else 
			GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
			MenueFuehrung.Warten()
			sleep 500
			BildschirmHelfer.FensterSchliessen
		end if
		
		return level
	End Function

end namespace 'MenueFuehrung

'=========================================SpielAufgabe==================================

type SpielAufgabenInterface extends Object

end type

type SpielAufgabenDekorator extends SpielAufgabenInterface
	as SpielAufgabenInterface spielAufgabenSpeicher
end type

type standardSpielAufgabe extends SpielAufgabenInterface

end type


'===========================================Spiel========================================

type SpielInterface extends Object
	public:
		declare abstract sub spielen(level as short, spiel as short)
end type

type SpielDekorator extends SpielInterface
	public:
		declare abstract sub spielen(level as short, spiel as short)
	private:
		as SpielInterface pointer SpielInterfaceSpeicher
end type

type StandardSpiel extends SpielInterface
	public:
		declare virtual sub spielen(level as short, spiel as short)
		declare constructor()
		declare function getAnzahlLevel() as Short
	private:
		as Short anzahlLevel
end type

Constructor StandardSpiel()
	this.anzahlLevel = 6
end Constructor

function StandardSpiel.getAnzahlLevel() as Short
	return this.anzahlLevel
end function

Sub StandardSpiel.spielen(level as short, spiel as short)
	Dim As Integer Punkte, AnzahlRechtecke
	Dim As Integer ende,jj,x_alt,y_alt
	
	Dim Abstand As Integer
	Abstand = GrafikEinstellungen.groesseTextzeichen.y + 1

	Dim AnzahlRechteckeInLevel(1 to 6) as Short = {5,9,17,27,9,17} 
	If level < 1 Or level > 6 Then
		AnzahlRechtecke = 1
	else 
		AnzahlRechtecke = AnzahlRechteckeInLevel(level)
	EndIf
	if spiel = 2 then
		AnzahlRechteckeInLevel(1) = 7
		AnzahlRechteckeInLevel(2) = 10
		AnzahlRechteckeInLevel(3) = 13
	end if
	
	
	
	Dim AktuellerPfeil As Pfeil
	AktuellerPfeil.farbe = GrafikEinstellungen.DunkleresRot
	Color RGB(0,0,0),RGB(255,255,255)
	Punkte = 0
	

	'Rechtecke laden
	Dim RechteckVar(100) As Rechteck
	Dim as Integer i
	For i = 1 To AnzahlRechtecke
		RechteckVar(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
		RechteckVar(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
		RechteckVar(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/AnzahlRechtecke * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
		RechteckVar(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/AnzahlRechtecke * (i)
		RechteckVar(i).farbe = RGB(0,100,255)
	Next
	Do
	    GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
	    BildschirmHelfer.lockscreen
		
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		GrafikHelfer.schreibeSkaliertInsGitter(0,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.L_E_V_E_L) & Level, GrafikEinstellungen.skalierungsfaktor)  
		GrafikHelfer.schreibeSkaliertInsGitter(0,1, "" & Punkte & Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PUNKTE_VON_PUNKTE), GrafikEinstellungen.skalierungsfaktor)  
		
		dim as Boolean waehleDasLetzte = false
		dim as Boolean pfeilFliegt = false
		
		if spiel = 2 and level >= 2 and rnd()<0.20 then
			waehleDasLetzte = true
		end if
		if spiel = 1 and level >= 5 then
			pfeilFliegt = true
		end if
		
		if not waehleDasLetzte then
			If not pfeilFliegt Then
				GrafikHelfer.schreibeSkaliertInsGitter(0,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(0,3,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
			EndIf
		Else
			If not pfeilFliegt Then
				GrafikHelfer.schreibeSkaliertInsGitter(0,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_LETZTES_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(0,3,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_LETZTES_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
			EndIf
		end if
		
		GrafikHelfer.schreibeSkaliertInsGitter(0,4, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUSWAHL_RECHTECK_KLICK), GrafikEinstellungen.skalierungsfaktor)
		'per Zufall Pfeil erzeugen
		If not pfeilFliegt Then
			AktuellerPfeil.x1 = 10 
			AktuellerPfeil.y1 =GrafikEinstellungen.hoehe/2                                                                          
			AktuellerPfeil.laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
			AktuellerPfeil.Richtung = Rnd()*(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)-(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)/2                                                           '|
		Else
			Do
				AktuellerPfeil.x1 = 10 
				AktuellerPfeil.y1 =GrafikEinstellungen.hoehe/2                                                                          
				AktuellerPfeil.laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
				AktuellerPfeil.Richtung = Rnd()*180-180/2
				For i = 0 To anzahlrechtecke
					If RechteckVar(i).istPunktDarauf(	Punkt(	RechteckVar(i).x1,int(MatheHelfer.Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,							AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,RechteckVar(i).x1, 9.81, GrafikEinstellungen.skalierungsfaktor)))						) Then
							Exit Do
					EndIf
				Next
			Loop		
		EndIf
		
		
		AktuellerPfeil.anzeigen()

		For i = 1 To AnzahlRechtecke
			RechteckVar(i).anzeigen()
		Next
		
		'�berblenden
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden()
		
		'Eingabe machen
		Dim as Integer Eingabe
		Do
			'If AbbrechenButton() = 1 Then end
			For i = 1 To AnzahlRechtecke
				If RechteckVar(i).wirdGeklickt() Then
					Eingabe = i
					exit do
				EndIf
			Next
		Loop
		If Eingabe = 0 Then End
		
		'Richtung des AktuellerPfeils einzeichnen
		dim as single x, y
		x = AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '_ Hier wird der Start f�r das einzeichnen auf die AktuellerPfeilspitze gesetzt.
		y = AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '/
		If pfeilFliegt Then 
				AktuellerPfeil.x1 = x 'X und Y m�ssen neu gespeichert werden, da diese Variablen noch gebraucht werden, die Werte aber nicht ge�ndert
				AktuellerPfeil.y1 = y 'werden d�rfen. Die "Orginale" AktuellerPfeil.x1 und AktuellerPfeil.y1 werden nicht mehr gebraucht.
		EndIf
		'Die folgende For...Next-Schleife zeichnet eine Linie der AktuellerPfeilrichtung Pixel-f�r-Pixel ein:
		ende = 0 'ende = 1 : Schleife wird abgebrochen
		dim as Integer letztesRechteck = 0
		For jj = 0 To Sqr(GrafikEinstellungen.breite^2+(GrafikEinstellungen.hoehe/4)^2)'ca. max. L�nge einer schr�gen Linie
			'lockScreen
			If not pfeilFliegt Then 'Gerade Linie, durch (Co)Sinus berechnet
				x = x + COS((AktuellerPfeil.Richtung*Pi)/180)*1
				y = y + SIN((AktuellerPfeil.Richtung*Pi)/180)*1
				GrafikHelfer.dickeLinie  Int(x),Int(y),Int(x),Int(y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
			Else 'Flugbahn
				x_alt = x
				y_alt = y
				x = jj
				y = int(Mathehelfer.Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1,AktuellerPfeil.y1,x,  9.81, GrafikEinstellungen.skalierungsfaktor))
				If x >= AktuellerPfeil.x1 Then
					GrafikHelfer.dickeLinie  Int(x_alt),Int(y_alt),Int(x),Int(y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
				EndIf
			EndIf
				
			'unlockScreen
			'Testen, ob Pixel auf einem Rechteck ist
			For i = 1 To AnzahlRechtecke
				If RechteckVar(i).istPunktDarauf(Punkt(x,y)) Then
					letztesRechteck = i
				end if
			Next
			
			
			if (not waehleDasLetzte and letztesRechteck <> 0) or (waehleDasLetzte and x >= GrafikEinstellungen.breite and letztesRechteck<>0) then
					i = letztesRechteck
					If i = Eingabe Then 

						Color RGB(0,255,0),RGB(255,255,255)
						GrafikHelfer.schreibeSkaliertInsGitter(0,8,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.RICHTIG_PLUS_10), GrafikEinstellungen.skalierungsfaktor, RGB(0,255,0))
						Color RGB(0,0,0), RGB(255,255,255)
						Punkte = Punkte + 10
						
						'Richtiges Rechteck gr�n:
						Dim as Integer j
						For j = 0 To 255
							RechteckVar(i).anzeigen(RGB(0,j,255-j))
							Sleep 2
						Next
						
					Else
						'Print 
						'Print
						If Punkte > 0 Then 
							Color RGB(255,0,0),RGB(255,255,255)
							GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH_MINUS_10),GrafikEinstellungen.skalierungsfaktor, GrafikEinstellungen.DunkleresRot )
							Color RGB(0,0,0),RGB(255,255,255)
							Punkte = Punkte - 10
						Else
							Color RGB(255,0,0),RGB(255,255,255)
							GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH),GrafikEinstellungen.skalierungsfaktoR, GrafikEinstellungen.DunkleresRot)
							Color RGB(0,0,0),RGB(255,255,255) 
						EndIf
												
						'Falsches Rechteck rot:
						Dim as Integer j
						For j = 0 To 255
							RechteckVar(eingabe).anzeigen(RGB(j,0,255-j))
							Sleep 2
						Next
						'For...Next-Schleife: Richtiges Rechteck blinkt gr�n
						For j = 0 To 3
							RechteckVar(i).anzeigen(RGB(0,255,0))
							Sleep 400
							RechteckVar(i).anzeigen(RGB(0,100,255))
							Sleep 400
						Next
					End If
					ende = 1
				end if
			
			
			dim as short accuracy = 1
			
#ifdef __FB_DOS__ 
			accuracy = 15
#endif
			if jj mod accuracy = 0 then
				regulate(450/accuracy,125)
			end if
			If ende = 1 Then Exit For
		Next
		Dim abbruchButton as StandardAbbrechenButton
		MenueFuehrung.Warten(true)
	Loop Until Punkte >= 100

	Sleep 800
	dim as Integer AnzeilZeilen = 3
	
	for i = 1 to AnzeilZeilen 
		dim as String text = Uebersetzungen.uebersetzterGlueckwunschtext(Uebersetzungen.Sprache, level, i)
		GrafikHelfer.schreibeSkaliertInsGitter(0,13+i,text,GrafikEinstellungen.skalierungsfaktor, RGB(255,200,15))
	next
	
	MenueFuehrung.Warten()
End Sub

'=========================================Programm=======================================

Sub Programm()
    MenueFuehrung.Sprachauswahl()
	Do
		Dim as Short spielnummer = MenueFuehrung.Spielauswahl()
		Dim as SpielInterface pointer spielobjekt = new StandardSpiel
		Dim as Short level
		level = MenueFuehrung.FrageNachLevel(spielnummer)
		spielobjekt->Spielen(level, spielnummer)
	Loop Until not MenueFuehrung.Weiterspielen()
End Sub


'=======================================Programm===================================
BildschirmHelfer.FensterOeffnen()
Programm()
BildschirmHelfer.FensterSchliessen()
End
