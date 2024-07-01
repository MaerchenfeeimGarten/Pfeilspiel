'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'


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

'===================================SpielAufgabe/das Letzte==============================


type SpielAufgabeDasLetzte extends standardSpielAufgabe
	declare virtual sub zeichneAufgabenstellung()
	declare virtual function korrektesRechteckGetroffen(letzterDurchlauf as boolean = false) as trinaer 'Prüft, ob das korrekte Rechteck getroffen wurde. Wird von pfeilRichtungVerfolgen() genutzt.
end type

function SpielAufgabeDasLetzte.korrektesRechteckGetroffen(letzterDurchlauf as boolean) as trinaer
	
	dim as short i 
	for i = lbound(variablesRechteckArray) to ubound(variablesRechteckArray) 
		if variablesRechteckArray(i).istPunktDarauf(Punkt(pfeilSchussPositionen(KorrekterPfeilIndex).x,pfeilSchussPositionen(KorrekterPfeilIndex).y)) then
			korrektesRechteck = i
		end if
	Next
	if korrektesRechteck <> -1 and letzterDurchlauf Then
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

sub SpielAufgabeDasLetzte.zeichneAufgabenstellung()
	dim as string text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEITG_AUF_LETZTES_RECHTECK)
	dim as Uebersetzungen.textFarbe tf = Uebersetzungen.TextFarbe.ROT
	waehleFarbeFuerPfeil(KorrekterPfeilIndex, tf)
	text = Uebersetzungen.ersetzteFarbennameVonPfeil(Uebersetzungen.Sprache, text, tf)
	GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,3,GrafikEinstellungen.umbruchNach ,text, GrafikEinstellungen.skalierungsfaktor)
end sub 
