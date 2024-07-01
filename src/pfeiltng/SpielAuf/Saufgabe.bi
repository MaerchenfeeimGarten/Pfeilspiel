'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'


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
#Include once "libs/trinaer.bi"


'=========================================SpielAufgabe==================================



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
		as Integer KorrekterPfeilIndex = 1
end type

'====================================SpielAufgabe/Standard=============================

type standardSpielAufgabe extends SpielAufgabenInterface
	declare virtual function waehleFarbeFuerPfeil(i as short, byref farbText as Uebersetzungen.TextFarbe) as integer
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

function standardSpielAufgabe.waehleFarbeFuerPfeil(i as short, byref farbText as Uebersetzungen.TextFarbe) as integer
	select case (i-1) mod 9
		case 0
			farbText = Uebersetzungen.TextFarbe.ROT
			return  GrafikEinstellungen.DunkleresRot
		case 1
			farbText = Uebersetzungen.TextFarbe.GRUEN
			return rgb(0,160,0)
		case 2
			farbText = Uebersetzungen.TextFarbe.BLAU
			return rgb(0,0,254)
		case 3
			farbText = Uebersetzungen.TextFarbe.TURKIES
			return rgb(0,254,255)
		case 4
			farbText = Uebersetzungen.TextFarbe.GELB
			return rgb(255,255,0)
		case 5
			farbText = Uebersetzungen.TextFarbe.ORANGE
			return rgb(255,255/2,0)
		case 6
			farbText = Uebersetzungen.TextFarbe.VIOLETT
			return rgb(255,0,255)
		case 7
			farbText = Uebersetzungen.TextFarbe.WEISS
			return rgb(255,255,255)
		case 8
			farbText = Uebersetzungen.TextFarbe.SCHWARZ
			return rgb(0,0,0)
	end select
end function


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
		BildschirmHelfer.SchliessenButtonAbarbeiten()
		'If AbbrechenButton() = 1 Then end
		For i = 1 To UBound(this.variablesRechteckArray)
			If variablesRechteckArray(i).wirdGeklickt() Then
				this.ausgewaehltesRechteckIndex = i
				exit do
			EndIf
		Next
		sleep 15
	Loop
	
	return this.pfeilRichtungVerfolgen()
end function

function standardSpielAufgabe.pfeilRichtungVerfolgen() as trinaer
	dim as integer jj = 0
	dim as integer start = 0
	dim as integer stopp = Sqr(GrafikEinstellungen.breite^2+(GrafikEinstellungen.hoehe/4)^2)
	dim as MaerchenZeit starttime = MaerchenZeitAngeber()
	dim as double dauer = 6
	dim as integer naechsteBildschirmaktualisierungBei = 1
	do
		naechsteBildschirmaktualisierungBei = timelerp(starttime,dauer,0,stopp)
		BildschirmHelfer.lockScreen()
			for jj = jj to naechsteBildschirmaktualisierungBei
 				pfeilRichtungsVerfolgungInkrement(jj)
				dim as trinaer ergebnis = korrektesRechteckGetroffen()
				if ergebnis<>trinaer._null then
					return ergebnis
				end if
			Next
		BildschirmHelfer.unlockScreen()
'		dim as short accuracy = 1
'#ifdef __FB_DOS__ 
'		accuracy = 15
'#endif
'		if jj mod accuracy = 0 then
'			regulate(450/accuracy*GrafikEinstellungen.breite/1920.0,125)
'		end if
'#ifdef __FB_JS__
'		if jj mod 5 = 0 then
'			sleep 1
'		end if
'#endif
	loop until jj >= stopp
	return korrektesRechteckGetroffen(true)
end function

function standardSpielAufgabe.korrektesRechteckGetroffen(letzterDurchlauf as boolean) as trinaer
	dim as short i 
	for i = lbound(variablesRechteckArray) to ubound(variablesRechteckArray) 
		if variablesRechteckArray(i).istPunktDarauf(Punkt(pfeilSchussPositionen(KorrekterPfeilIndex).x,pfeilSchussPositionen(KorrekterPfeilIndex).y)) then
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
 	dim as string text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK)
	dim as Uebersetzungen.textFarbe tf = Uebersetzungen.TextFarbe.ROT
	waehleFarbeFuerPfeil(KorrekterPfeilIndex, tf)
	text = Uebersetzungen.ersetzteFarbennameVonPfeil(Uebersetzungen.Sprache, text, tf)
	GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,3,GrafikEinstellungen.umbruchNach,text, GrafikEinstellungen.skalierungsfaktor)
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
		dim as Uebersetzungen.TextFarbe tf
		variablesPfeilArray(i).farbe = waehleFarbeFuerPfeil(i, tf)
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
	KorrekterPfeilIndex = (int(rnd()*90000) mod getAnzahlDerPfeile())+1
end sub


sub standardSpielAufgabe.zeigeKorrekteWahlAn(i as Short)
	BildschirmHelfer.unlockScreen()
	'Richtiges Rechteck grün:
	dim as integer zielfarbe = RGB(0,255,0)
	dim as integer startfarbe = variablesRechteckArray(i).farbe
	Dim as MaerchenZeit starttime = MaerchenZeitAngeber()
	Dim as Double j = 0
	dim as double dauer = 1.7
	
	do while j < 255 
		BildschirmHelfer.lockscreen()
			j = timelerp(starttime,dauer,0,255)
			variablesRechteckArray(i).anzeigen(GrafikHelfer.farbeUeberblenden(startfarbe, zielfarbe, j))
		BildschirmHelfer.unlockscreen()
	loop
end sub 

sub standardSpielAufgabe.zeigeInkorrekteWahlAn(i as Short, eingabe as Short)
	BildschirmHelfer.unlockScreen()
	if not falschBereitsAngezeigt then
		falschBereitsAngezeigt = true
		
		dim as integer zielfarbe = RGB(255,0,0)
		dim as integer startfarbe = variablesRechteckArray(eingabe).farbe
		
		'Falsches Rechteck rot:
		
		Dim as MaerchenZeit starttime = MaerchenZeitAngeber()
		Dim as Double j = 0
		dim as double dauer = 1.7
		do while j < 255 
			BildschirmHelfer.lockscreen()
				j = timelerp(starttime,dauer,0,255)
				variablesRechteckArray(eingabe).anzeigen( GrafikHelfer.farbeUeberblenden(startfarbe, zielfarbe, j))
			BildschirmHelfer.unlockscreen()
		loop
		
		zielfarbe = RGB(0,255,0)
		startfarbe = variablesRechteckArray(i).farbe
		
		'For...Next-Schleife: Richtiges Rechteck blinkt grün
		For j = 0 To 3
			variablesRechteckArray(i).anzeigen(zielfarbe)
			Sleep 400
			variablesRechteckArray(i).anzeigen(startfarbe)
			Sleep 400
		Next
		variablesRechteckArray(i).anzeigen(zielfarbe)
	end if
end sub
