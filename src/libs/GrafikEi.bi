#Include Once "Punkt.bi"
#Include Once "fbgfx.bi"

Namespace GrafikEinstellungen
		Dim Shared As integer breite, hoehe
		Dim Shared as Single skalierungsfaktor
		Dim Shared As Punkt groesseTextzeichen
		Const DunkleresRot = RGB(185,0,45)
		Dim Shared as Integer umbruchNach = 55
End Namespace 

GrafikEinstellungen.skalierungsfaktor = 1 'Default-Wert setzen
