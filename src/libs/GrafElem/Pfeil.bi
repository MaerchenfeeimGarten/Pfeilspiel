#include once "GElement.bi"
#Include once "fbgfx.bi"

Type Pfeil extends GrafikElement
	public:
		AS INTEGER x1
		AS INTEGER y1
		As INTEGER laenge
		AS INTEGER Richtung
		AS INTEGER farbe
		Declare virtual sub anzeigen()
		Declare sub anzeigen(_Farbe as integer)
End Type

sub Pfeil.anzeigen(_Farbe As integer)
	GrafikHelfer.dickeLinie This.x1,This.y1, This.x1+COS((This.Richtung*Pi)/180)*This.laenge,This.y1+SIN((This.Richtung*Pi)/180)*This.laenge,GrafikEinstellungen.skalierungsfaktor, _Farbe
	GrafikHelfer.dickeLinie This.x1+COS((This.Richtung*Pi)/180)*This.laenge, This.y1+SIN((This.Richtung*Pi)/180)*This.laenge, This.x1+COS((This.Richtung*Pi)/180)*This.laenge+   COS(((This.Richtung+130)*Pi)/180)*This.laenge/4,   This.y1+SIN((This.Richtung*Pi)/180)*This.laenge+   SIN(((This.Richtung+130)*Pi)/180)*This.laenge/4,GrafikEinstellungen.skalierungsfaktor, _Farbe
	GrafikHelfer.dickeLinie This.x1+COS((This.Richtung*Pi)/180)*This.laenge,This.y1+SIN((This.Richtung*Pi)/180)*This.laenge, This.x1+COS((This.Richtung*Pi)/180)*This.laenge+   COS(((This.Richtung-130)*Pi)/180)*This.laenge/4,   This.y1+SIN((This.Richtung*Pi)/180)*This.laenge+   SIN(((This.Richtung-130)*Pi)/180)*This.laenge/4,GrafikEinstellungen.skalierungsfaktor, _Farbe
End Sub


sub Pfeil.anzeigen()
	This.anzeigen(This.farbe)
End Sub


 
