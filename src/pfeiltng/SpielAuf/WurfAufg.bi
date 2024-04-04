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

'=======================================SpielAufgabe/Wurf================================


type SpielAufgabenWurf extends standardSpielAufgabe
	declare  virtual sub pfeilRichtungsVerfolgungInkrement(jj as integer) 'Jeweils ein Schritt des Liniezeichens der Pfeile. Wird von pfeilRichtungVerfolgen() genutzt.
	declare  virtual sub pfeileGenerieren()
	declare  virtual sub zeichneAufgabenstellung()
end type

sub SpielAufgabenWurf.pfeilRichtungsVerfolgungInkrement(jj as integer)
	dim as integer i, y_min_1,x,y
	for i = lbound(pfeilSchussPositionen) to ubound(pfeilSchussPositionen)
	
		x = this.variablesPfeilArray(i).x1+ COS((this.variablesPfeilArray(i).Richtung*Pi)/180)*this.variablesPfeilArray(i).laenge '_ Hier wird der Start für das einzeichnen auf die AktuellerPfeilspitze gesetzt.
		y = this.variablesPfeilArray(i).y1+ SIN((this.variablesPfeilArray(i).Richtung*Pi)/180)*this.variablesPfeilArray(i).laenge '/
	
		pfeilSchussPositionen(i).x = jj
		pfeilSchussPositionen(i).y = int(Mathehelfer.Wurfparabel(this.variablesPfeilArray(i).Richtung*-1,this.variablesPfeilArray(i).laenge,x,y,pfeilSchussPositionen(i).x,  9.81, GrafikEinstellungen.skalierungsfaktor))
		y_min_1 = int(Mathehelfer.Wurfparabel(this.variablesPfeilArray(i).Richtung*-1,this.variablesPfeilArray(i).laenge,x,y,pfeilSchussPositionen(i).x-1,  9.81, GrafikEinstellungen.skalierungsfaktor))
		If  pfeilSchussPositionen(i).x >= x Then
			GrafikHelfer.dickeLinie  Int(pfeilSchussPositionen(i).x-1),Int(y_min_1),Int(pfeilSchussPositionen(i).x),Int(pfeilSchussPositionen(i).y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
		EndIf
	next
end sub

sub SpielAufgabenWurf.zeichneAufgabenstellung()
	dim as string text = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK)
	dim as Uebersetzungen.textFarbe tf = Uebersetzungen.TextFarbe.ROT
	waehleFarbeFuerPfeil(KorrekterPfeilIndex, tf)
	text = Uebersetzungen.ersetzteFarbennameVonPfeil(Uebersetzungen.Sprache, text, tf)
	GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,3,GrafikEinstellungen.umbruchNach,text, GrafikEinstellungen.skalierungsfaktor)
end sub

sub SpielAufgabenWurf.pfeileGenerieren()
	RedimPfeilArray(getAnzahlDerPfeile())
	Redim pfeilSchussPositionen (1 to getAnzahlDerPfeile())
	Dim as Short i,j
	For i = 1 To getAnzahlDerPfeile()
		Do
			dim as Uebersetzungen.TextFarbe ft = Uebersetzungen.TextFarbe.ROT
			variablesPfeilArray(i).farbe = waehleFarbeFuerPfeil(i, ft)
			variablesPfeilArray(i).x1 = 10 
			variablesPfeilArray(i).y1 =GrafikEinstellungen.hoehe/2                                                                          
			variablesPfeilArray(i).laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
			variablesPfeilArray(i).Richtung = Rnd()*180-180/2
			For j = 1 To getAnzahlDerRechtecke()
				If variablesRechteckArray(j).istPunktDarauf(	Punkt(	variablesRechteckArray(j).x1,int(MatheHelfer.Wurfparabel(variablesPfeilArray(i).Richtung*-1,variablesPfeilArray(i).laenge,variablesPfeilArray(i).x1+ COS((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge,							variablesPfeilArray(i).y1+ SIN((variablesPfeilArray(i).Richtung*Pi)/180)*variablesPfeilArray(i).laenge,variablesRechteckArray(j).x1, 9.81, GrafikEinstellungen.skalierungsfaktor)))						) Then
						Exit Do
				EndIf
			Next
			sleep 1
		Loop	
	Next
end sub

