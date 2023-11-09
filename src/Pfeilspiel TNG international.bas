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


'========================================Menüführung=====================================

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
		if Level = 1 or SEingabe = levelcode(1) then
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
enum trinaer
	_True
	_False
	_Null
end enum


type SpielAufgabenInterface extends Object
	declare abstract function aufgabeAnbietenUndErfolgZurueckgeben() as trinaer
	declare abstract sub rechteckeGenerieren()
	declare abstract sub pfeileGenerieren()
	declare abstract function getAnzahlDerPfeile() as Short
	declare abstract sub setAnzahlDerPfeile(anzahl as Short)
	declare abstract sub RedimPfeilArray(groesse as Short)
	declare abstract function getAnzahlDerRechtecke() as Short
	declare abstract sub setAnzahlDerRechtecke(anzahl as Short)
	declare abstract sub RedimRechteckArray(groesse as Short)
	declare abstract function pfeilRichtungVerfolgen() as trinaer 'Zeichnet die Pfeilrichtungsverfolgung und gibt am Ende zurück, ob das richige Element getroffen wurde.
	declare abstract sub pfeilRichtungsVerfolgungInkrement(jj as integer) 'Jeweils ein Schritt des Liniezeichens der Pfeile. Wird von pfeilRichtungVerfolgen() genutzt.
	declare abstract function korrektesRechteckGetroffen(letzterDurchlauf as boolean = false) as trinaer 'Prüft, ob das korrekte Rechteck getroffen wurde. Wird von pfeilRichtungVerfolgen() genutzt.
	declare abstract sub zeichneAufgabenstellung()
	Protected:
		as Rechteck variablesRechteckArray(any) 
		as Pfeil variablesPfeilArray(any) 
		as PunktSingle pfeilSchussPositionen(any) 'Benutzt für pfeilRichtungsVerfolgungInkrement().
		anzahlDerRechtecke as Short
		anzahlDerPfeile as Short
		ausgewaehltesRechteckIndex as Short
		falschBereitsAngezeigt as Boolean = false
end type

'====================================SpielAufgabe/Standard=============================


type standardSpielAufgabe extends SpielAufgabenInterface
	declare virtual function aufgabeAnbietenUndErfolgZurueckgeben() as trinaer
	declare virtual sub rechteckeGenerieren()
	declare virtual function getAnzahlDerRechtecke() as Short
	declare virtual sub setAnzahlDerRechtecke(anzahl as Short)
	declare virtual sub RedimRechteckArray(groesse as Short)
	declare virtual sub zeichneAufgabenstellung()
	declare virtual function getAnzahlDerPfeile() as Short
	declare virtual sub setAnzahlDerPfeile(anzahl as Short)
	declare virtual sub RedimPfeilArray(groesse as Short)
	declare virtual sub pfeileGenerieren()
	declare virtual function pfeilRichtungVerfolgen() as trinaer 'Zeichnet die Pfeilrichtungsverfolgung und gibt am Ende zurück, ob das richige Element getroffen wurde.
	declare virtual sub pfeilRichtungsVerfolgungInkrement(jj as integer) 'Jeweils ein Schritt des Liniezeichens der Pfeile. Wird von pfeilRichtungVerfolgen() genutzt.
	declare virtual function korrektesRechteckGetroffen(letzterDurchlauf as boolean = false) as trinaer 'Prüft, ob das korrekte Rechteck getroffen wurde. Wird von pfeilRichtungVerfolgen() genutzt.
	declare sub zeigeKorrekteWahlAn(RechteckIndex as Short)
	declare sub zeigeInkorrekteWahlAn(RechteckIndexKorrekt as Short,RechteckIndexFalsch as Short)
	as short korrektesRechteck = -1
	declare constructor()
end type

constructor standardSpielAufgabe
	setAnzahlDerRechtecke(5)
	setAnzahlDerPfeile(1)
end constructor

function standardSpielAufgabe.aufgabeAnbietenUndErfolgZurueckgeben() as trinaer

	rechteckeGenerieren()
	' Rechtecke Anzeigen
	Dim as Integer i
	for i = 1 to UBound(this.variablesRechteckArray)
		this.variablesRechteckArray(i).anzeigen()
	next
	
	pfeileGenerieren()
	' Pfeile Anzeigen
	for i = 1 to UBound(this.variablesPfeilArray)
		this.variablesPfeilArray(i).anzeigen()
	next
	
	this.zeichneAufgabenstellung()
	
	GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
	Put(0,0),BildschirmHelfer.img2,pset
	BildschirmHelfer.unlockscreen
	BildschirmHelfer.ueberblenden()
	
	'Eingabe machen
	Dim as Integer Eingabe
	Do
		'If AbbrechenButton() = 1 Then end
		For i = 1 To UBound(this.variablesRechteckArray)
			If variablesRechteckArray(i).wirdGeklickt() Then
				this.ausgewaehltesRechteckIndex = i
				exit do
			EndIf
		Next
	Loop
	
	return this.pfeilRichtungVerfolgen()
end function

function standardSpielAufgabe.pfeilRichtungVerfolgen() as trinaer
	dim as integer jj
	For jj = 0 To Sqr(GrafikEinstellungen.breite^2+(GrafikEinstellungen.hoehe/4)^2)
		pfeilRichtungsVerfolgungInkrement(jj)
		dim as trinaer ergebnis = korrektesRechteckGetroffen()
		if ergebnis<>trinaer._null then
			return ergebnis
		end if
		
		dim as short accuracy = 1
#ifdef __FB_DOS__ 
		accuracy = 15
#endif
		if jj mod accuracy = 0 then
			regulate(450/accuracy,125)
		end if
	next
	return korrektesRechteckGetroffen(true)
end function

function standardSpielAufgabe.korrektesRechteckGetroffen(letzterDurchlauf as boolean) as trinaer
	
	dim as short i 
	for i = lbound(variablesRechteckArray) to ubound(variablesRechteckArray) 
		if variablesRechteckArray(i).istPunktDarauf(Punkt(pfeilSchussPositionen(1).x,pfeilSchussPositionen(1).y)) then
			korrektesRechteck = i
		end if
	Next
	if korrektesRechteck <> -1 Then
		if korrektesRechteck = ausgewaehltesRechteckIndex then
			zeigeKorrekteWahlAn(ausgewaehltesRechteckIndex)
			return trinaer._true
		Else
			zeigeInkorrekteWahlAn(korrektesRechteck, ausgewaehltesRechteckIndex)
			return trinaer._false
		end if
	else
		return trinaer._null
	end if
end function

sub standardSpielAufgabe.pfeilRichtungsVerfolgungInkrement(jj as integer)
	dim as integer i
	for i = lbound(pfeilSchussPositionen) to ubound(pfeilSchussPositionen)
		pfeilSchussPositionen(i).x = pfeilSchussPositionen(i).x + COS((variablesPfeilArray(i).Richtung*Pi)/180)*1
		pfeilSchussPositionen(i).y = pfeilSchussPositionen(i).y + SIN((variablesPfeilArray(i).Richtung*Pi)/180)*1
		GrafikHelfer.dickeLinie  Int(pfeilSchussPositionen(i).x),Int(pfeilSchussPositionen(i).y),Int(pfeilSchussPositionen(i).x),Int(pfeilSchussPositionen(i).y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
	next
end sub

sub standardSpielAufgabe.zeichneAufgabenstellung()
	GrafikHelfer.schreibeSkaliertInsGitter(0,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
end sub

sub standardSpielAufgabe.rechteckeGenerieren()
	RedimRechteckArray(getAnzahlDerRechtecke())
	dim i as Short
	For i = 1 To getAnzahlDerRechtecke()
		variablesRechteckArray(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
		variablesRechteckArray(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
		variablesRechteckArray(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/getAnzahlDerRechtecke * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
		variablesRechteckArray(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/getAnzahlDerRechtecke * (i)
		variablesRechteckArray(i).farbe = RGB(0,100,255)
	Next
End sub

sub standardSpielAufgabe.RedimRechteckArray(groesse as Short)
	Redim variablesRechteckArray (1 to groesse)
end sub

sub standardSpielAufgabe.RedimPfeilArray(groesse as Short)
	Redim variablesPfeilArray (1 to groesse)
end sub

sub standardSpielAufgabe.pfeileGenerieren()
	RedimPfeilArray(getAnzahlDerPfeile())
	Redim pfeilSchussPositionen (1 to getAnzahlDerPfeile())
	Dim as Short i
	For i = 1 To getAnzahlDerPfeile()
		variablesPfeilArray(i).farbe = GrafikEinstellungen.DunkleresRot
		variablesPfeilArray(i).x1 = 10 
		variablesPfeilArray(i).y1 =GrafikEinstellungen.hoehe/2                                                                          
		variablesPfeilArray(i).laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
		variablesPfeilArray(i).Richtung = Rnd()*(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)-(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)/2  
		pfeilSchussPositionen(i).x = variablesPfeilArray(i).x1+ COS((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge
		pfeilSchussPositionen(i).y = variablesPfeilArray(i).y1+ SIN((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge
	Next
end sub

function standardSpielAufgabe.getAnzahlDerRechtecke() as Short
	return this.anzahlDerRechtecke
end function

sub standardSpielAufgabe.setAnzahlDerRechtecke(anzahl as Short)
	this.anzahlDerRechtecke = anzahl
	RedimRechteckArray(anzahl)
end sub

function standardSpielAufgabe.getAnzahlDerPfeile() as Short
	return this.anzahlDerPfeile
end function

sub standardSpielAufgabe.setAnzahlDerPfeile(anzahl as Short)
	this.anzahlDerPfeile = anzahl
	RedimRechteckArray(anzahl)
end sub


sub standardSpielAufgabe.zeigeKorrekteWahlAn(i as Short)
	'Richtiges Rechteck grün:
	Dim as Integer j
	For j = 0 To 255
		variablesRechteckArray(i).anzeigen(RGB(0,j,255-j))
		Sleep 2
	Next
end sub 

sub standardSpielAufgabe.zeigeInkorrekteWahlAn(i as Short, eingabe as Short)
	if not falschBereitsAngezeigt then
		falschBereitsAngezeigt = true
							
		'Falsches Rechteck rot:
		Dim as Integer j
		For j = 0 To 255
			variablesRechteckArray(eingabe).anzeigen(RGB(j,0,255-j))
			Sleep 2
		Next
		'For...Next-Schleife: Richtiges Rechteck blinkt grün
		For j = 0 To 3
			variablesRechteckArray(i).anzeigen(RGB(0,255,0))
			Sleep 400
			variablesRechteckArray(i).anzeigen(RGB(0,100,255))
			Sleep 400
		Next
	end if
end sub


'=======================================SpielAufgabe/Wurf================================


type SpielAufgabenWurf extends standardSpielAufgabe
	declare  virtual sub pfeilRichtungsVerfolgungInkrement(jj as integer) 'Jeweils ein Schritt des Liniezeichens der Pfeile. Wird von pfeilRichtungVerfolgen() genutzt.
	declare  virtual sub pfeileGenerieren()
end type

sub SpielAufgabenWurf.pfeilRichtungsVerfolgungInkrement(jj as integer)
	dim as integer i, y_min_1,x,y
	for i = lbound(pfeilSchussPositionen) to ubound(pfeilSchussPositionen)
	
		x = this.variablesPfeilArray(i).x1+ COS((this.variablesPfeilArray(i).Richtung*Pi)/180)*this.variablesPfeilArray(i).laenge '_ Hier wird der Start für das einzeichnen auf die AktuellerPfeilspitze gesetzt.
		y = this.variablesPfeilArray(i).y1+ SIN((this.variablesPfeilArray(i).Richtung*Pi)/180)*this.variablesPfeilArray(i).laenge '/
	
		pfeilSchussPositionen(i).x = jj
		pfeilSchussPositionen(i).y = int(Mathehelfer.Wurfparabel(this.variablesPfeilArray(i).Richtung*-1,this.variablesPfeilArray(i).laenge,x,y,pfeilSchussPositionen(i).x,  9.81, GrafikEinstellungen.skalierungsfaktor))
		y_min_1 = int(Mathehelfer.Wurfparabel(this.variablesPfeilArray(i).Richtung*-1,this.variablesPfeilArray(i).laenge,x,y,pfeilSchussPositionen(i).x-1,  9.81, GrafikEinstellungen.skalierungsfaktor))
		If pfeilSchussPositionen(i).x >= x Then
			GrafikHelfer.dickeLinie  Int(pfeilSchussPositionen(i).x-1),Int(y_min_1),Int(pfeilSchussPositionen(i).x),Int(pfeilSchussPositionen(i).y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
		EndIf
	next
end sub

sub SpielAufgabenWurf.pfeileGenerieren()
	RedimPfeilArray(getAnzahlDerPfeile())
	Redim pfeilSchussPositionen (1 to getAnzahlDerPfeile())
	Dim as Short i,j
	For i = 1 To getAnzahlDerPfeile()
		Do
			variablesPfeilArray(i).farbe = GrafikEinstellungen.DunkleresRot
			variablesPfeilArray(i).x1 = 10 
			variablesPfeilArray(i).y1 =GrafikEinstellungen.hoehe/2                                                                          
			variablesPfeilArray(i).laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
			variablesPfeilArray(i).Richtung = Rnd()*180-180/2
			For j = 1 To getAnzahlDerRechtecke()
				If variablesRechteckArray(j).istPunktDarauf(	Punkt(	variablesRechteckArray(j).x1,int(MatheHelfer.Wurfparabel(variablesPfeilArray(i).Richtung*-1,variablesPfeilArray(i).laenge,variablesPfeilArray(i).x1+ COS((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge,							variablesPfeilArray(i).y1+ SIN((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge,variablesRechteckArray(j).x1, 9.81, GrafikEinstellungen.skalierungsfaktor)))						) Then
						Exit Do
				EndIf
			Next
		Loop	
	Next
end sub

'===========================================Spiel========================================

type SpielInterface extends Object
	public:
		declare abstract sub spielen(level as short, spiel as short)
		declare abstract function getNoetigePunkte() as short
		declare abstract function getAktuellePunkte() as short
		declare abstract sub setAktuellePunkte(punkte as short)
		declare abstract function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare abstract sub zeichneHintergrund()
		declare abstract sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
end type

type SpielDekorator extends SpielInterface 'TODO Standardimplementierungen der Methoden, die SpielInterfaceSpeicher aufrufen, sowie Konstruktor, an den man das übergeben kann.
	public:
		declare abstract sub spielen(level as short, spiel as short)
		declare abstract function getNoetigePunkte() as short
		declare abstract function getAktuellePunkte() as short
		declare abstract sub setAktuellePunkte(punkte as short)
		declare abstract function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare abstract sub zeichneHintergrund()
		declare abstract sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
	private:
		as SpielInterface pointer SpielInterfaceSpeicher
end type

type StandardSpiel extends SpielInterface
	public:
		declare virtual sub spielen(level as short, spiel as short)
		declare constructor()
		declare function getAnzahlLevel() as Short
		declare virtual function getNoetigePunkte() as short
		declare virtual function getAktuellePunkte() as short
		declare virtual sub setAktuellePunkte(punkte as short)
		declare virtual function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare virtual sub zeichneHintergrund()
		declare virtual sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
	private:
		as Short anzahlLevel
		as Short aktuellePunkte
		as Short modus
end type

Constructor StandardSpiel()
	this.anzahlLevel = 6
	this.aktuellePunkte = 0
end Constructor

function StandardSpiel.getAktuellePunkte() as short
	return this.aktuellePunkte
end function

sub StandardSpiel.setAktuellePunkte(punkte as short)
	this.aktuellePunkte = punkte
end sub

function StandardSpiel.getAnzahlLevel() as Short
	return this.anzahlLevel
end function

function StandardSpiel.getNoetigePunkte() as Short
	return 100
end function

function StandardSpiel.getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
	if modus = 1 then
		if level <= 4 then
			Dim as SpielAufgabenInterface pointer sai
			sai = new standardSpielAufgabe()
			select case level
				case 1
					sai->setAnzahlDerRechtecke(5)
				case 2
					sai->setAnzahlDerRechtecke(9)
				case 3
					sai->setAnzahlDerRechtecke(17)
				case 4
					sai->setAnzahlDerRechtecke(27)
			end select
			function = sai
		Else
			Dim as SpielAufgabenInterface pointer sai
			sai = new SpielAufgabenWurf() 
			
			select case level
				case 5
					sai->setAnzahlDerRechtecke(9)
				case 6
					sai->setAnzahlDerRechtecke(17)
			end select
			
			function = sai
		end if
	else
		if rnd() < 0.3 then
			function = new standardSpielAufgabe() 'TODO spielaufgabe mit letzes Objekt, das ausgewählt wird
		Else
			function = new standardSpielAufgabe()
		end if
	end if
end function

Sub StandardSpiel.spielen(level as short, spiel as short)
	this.modus = spiel 'TODO Entfernen, wenn statt modus und spiel - Übergabe zwei Klassen für die unterschiedlichen Spiele existieren.

	dim as boolean abbruch = false
	Do
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		
		Dim as SpielAufgabenInterface pointer aktuelleSpielAufgabe = getSpielAufgabe(level)
		
		BildschirmHelfer.lockScreen()
		this.zeichneHintergrund()
		this.zeichneLevelInfo(level, this.getAktuellePunkte)
		
		Dim as trinaer erfolg = aktuelleSpielAufgabe->aufgabeAnbietenUndErfolgZurueckgeben()
		
		if erfolg = trinaer._true then
			this.setAktuellePunkte(this.getAktuellePunkte() + 10)
			
			Color RGB(0,255,0),RGB(255,255,255)
			GrafikHelfer.schreibeSkaliertInsGitter(0,8,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.RICHTIG_PLUS_10), GrafikEinstellungen.skalierungsfaktor, RGB(0,255,0))
			Color RGB(0,0,0), RGB(255,255,255)
	
		elseif erfolg = trinaer._false then
			If this.getAktuellePunkte() > 0 Then 
				Color RGB(255,0,0),RGB(255,255,255)
				GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH_MINUS_10),GrafikEinstellungen.skalierungsfaktor, GrafikEinstellungen.DunkleresRot )
				Color RGB(0,0,0),RGB(255,255,255)
			Else
				Color RGB(255,0,0),RGB(255,255,255)
				GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH),GrafikEinstellungen.skalierungsfaktoR, GrafikEinstellungen.DunkleresRot)
				Color RGB(0,0,0),RGB(255,255,255) 
			End If
			
			this.setAktuellePunkte(this.getAktuellePunkte() - 10)
		else 'trinaer._null
			' Auch der Computer macht mal Fehler...
		end if
		if getAktuellePunkte() < 0 then
			this.setAktuellePunkte(0)
		end if
		
		MenueFuehrung.Warten(true)
	Loop Until this.getAktuellePunkte() >= this.getNoetigePunkte() or abbruch

	Sleep 800
	if not abbruch then
		dim as Integer AnzeilZeilen = 3
		
		dim as integer i
		for i = 1 to AnzeilZeilen 
			dim as String text = Uebersetzungen.uebersetzterGlueckwunschtext(Uebersetzungen.Sprache, level, i)
			GrafikHelfer.schreibeSkaliertInsGitter(0,13+i,text,GrafikEinstellungen.skalierungsfaktor, RGB(255,200,15))
		next
		
		MenueFuehrung.Warten()
	end if

End Sub

sub StandardSpiel.zeichneHintergrund()
	BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
end sub

sub StandardSpiel.zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
	GrafikHelfer.schreibeSkaliertInsGitter(0,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.L_E_V_E_L) & aktuellesLevel, GrafikEinstellungen.skalierungsfaktor)  
	GrafikHelfer.schreibeSkaliertInsGitter(0,1, "" & Punkte & Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PUNKTE_VON_PUNKTE), GrafikEinstellungen.skalierungsfaktor)  
end sub

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
