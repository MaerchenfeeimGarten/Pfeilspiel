#Include Once "fbgfx.bi"
#Include once "../../libs/Textbox/textbox.bi"
#Include once "../../libs/Punkt.bi"
#Include once "../../libs/MathHelf.bi"
#Include once "../../libs/GrafikEi.bi"
#Include once "../../libs/Bildschi.bi"
#Include once "../../libs/GrafikHe.bi"
#Include once "../../libs/GrafElem/Pfeil.bi"
#Include once "../../libs/GrafElem/Rechteck.bi"
#Include once "../../libs/i18n/Ueberset.bi"
#Include once "../../libs/timer/delay.bi"
#Include once "../../libs/SpielEle/AbbruchB.bi"
#Include once "../../libs/SpielEle/Logo.bi"
#Include once "../../libs/Bildschi.bi"

#Include once "Saufgabe.bi"

'===================================SpielAufgabe/Mit Farben==============================


type SpielAufgabeFarben extends standardSpielAufgabe
	declare virtual sub zeichneAufgabenstellung()
	declare virtual function korrektesRechteckGetroffen(letzterDurchlauf as boolean = false) as trinaer 'Prüft, ob das korrekte Rechteck getroffen wurde. Wird von pfeilRichtungVerfolgen() genutzt.
	declare virtual sub rechteckeGenerieren()
	declare virtual sub pfeileGenerieren()
	declare sub setDurcheinander(t as boolean)
	protected:
		as Integer farben(0 to 2)
		as short korrekteFarbeIndex = -1
		as boolean durcheinander = false
end type

sub SpielAufgabeFarben.setDurcheinander(t as boolean)
	this.durcheinander = t
end sub
sub SpielAufgabeFarben.pfeileGenerieren()
    'setAnzahlDerPfeile(20)
    
	RedimPfeilArray(getAnzahlDerPfeile())
	Redim pfeilSchussPositionen (1 to getAnzahlDerPfeile())
	Dim as Short i
	For i = 1 To getAnzahlDerPfeile()
		dim as Uebersetzungen.TextFarbe tf = Uebersetzungen.TextFarbe.ROT
		variablesPfeilArray(i).farbe = waehleFarbeFuerPfeil(i,tf)
		variablesPfeilArray(i).x1 = 10+rnd()* GrafikEinstellungen.breite/3.5
		variablesPfeilArray(i).y1 =GrafikEinstellungen.hoehe/2 + (rnd()-0.5)*GrafikEinstellungen.hoehe/1.5                                                   
		variablesPfeilArray(i).laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          

		
		Do
			variablesPfeilArray(i).Richtung = Rnd()*180 - 90
			
			pfeilSchussPositionen(i).x = variablesPfeilArray(i).x1+ COS((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge
			pfeilSchussPositionen(i).y = variablesPfeilArray(i).y1+ SIN((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge
			
			'variablesPfeilArray(i).y1+ COS(...)*laenge_pfeil = x_wert
			'variablesPfeilArray(i).y1+laenge_am_ende* COS(...) = GrafikEinstellungen.breite  | - variablesPfeilArray(i).y1
			'laenge_am_ende*COS(...) = GrafikEinstellungen.breite - variablesPfeilArray(i).y1 | / COS(...)
' 			' laenge_am_ende = (GrafikEinstellungen.breite - variablesPfeilArray(i).y1)/COS(...) 
			dim as single laenge_am_ende = (GrafikEinstellungen.breite - GrafikEinstellungen.hoehe/70 - variablesPfeilArray(i).y1) / COS((variablesPfeilArray(i).Richtung*Pi)/180.0) 
			
			dim as single y_am_ende = variablesPfeilArray(i).y1+ SIN((variablesPfeilArray(i).Richtung*Pi)/180)*laenge_am_ende 
			
			if y_am_ende >= 0 and  y_am_ende <= GrafikEinstellungen.hoehe then
				exit do
			end if
		loop
	Next
end sub

function SpielAufgabeFarben.korrektesRechteckGetroffen(letzterDurchlauf as boolean) as trinaer
	
	dim as short i 
	for i = lbound(variablesRechteckArray) to ubound(variablesRechteckArray) 
		if variablesRechteckArray(i).istPunktDarauf(Punkt(pfeilSchussPositionen(KorrekterPfeilIndex).x,pfeilSchussPositionen(KorrekterPfeilIndex).y)) and variablesRechteckArray(i).farbe = farben(korrekteFarbeIndex) then
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

sub SpielAufgabeFarben.rechteckeGenerieren()
	RedimRechteckArray(getAnzahlDerRechtecke())
	
	farben(0) = RGB(255,100,100)
	farben(1) = RGB(100,255,100)
	farben(2) = RGB(100,100,255)
	
	dim i as Short
	For i = 1 To getAnzahlDerRechtecke()
		variablesRechteckArray(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
		variablesRechteckArray(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
		variablesRechteckArray(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/getAnzahlDerRechtecke * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
		variablesRechteckArray(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/getAnzahlDerRechtecke * (i)
		variablesRechteckArray(i).farbe = farben(i mod 3)
		if durcheinander then
			dim as integer verschiebung = (rnd()-0.56)*-GrafikEinstellungen.breite/4*0.9
			variablesRechteckArray(i).x1 += verschiebung
			variablesRechteckArray(i).x2 += verschiebung
		end if
	Next
	
	korrekteFarbeIndex = rnd()*30000 mod 3
end sub

sub SpielAufgabeFarben.zeichneAufgabenstellung()
	dim as string text
	select case korrekteFarbeIndex
		case 0:
			text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_ROTES_RECHTECK)
		case 1:
			text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_GRUENES_RECHTECK)
		case 2:
			text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_BLAUES_RECHTECK)
	end select
	
	dim as Uebersetzungen.textFarbe tf = Uebersetzungen.TextFarbe.ROT
	waehleFarbeFuerPfeil(KorrekterPfeilIndex, tf)
	text = Uebersetzungen.ersetzteFarbennameVonPfeil(Uebersetzungen.Sprache, text, tf)
	GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,3,GrafikEinstellungen.umbruchNach, text, GrafikEinstellungen.skalierungsfaktor)

end sub 
