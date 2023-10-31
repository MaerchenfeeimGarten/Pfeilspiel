#include once "KlickbaresGrafikelement.bi"
#include once "../Punkt.bi"
#include once "../GrafikEinstellungen.bi"
#include once "../GrafikHelfer.bi"

Type Rechteck extends KlickbaresGrafikElement
	public:
		AS INTEGER x1
		AS INTEGER y1
		AS INTEGER x2
		AS INTEGER y2
		AS String beschriftung
		AS INTEGER farbe
		AS INTEGER farbe_rand
		Declare virtual function istPunktDarauf(p as Punkt) as boolean
		Declare virtual function istMausDarauf() as boolean
		Declare virtual function wirdGeklickt() as boolean
		Declare virtual sub anzeigen()
		Declare virtual sub anzeigen(Farbe as Integer)
		Declare Constructor()
	private:
		Declare Sub beschriftenMit(text as String)
End Type

Constructor Rechteck()
	This.beschriftung = ""
	This.farbe_rand = RGB(100,100,100)
end Constructor


sub Rechteck.beschriftenMit(text as String)
	GrafikHelfer.zentriertSchreiben((x1+x2)/2, (y1 + y2)/2, text, GrafikEinstellungen.skalierungsfaktor)
end sub

virtual function Rechteck.istPunktDarauf(p as Punkt) as boolean
	If p.x >= x1 And p.x <= x2 Then
		If p.y >= y1 And p.y <= y2  Then
			Return true
		EndIf
	EndIf
	return false
End Function

sub Rechteck.anzeigen(_farbe as Integer)
    Line (This.x1,This.y1)-(This.x2,This.y2),This.farbe_rand,BF
	Line (This.x1+GrafikEinstellungen.skalierungsfaktor,This.y1+GrafikEinstellungen.skalierungsfaktor)-(This.x2-GrafikEinstellungen.skalierungsfaktor,This.y2-GrafikEinstellungen.skalierungsfaktor),_farbe,BF
	
	This.beschriftenMit(This.beschriftung)
End Sub

sub Rechteck.anzeigen()
	This.anzeigen(This.farbe)
End Sub


Function Rechteck.istMausDarauf() As boolean
	Dim As Integer Mx, My
	GetMouse Mx,My
	Return This.istPunktDarauf(Punkt(Mx,My))
End Function

Function Rechteck.wirdGeklickt() As boolean
	Dim As Integer MM,MDruck
	GetMouse MM,MM,MM,MDruck
	If MDruck And 1 Then
		If This.istMausDarauf() Then
			Return True
		EndIf
	EndIf
	return False
End Function 
  
