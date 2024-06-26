'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'

#include once "../GrafikEi.bi"
#include once "../GrafikHe.bi"

Declare Sub ZeichneLogo(Farbe As Integer = 0)
Sub ZeichneLogo(Farbe As Integer = 0)
	GrafikHelfer.dickeLinie( GrafikEinstellungen.breite*0.05,GrafikEinstellungen.hoehe*0.3  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe)    'Vertilaler Strich von P
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05,GrafikEinstellungen.hoehe*0.3  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15,GrafikEinstellungen.hoehe*0.375 -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von P
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05,GrafikEinstellungen.hoehe*0.45 -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15,GrafikEinstellungen.hoehe*0.375 -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von P
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.3  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von F
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.3  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.3   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von F
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.45 -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.45  -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von F
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.3   -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2 ,GrafikEinstellungen.hoehe*0.3  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.3   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.45  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.45  -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Mittlerer Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.6  -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von E
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3,GrafikEinstellungen.hoehe*0.3   -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'I
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.3   -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von L
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6   -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6  -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von L
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*4.2,GrafikEinstellungen.hoehe*0.45  -GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*4.2,GrafikEinstellungen.hoehe*0.45  -GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    '-
	
	
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.3   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Linker Vertilaler Strich von S
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*0 ,GrafikEinstellungen.hoehe*0.3  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.3   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von S
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Mittlerer Strich von S
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von S
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*0,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe		'Rechter Vertikaler Strich vom S
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.3  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von P
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.3  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.375 +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von P
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.45 +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13,GrafikEinstellungen.hoehe*0.375 +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von P
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.3  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'I
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.3   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2.2 ,GrafikEinstellungen.hoehe*0.3  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.3   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Oberer Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.45  +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Mittlerer Strich von E
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*2.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von E
	
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.3   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Vertilaler Strich von L
	GrafikHelfer.dickeLinie GrafikEinstellungen.breite*0.05 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25, GrafikEinstellungen.breite*0.15 +GrafikEinstellungen.breite*0.13*3.2,GrafikEinstellungen.hoehe*0.6   +GrafikEinstellungen.hoehe*0.25,GrafikEinstellungen.skalierungsfaktor, Farbe    'Unterer Strich von L
End Sub
 
