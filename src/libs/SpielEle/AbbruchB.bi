'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'
#include once "../GrafElem/Rechteck.bi"
#include once "../i18n/Ueberset.bi"
#include once "../GrafikEi.bi"

Type StandardAbbrechenButton extends GrafikElement
	Private:
		Dim AbbrechenRechteck as Rechteck
	Public:
		Declare Constructor()
		Declare virtual sub anzeigen()
		Declare function wurdeGeklickt() as Boolean
		Declare function getAbbrechenRechteck() as Rechteck
End Type

Constructor StandardAbbrechenButton()
	AbbrechenRechteck.x1 = 0+GrafikEinstellungen.breite/20+(GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)
	AbbrechenRechteck.y1 = GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/10
	AbbrechenRechteck.x2 = (GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)*2
	AbbrechenRechteck.y2 =  GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/15 + 18
	AbbrechenRechteck.farbe = RGB(250,100,100)
	AbbrechenRechteck.beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.ABBRECHEN)
end Constructor

Sub StandardAbbrechenButton.anzeigen()
	This.AbbrechenRechteck.anzeigen()
End Sub

Function StandardAbbrechenButton.wurdeGeklickt() As Boolean
	Return AbbrechenRechteck.wirdGeklickt() 
End Function 

Function StandardAbbrechenButton.getAbbrechenRechteck() as Rechteck
	Return AbbrechenRechteck
End Function
