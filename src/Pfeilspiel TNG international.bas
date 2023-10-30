#Include Once "fbgfx.bi"
#Include "textbox.bi"

#ifdef __FB_DOS__ 
ScreenRes  640,480 ,32,2, &h04 Or 8 
#endif
'========================================Dim's==========================================

DIM SHARED AS DOUBLE Pi, Epsilon


Pi = 3.14159265358979323846
Epsilon = 0.000001
Randomize Timer
Dim Shared As FB.Image Ptr img1, img2

'====================================Grafik=============================================


Type Punkt
	as integer x
	as integer y
	Declare Constructor(_x as integer, _y as integer)
	Declare Constructor()
End Type

Namespace MatheHelfer
	Declare Function LogBaseX (ByVal Number As Double, ByVal BaseX As Double) As Double
	Function LogBaseX (ByVal Number As Double, ByVal BaseX As Double) As Double
		LogBaseX = Log( Number ) / Log( BaseX )
		'For reference:   1/log(10)=0.43429448
	End Function
End Namespace

Namespace GrafikEinstellungen
		Dim Shared As integer breite, hoehe, skalierungsfaktor
		Dim Shared As Punkt groesseTextzeichen
End Namespace

GrafikEinstellungen.skalierungsfaktor = 1


Namespace GrafikHelfer

	'Quelle: https://www.freebasic.net/forum/viewtopic.php?t=22261
	Declare sub dickeLinie(byval x1 As Integer,byval y1 As Integer,byval x2 As Integer,byval y2 As Integer,byval size As Integer,byval c As UInteger)
	Sub dickeLinie(byval x1 As Integer,byval y1 As Integer,byval x2 As Integer,byval y2 As Integer,byval size As Integer,byval c As UInteger)
		size = size / 2 ' Durchmesser-> Radius 
		
		if size < 1 then ' auch d�nne Linien erlauben mit eine Dicke von 1
			LINE (x1,y1)-(x2,y2),c
			exit sub
		end if
		
		If x1 = x2 And y1 = y2 Then
			Circle (x1, y1), size, c, , , , f
		Elseif Abs(x2 - x1) >= Abs(y2 - y1) Then
			Dim K As Single = (y2 - y1) / (x2 - x1)
			For I As Integer = x1 To x2 Step Sgn(x2 - x1)
				Circle (I, K * (I - x1) + y1), size, c, , , , f
			Next I
		Else
			Dim L As Single = (x2 - x1) / (y2 - y1)
			For J As Integer = y1 To y2 Step Sgn(y2 - y1)
				Circle (L * (J - y1) + x1, J), size, c, , , , f
			Next J
		End If
	End Sub
	
	Declare Sub ImageScale2x(ByVal Image As ulong Ptr, ByVal Dest As ulong Ptr)
	Sub ImageScale2x(ByVal Image As ulong Ptr, ByVal Dest As ulong Ptr)
		Dim As ulong B, D, E, F, H               '|A|B|C|
		Dim As Long j, k, ic, dc, dp, x, y, pitch'+-+-+-+  / |E0|E1|
		ImageInfo Dest,dp,,,,Dest                   '|D|E|F| E  +--+--+
		ImageInfo image,x,y,,pitch,image            '+-+-+-+  \ |E2|E3|
		pitch \= 4                                  '|G|H|I|
		For k = 0 To y-1
			For j = 0 To x-1
			If k Then B = Image[ic - pitch] Else B = Image[ic]
			If k = y-1 Then H = Image[ic] Else H = Image[ic + pitch]
			If j Then
				D = E
				E = F
			Else
				E = Image[ic]
				D = E
			EndIf
			If j < x-1 Then F = Image[ic + 1]
			If B <> H And D <> F Then
				If D = B Then Dest[dc] = D Else Dest[dc] = E
				If B = F Then Dest[dc + 1] = F Else Dest[dc + 1] = E
				If D = H Then Dest[dc + dp] = D Else Dest[dc + dp] = E
				If H = F Then Dest[dc + dp +1] = F Else Dest[dc + dp +1] = E
			Else
				Dest[dc] = E
				Dest[dc + 1] = E
				Dest[dc + dp] = E
				Dest[dc + dp +1] = E
			End If
			ic +=1
			dc +=2
			Next j
			ic = ic+pitch-x
			dc = dc+((dp-x)*2)
		Next k
	End Sub
		
	declare Function Image_x2(image As Any Ptr) As Any Ptr
	Function Image_x2(image As Any Ptr) As Any Ptr
		Dim image2 As Any Ptr
		Dim As Long b, h
		ImageInfo image, b, h
		b *=2 : h *=2 'Schrifthoehe -breite *2
		image2= ImageCreate(b, h)
		ImageScale2x image, image2
		If image Then ImageDestroy image
		Function = image2
	End Function
	
	
	declare Function Image_downscale(image As Any Ptr, gewuenschteGroesse as Punkt) As Any Ptr
	Function Image_downscale(image As Any Ptr, gewuenschteGroesse as Punkt) As Any Ptr
		Dim image2 As Any Ptr
		Dim As Long b, h
		ImageInfo image, b, h
		image2= ImageCreate(gewuenschteGroesse.x, gewuenschteGroesse.y)
		Dim As Long zaehler_b, zaehler_h, quell_b, quell_h
		for zaehler_b = 0 to gewuenschteGroesse.x-1
			for zaehler_h = 0 to gewuenschteGroesse.y-1
				quell_b = int (1.0*zaehler_b * (1.0*b/gewuenschteGroesse.x))
				quell_h = int (1.0*zaehler_h * (1.0*h/gewuenschteGroesse.y))
				Put image2, (zaehler_b,zaehler_h), image, (quell_b, quell_h)  - (quell_b,quell_h), PSET 'XOR macht auch einen interessanten Effekt mit durchsichtiger Schrift, Schwarz hinterlegt.
			next
		next
		If image Then ImageDestroy image
		Function = image2
	End Function
	
	Declare sub TextSkaliertZeichnen(p as Punkt,text as String, skalierungsfaktor as single, _farbe as Integer = RGB(0,0,0))
	sub TextSkaliertZeichnen(p as Punkt,text as String, skalierungsfaktor as single, _farbe as Integer = RGB(0,0,0))
		Dim As Any Ptr a = ImageCreate( Len(text)*8, 16)
		Draw String a,(0,0), text, _farbe 'mit Font 16x8 in ein Image schreiben
		
		Dim As Integer schritt
		Dim As Single exponent
		exponent = MatheHelfer.LogBaseX(skalierungsfaktor, 2)
		for schritt=1 to int(exponent)
			a= Image_x2(a)
		next
		
		if (exponent - int(exponent))>epsilon Then
			a = Image_x2(a)
			a = Image_downscale(a, Punkt(Len(text)*GrafikEinstellungen.groesseTextzeichen.x*skalierungsfaktor, GrafikEinstellungen.groesseTextzeichen.y*skalierungsfaktor))
		end if
		
		Put (p.x,p.y),a, TRANS
		if a then ImageDestroy a
	end sub
	
	Declare sub zentriertSchreiben(xxx as Integer, yyy as Integer, text as String, skalierungsfaktor as Integer = 1)
	sub zentriertSchreiben(xxx as Integer, yyy as Integer, text as String, skalierungsfaktor as Integer = 1)
		if skalierungsfaktor = 1 then
			Draw String ((xxx-len(text)*GrafikEinstellungen.groesseTextzeichen.x/2),(yyy-GrafikEinstellungen.groesseTextzeichen.y/2)), text
		else
			TextSkaliertZeichnen(Punkt((xxx-len(text)*GrafikEinstellungen.groesseTextzeichen.x/2*skalierungsfaktor),(yyy-GrafikEinstellungen.groesseTextzeichen.y/2*skalierungsfaktor)),text,skalierungsfaktor)
		end if 
	end sub
End Namespace

Type GrafikElement extends object
	Public:
		Declare abstract Sub anzeigen()
	'Private:
		
End Type


Constructor Punkt(_x as integer, _y as integer)
	This.x = _x
	This.y = _y
end Constructor

Constructor Punkt()
	This.x = 0
	This.y = 0
end Constructor

Type KlickbaresGrafikElement extends GrafikElement
	Declare abstract function istPunktDarauf(p as Punkt) as boolean
	Declare abstract function istMausDarauf() as boolean
	Declare abstract function wirdGeklickt() as boolean
End Type

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




'==================================Internationalisation=================================

Namespace Uebersetzungen
	
	enum TextEnum explicit
		WELCHES_LEVEL 
		ABBRECHEN 
		WOLLEN_NEUES_SPIEL 
		JA 
		NEIN 
		WEITER 
		LEVELCODE_PROMPT
		WILLKOMMEN_BEI_LEVEL 
		FALSCHE_EINGABE_ENDE
		PUNKTE_VON_PUNKTE 
		AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK 
		AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK 
		AUSWAHL_RECHTECK_KLICK 
		FALSCH_NEUER_VERSUCH 
		L_E_V_E_L 
		RICHTIG_PLUS_10 
		FALSCH_MINUS_10 
		FALSCH 
	end enum 

	enum SpracheEnum explicit
		DEUTSCH = 1
		ENGLISCH
		FRANZOESISCH
	end enum
		
	Dim Shared Sprache as SpracheEnum
	
	Declare Function uebersetzterText(s as SpracheEnum, t as TextEnum) As String

End Namespace

Function Uebersetzungen.uebersetzterText(s as Uebersetzungen.SpracheEnum, t as Uebersetzungen.TextEnum) As String
	select case T
		case TextEnum.WELCHES_LEVEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Welches Level wollen sie spielen?"
				case SpracheEnum.ENGLISCH: return "Which level do you want to play?"
				case SpracheEnum.FRANZOESISCH: return "Quel niveau voulez-vous jouer? "
			end select
		case TextEnum.ABBRECHEN:
			select case s
				case SpracheEnum.DEUTSCH: return "Abbrechen"
				case SpracheEnum.ENGLISCH: return "cancel"
				case SpracheEnum.FRANZOESISCH: return "Qannuler"
			end select
		case TextEnum.WOLLEN_NEUES_SPIEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Wollen sie ein neues Spiel anfangen?"
				case SpracheEnum.ENGLISCH: return "Do you want to begin a new game?"
				case SpracheEnum.FRANZOESISCH: return "Voulez-vous commencer un nouveau jeu?"
			end select
		case TextEnum.JA:
			select case s
				case SpracheEnum.DEUTSCH: return "Ja"
				case SpracheEnum.ENGLISCH: return "Yes"
				case SpracheEnum.FRANZOESISCH: return "Oui"
			end select
		case TextEnum.NEIN:
			select case s
				case SpracheEnum.DEUTSCH: return "Nein"
				case SpracheEnum.ENGLISCH: return "No"
				case SpracheEnum.FRANZOESISCH: return "Non"
			end select
		case TextEnum.WEITER:
			select case s
				case SpracheEnum.DEUTSCH: return "weiter"
				case SpracheEnum.ENGLISCH: return "proceed"
				case SpracheEnum.FRANZOESISCH: return "a partir de"
			end select
		case TextEnum.LEVELCODE_PROMPT:
			select case s
				case SpracheEnum.DEUTSCH: return "Levelcode? "
				case SpracheEnum.ENGLISCH: return "Password for this level? "
				case SpracheEnum.FRANZOESISCH: return "Mot de passe pour ce niveau? "
			end select
		case TextEnum.WILLKOMMEN_BEI_LEVEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Willkommen bei L E V E L   "
				case SpracheEnum.ENGLISCH: return "Welcome to  L E V E L  "
				case SpracheEnum.FRANZOESISCH: return "Bienvenue au N I V E A U   "
			end select
		case TextEnum.FALSCHE_EINGABE_ENDE:
			select case s
				case SpracheEnum.DEUTSCH: return "Falsche Eingabe. Programm wird geschlossen."
				case SpracheEnum.ENGLISCH: return "Wrong Password. The program will be closed."
				case SpracheEnum.FRANZOESISCH: return "Mot de passe faux. Le programme sera clos."
			end select
		case TextEnum.PUNKTE_VON_PUNKTE:
			select case s
				case SpracheEnum.DEUTSCH: return " Punkte von 100, die noetig sind, um das Level zu beenden."
				case SpracheEnum.ENGLISCH: return " points out of 100, which are necessary to finish the level."
				case SpracheEnum.FRANZOESISCH: return " points sur 100, qui sont necessaires pour terminer le niveau."
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Task: sur lequel le rectangle la fleche rouge pointe-t-elle?"
			end select
		case TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow flies to?"
				case SpracheEnum.FRANZOESISCH: return "T�che: a quel rectangle la fleche rouge vole-t-elle?"
			end select
		case TextEnum.AUSWAHL_RECHTECK_KLICK:
			select case s
				case SpracheEnum.DEUTSCH: return "Zur Auswahl auf das Rechteck klicken."
				case SpracheEnum.ENGLISCH: return "Click on the rectangle to select."
				case SpracheEnum.FRANZOESISCH: return "Cliquez sur le rectangle pour selectionner."
			end select
		case TextEnum.FALSCH_NEUER_VERSUCH:
			select case s
				case SpracheEnum.DEUTSCH: return "Falsche Eingabe. Neuer Versuch: "
				case SpracheEnum.ENGLISCH: return "Incorrect input. Next try: "
				case SpracheEnum.FRANZOESISCH: return "Inconte incorrect. Prochaine tentative: "
			end select
		case TextEnum.L_E_V_E_L:
			select Case s
				case SpracheEnum.DEUTSCH: return "L E V E L   "
				case SpracheEnum.ENGLISCH: return "L E V E L   "
				case SpracheEnum.FRANZOESISCH: return "N I V E A U  "
			end select
		case TextEnum.RICHTIG_PLUS_10:
			select Case s
				case SpracheEnum.DEUTSCH: return "Richtig. Du bekommst 10 weitere Punkte."
				case SpracheEnum.ENGLISCH: return "Right. You get 10 more points."
				case SpracheEnum.FRANZOESISCH: return "C'est vrai. Vous obtenez 10 points de plus."
			end select
		case TextEnum.FALSCH_MINUS_10:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch. Es werden 10 Punkte abgezogen."
				case SpracheEnum.ENGLISCH: return "Incorrect. You loose 10 points."
				case SpracheEnum.FRANZOESISCH: return "Faux. Il y aura 10 points."
			end select
		case TextEnum.FALSCH:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch."
				case SpracheEnum.ENGLISCH: return "Incorrect."
				case SpracheEnum.FRANZOESISCH: return "Faux."
			end select
	end select 'TextId
End Function


'========================================Sub's==========================================
Declare Sub Programm()
Declare Function Wurfparabel overload (WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81) As single
Declare Function Wurfparabel overload (WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81, zoomfactor as single) As single

Sub lockScreen()
  ScreenCopy 0, 1          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
  ScreenSet 1, 0           ' eine Seite anzeigen, w�hrend die andere bearbeitet wird
End Sub

Sub unlockScreen()
  ScreenSet 0, 0           ' die aktive Seite auf die sichtbare Seite einstellen
  ScreenSync               ' auf die Bildschirmaktualisierung warten
  ScreenCopy 1, 0          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
End Sub

Function Wurfparabel(WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81) As single
	Dim As single xx,y,g,v
	Dim As Single B
	B = WinkelInGrad / 180 * Pi 'Winkel
	g = Gravitation'Gravitation
	V = Geschwindigkeit'Geschwindigkeit
	xx = x
	xx = xx - Start_x' Start_x ist eine Koordinate auf dem Bildschirm, genauso wie x
	y = Tan(B)*  XX  -(  g  )/(2*  V^2*Cos( B )^2  )*  XX^2  
	Return (y*-1+Start_y)
End Function

Function Wurfparabel(WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81, zoomfactor as single) As single
	dim as single y
	Geschwindigkeit = Geschwindigkeit / zoomfactor
	Start_x = Start_x / zoomfactor
	Start_y = Start_y / zoomfactor
	x = x / zoomfactor
	y =  Wurfparabel(WinkelInGrad, Geschwindigkeit, Start_x, Start_y, x, Gravitation)
	y = y * zoomfactor
	return y
End Function

Declare Sub Hintergrund(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
Sub Hintergrund(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
 	dim as integer y
 	For y = 0 To GrafikEinstellungen.hoehe
		Dim As Integer ueberblendetes_r, ueberblendetes_g, ueberblendetes_b
		ueberblendetes_r = R1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+R2*((y)/GrafikEinstellungen.hoehe)
		ueberblendetes_g = G1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+G2*((y)/GrafikEinstellungen.hoehe) 
		ueberblendetes_b = B1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+B2*((y)/GrafikEinstellungen.hoehe)
 		Line (0,y)-(GrafikEinstellungen.breite,y),RGB( ueberblendetes_r ,  ueberblendetes_g , ueberblendetes_b )
 	Next
End Sub

Declare Sub FensterSchliessen()
Sub FensterSchliessen()
	'Effekt zum Beenden:
    var img = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(0, 0, 0, 255),32)
    
	Dim as Integer i
    for i = 255 to 0 Step -1
       put (0,0),img,ALPHA,1
       sleep 10
    Next
	'sleep
	'For i = 300 To 0 Step -1
	'	Hintergrund(140*(i/300),0*(i/300),250*(i/300),3*(i/300),250*(i/300),150*(i/300))
	'	Sleep 10
	'Next 
	'Sleep 2000
	imagedestroy img1
	imagedestroy img2
	
	End
End Sub
Sub Ueberblenden()
	Dim as Integer i
    for i = 0 to 255 Step 2
       lockScreen()
       cls
       put (0,0),img2,ALPHA,255
       put (0,0),img1,ALPHA,i
       unlockScreen()
       sleep 10
    Next
End sub
	





Declare Sub AbbrechenButtonZeigen()
Sub AbbrechenButtonZeigen()
	'Abbrechen-Button laden
	Dim Abbrechen As Rechteck
	Abbrechen.x1 = 0+GrafikEinstellungen.breite/20+(GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)
	Abbrechen.y1 = GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/10
	Abbrechen.x2 = (GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)*2
	Abbrechen.y2 =  GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/15 + 18
	Abbrechen.farbe = RGB(250,100,100)
	Abbrechen.beschriftung = Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.ABBRECHEN)
	
	Abbrechen.anzeigen()
End Sub

Declare Function AbbrechenButton() As Integer
Function AbbrechenButton() As Integer
	'Abbrechen-Button laden
	Dim Abbrechen As Rechteck
	Abbrechen.x1 = 0+GrafikEinstellungen.breite/20+(GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)
	Abbrechen.y1 = GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/10
	Abbrechen.x2 = (GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20)*2
	Abbrechen.y2 =  GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/15 + 18
	
	'ZeigeRechteck(Abbrechen,RGB(250,100,100))
	'Draw String ((Abbrechen.x1+Abbrechen.X2)/2-8*4.5,(Abbrechen.y1+Abbrechen.y2)/2-(4)), "Abbrechen"
	If Abbrechen.wirdGeklickt() Then
		Return 1
	Else
		Return 0
		
	EndIf
End Function

Declare Sub ZeigeLogo(Farbe As Integer = 0)
Sub ZeigeLogo(Farbe As Integer = 0)
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

Declare Function Weiterspielen() As Integer
Function Weiterspielen() As Integer
    lockscreen
      GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , img2
	  Hintergrund(215,133,44,129,47,90)

	  Color RGB(0,0,0),RGB(140,0,250)
 	  draw string (10,GrafikEinstellungen.hoehe/2-GrafikEinstellungen.groesseTextzeichen.y/2), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WOLLEN_NEUES_SPIEL)
		dim as Integer j
		j = 2 'Anzahl der Buttons
		
	  'Auswahlbuttons laden:
	  Dim ButtonWeiterspielenJaNein(100) As rechteck
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
	  
	  GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , img1
 	  Put(0,0),img2,pset
 	unlockscreen
 	ueberblenden
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


Declare Sub Warten(Abbrechen As Integer = 0)
Sub Warten(Abbrechen As Integer = 0)
	'Weiter-Button laden
	Dim Weiter As Rechteck
	Weiter.x1 = 0+GrafikEinstellungen.breite/20
	Weiter.y1 = GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/10
	Weiter.x2 = GrafikEinstellungen.breite/7+GrafikEinstellungen.breite/20
	Weiter.y2 =  GrafikEinstellungen.hoehe - GrafikEinstellungen.hoehe/15 + 18
	Weiter.farbe = RGB(100,250,100)
	Weiter.beschriftung = Uebersetzungen.uebersetzterText( Uebersetzungen.Sprache,  Uebersetzungen.TextEnum.WEITER)
	
	Weiter.anzeigen()
	
	Do
		If Abbrechen <>0 Then
			If AbbrechenButton() = 1 Then
			    var weiter = Weiterspielen()
				If weiter = 1 Then
					Programm()
					FensterSchliessen()
					End
				EndIf
				If weiter = 0 Then
					FensterSchliessen()
					end
				EndIf
			EndIf
		EndIf
	Loop Until Weiter.wirdGeklickt()
End Sub
Declare Sub FensterOeffnen()
Sub FensterOeffnen()
	Dim as Integer xx,yy
	ScreenInfo xx, yy
	
	/'
	Print "1           =  640x480"
	Print "2           =  800x600"
	Print "Andere Zahl = Automatisch"
	Print
	Input "Auswahl: ",Eingabe
	'Eingabe = 3
	Select Case eingabe
		Case 1
			xx = 640
			yy = 480
		Case 2
			xx = 800
			yy = 600
	End Select
	If xx <= 800 Then GrafikEinstellungen.breite  = 640  Else GrafikEinstellungen.breite  = 800
	If yy <= 600 Then GrafikEinstellungen.hoehe = 480  Else GrafikEinstellungen.hoehe = 600 
	'If xx > 1024 Then GrafikEinstellungen.breite  = 1024 
	'If yy >  768 Then GrafikEinstellungen.hoehe = 768
	Print "Breite= " & GrafikEinstellungen.breite
	Print "Hoehe = " & GrafikEinstellungen.hoehe'/
	GrafikEinstellungen.breite = xx
	GrafikEinstellungen.hoehe = yy
	
	GrafikEinstellungen.skalierungsfaktor = GrafikEinstellungen.breite/640
	if GrafikEinstellungen.skalierungsfaktor = 0 then
		GrafikEinstellungen.skalierungsfaktor = 1
	end if
	
	ScreenRes  GrafikEinstellungen.breite,GrafikEinstellungen.hoehe ,32,2, &h04 Or 8 
	Width GrafikEinstellungen.breite\8, GrafikEinstellungen.hoehe\16 ' f�r eine Schriftgr��e von 8x16
	' F�r eine Schriftgr��e von 8x14 muss hoch\14 gesetzt
	' werden, f�r eine Schriftgr��e von 8x8 entsprechend hoch\8
	GrafikEinstellungen.groesseTextzeichen.x = 8
	GrafikEinstellungen.groesseTextzeichen.y = 16
	'img1 und img2 vorbereiten
	img1 = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(255, 0, 0, 255),32)
    img2 = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(255, 0, 0, 255),32)

	
	'Starteffekt
	/'Dim As FB.Image Ptr img
	img = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(0, 0, 255, 255),32)
    screenlock
	  Hintergrund(215,133,44,129,47,90)

       GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , img
       cls
    screenunlock
    for i = 0 to 255 Step 2
       lockscreen
          cls
          put (0,0),img,ALPHA,i
       unlockscreen
       sleep 5
    Next
    IMAGEDESTROY img'/
End Sub

Declare function LevelCodeInput( TextField as TextBoxType) as string
function LevelCodeInput( TextField as TextBoxType) as string
 
            dim as string letter
			TextField.SetPrompt(Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.LEVELCODE_PROMPT))
			'Input "Levelcode? ", SEingabe
			TextField.CopyBackground()
            DO
               lockscreen
                 TextField.Redraw()
               unlockscreen
               letter=inkey 'Eingabe abfragen
               if letter<>"" then 'Es wurde etwas eingeben.
                   TextField.NewLetter(letter) 'Zeichen an Textbox weiterreichen.
               end if
               if (asc(letter) = 27) then textfield.setstring("")
               sleep 1 'CPU-Auslastung reduzieren
                
             loop until  asc(letter)=13 'Ende durch ENTER
             return TextField.GetString()
End function 

Declare Sub Sprachauswahl()
Sub Sprachauswahl()
      lockscreen
      get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),img2
	  Hintergrund(215,133,44,129,47,90)

	  Color RGB(0,0,0),RGB(140,0,250)
	  Draw String (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*1),  "DE: Bitte eine Sprache waehlen."
	  Draw String (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*2),  "EN: Please choose a language."
	  Draw String (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  "FR: Veuillez choisir une langue." 'Uebersetzt mit Firefox Translations
	  'init Textbox
	  dim TextField as textboxtype=textboxtype(GrafikEinstellungen.groesseTextzeichen.x*2,GrafikEinstellungen.groesseTextzeichen.y*2,40) 'Neue Textbox erzeugen

      TextField.SetColour(rgb(0,0,0))

    
	
	
	
	  ZeigeLogo(RGB(0,70,100))
	  dim as Integer j,i
	  j = 3 'Anzahl der Sprachen
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
	  get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),img1
	  Put(0,0),img2,pset
	unlockscreen
	ueberblenden
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

Declare Function FrageNachLevel() as Short
Function FrageNachLevel() as Short
    lockscreen
      get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),img2
	  Hintergrund(215,133,44,129,47,90)
	  Color RGB(0,0,0),RGB(140,0,250)
	  Draw String (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*1),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WELCHES_LEVEL)
	  'init Textbox
	  dim TextField as textboxtype=textboxtype(GrafikEinstellungen.groesseTextzeichen.x*2,GrafikEinstellungen.groesseTextzeichen.y*2,40) 'Neue Textbox erzeugen

      TextField.SetColour(rgb(0,0,0))

    
	
	
	
	  ZeigeLogo(RGB(0,70,100))
	  Dim as Integer j, i
	  j = 6 'Anzahl der Level
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

	  get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),img1
	  Put(0,0),img2,pset
	unlockscreen
	ueberblenden

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
	Select Case Level
		Case 1
			Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
			Warten()
			sleep 500
		Case 2 
			SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LSTART1" Or SEingabe = "lstart1" Then
			    Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
				Warten()
				sleep 500
			Else
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE)
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 3
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "S3LEVEL" Or SEingabe = "s3level" Then
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
				Warten()
				sleep 500
			Else
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE)
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 4
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEV4WIS3" Or SEingabe = "lev4wis3" Then
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
				Warten()
				sleep 500
			Else
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE)
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 5
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEVE54321L" Or SEingabe = "leve54321l" Then
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
				Warten()
				sleep 500
			Else
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE)
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 6
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LE654STAR" Or SEingabe = "le654star" Then
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3),  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !"
				Warten()
				sleep 500
			Else
				Draw string (GrafikEinstellungen.groesseTextzeichen.x*2, GrafikEinstellungen.groesseTextzeichen.y*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE)
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
	End Select
	
	return level
End Function

Declare Sub Spielen(level as short)
Sub Spielen(level as short)
	Dim As Integer Punkte, AnzahlRechtecke
	Dim As Integer ende,jj,x_alt,y_alt
	Dim Abstand As Integer
	
	Abstand = GrafikEinstellungen.groesseTextzeichen.y + 1
	If Level = 1 Then
		AnzahlRechtecke = 5
	EndIf
	If Level = 2 Then
		AnzahlRechtecke = 9
	EndIf
	If Level = 3  Then
		AnzahlRechtecke = 17
	EndIf
	If Level = 4 Then
		AnzahlRechtecke = 27
	EndIf
	If Level = 5 Then
		AnzahlRechtecke = 9
	EndIf
	If Level = 6 Then
		AnzahlRechtecke = 17
	EndIf
	If level < 1 Or level > 6 Then
		AnzahlRechtecke = 1
	EndIf
	
	
	
	Dim AktuellerPfeil As Pfeil
	AktuellerPfeil.farbe = RGB(185,0,45)
	Color RGB(0,0,0),RGB(255,255,255)
	Punkte = 0
	

	'Rechtecke laden
	Dim RechteckVar(100) As Rechteck
	Dim as Integer i
	For i = 1 To AnzahlRechtecke
		RechteckVar(i).x1 = GrafikEinstellungen.breite-GrafikEinstellungen.breite/4
		RechteckVar(i).x2 = GrafikEinstellungen.breite-GrafikEinstellungen.hoehe/70
		RechteckVar(i).y1 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/AnzahlRechtecke * (i-1) +(GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/70
		RechteckVar(i).y2 = (GrafikEinstellungen.hoehe-GrafikEinstellungen.hoehe/70)/AnzahlRechtecke * (i)
		RechteckVar(i).farbe = RGB(0,100,255)
	Next
	Do
	    GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , img2
	    lockscreen
		'Cls
		Hintergrund(215,133,44,129,47,90)
		Draw String (0,0), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.L_E_V_E_L) & Level  
		Draw String (0,0+Abstand*1), "" & Punkte & Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PUNKTE_VON_PUNKTE)
		
		If Level <= 4 Then
			Draw String (0,0+Abstand*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK)
		Else
			Draw String (0,0+Abstand*3), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK)
		EndIf
		Draw String (0,0+Abstand*4), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUSWAHL_RECHTECK_KLICK)
		'per Zufall Pfeil erzeugen
		If level <= 4 Then
			AktuellerPfeil.x1 = 10 
			AktuellerPfeil.y1 =GrafikEinstellungen.hoehe/2                                                                          
			AktuellerPfeil.laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
			AktuellerPfeil.Richtung = Rnd()*(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)-(68*GrafikEinstellungen.hoehe/GrafikEinstellungen.breite)/2                                                           '|
		ElseIf level >= 5 then
			Do
				AktuellerPfeil.x1 = 10 
				AktuellerPfeil.y1 =GrafikEinstellungen.hoehe/2                                                                          
				AktuellerPfeil.laenge = (GrafikEinstellungen.breite+GrafikEinstellungen.hoehe)/2 /6                                                                                                                          
				AktuellerPfeil.Richtung = Rnd()*180-180/2
				For i = 0 To anzahlrechtecke
					If RechteckVar(i).istPunktDarauf(	Punkt(	RechteckVar(i).x1,int(Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,							AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,RechteckVar(i).x1, 9.81, GrafikEinstellungen.skalierungsfaktor)))						) Then
							Exit Do
					EndIf
				Next
			Loop		
		EndIf
		
		
		AktuellerPfeil.anzeigen()

		For i = 1 To AnzahlRechtecke
			RechteckVar(i).anzeigen()
		Next
		
		'�berblenden
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , img1
		Put(0,0),img2,pset
		unlockscreen
		ueberblenden()
		
		'Eingabe machen
		Dim as Integer Eingabe
		Do
			'If AbbrechenButton() = 1 Then end
			For i = 1 To AnzahlRechtecke
				If RechteckVar(i).wirdGeklickt() Then
					Eingabe = i
					exit do
				EndIf
			Next
		Loop
		If Eingabe = 0 Then End
		
		'Richtung des AktuellerPfeils einzeichnen
		dim as single x, y
		x = AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '_ Hier wird der Start f�r das einzeichnen auf die AktuellerPfeilspitze gesetzt.
		y = AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '/
		If level >= 5 Then 
				AktuellerPfeil.x1 = x 'X und Y m�ssen neu gespeichert werden, da diese Variablen noch gebraucht werden, die Werte aber nicht ge�ndert
				AktuellerPfeil.y1 = y 'werden d�rfen. Die "Orginale" AktuellerPfeil.x1 und AktuellerPfeil.y1 werden nicht mehr gebraucht.
		EndIf
		'Die folgende For...Next-Schleife zeichnet eine Linie der AktuellerPfeilrichtung Pixel-f�r-Pixel ein:
		ende = 0 'ende = 1 : Schleife wird abgebrochen
		For jj = 0 To Sqr(GrafikEinstellungen.breite^2+(GrafikEinstellungen.hoehe/4)^2)'ca. max. L�nge einer schr�gen Linie
			'lockScreen
			If level <= 4 Then 'Gerade Linie, durch (Co)Sinus berechnet
				x = x + COS((AktuellerPfeil.Richtung*Pi)/180)*1
				y = y + SIN((AktuellerPfeil.Richtung*Pi)/180)*1
				GrafikHelfer.dickeLinie  Int(x),Int(y),Int(x),Int(y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
			Else
				x_alt = x
				y_alt = y
				x = jj
				y = int(Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1,AktuellerPfeil.y1,x,  9.81, GrafikEinstellungen.skalierungsfaktor))
				If x >= AktuellerPfeil.x1 Then
					GrafikHelfer.dickeLinie  Int(x_alt),Int(y_alt),Int(x),Int(y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
				EndIf
				'Locate 1,1 : Print "x: " & x & " Y: " & Y
			EndIf
				
			'unlockScreen
			'Testen, ob Pixel auf einem Rechteck ist
			For i = 1 To AnzahlRechtecke
				If RechteckVar(i).istPunktDarauf(Punkt(x,y)) Then
					If i = Eingabe Then 

						Color RGB(0,255,0),RGB(255,255,255)
						Draw String (0,0+Abstand*GrafikEinstellungen.groesseTextzeichen.x),Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.RICHTIG_PLUS_10),RGB(0,255,0)
						Color RGB(0,0,0),RGB(255,255,255)
						Punkte = Punkte + 10
						

						
						'Richtiges Rechteck gr�n:
						Dim as Integer j
						For j = 0 To 255
							RechteckVar(i).anzeigen(RGB(0,j,255-j))
							Sleep 2
						Next



						
					Else
						'Print 
						'Print
						If Punkte > 0 Then 
							Color RGB(255,0,0),RGB(255,255,255)
							Draw String (0,0+Abstand*8), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH_MINUS_10),RGB(255,0,0)
							Color RGB(0,0,0),RGB(255,255,255)
							Punkte = Punkte - 10
						Else
							Color RGB(255,0,0),RGB(255,255,255)
							Draw String (0,0+Abstand*8), Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH),RGB(255,0,0)
							Color RGB(0,0,0),RGB(255,255,255)
						EndIf
						
						'ZeigeRechteck(Rechteck(Eingabe),RGB(255,0,0))


						
						'Falsches Rechteck rot:
						Dim as Integer j
						For j = 0 To 255
							RechteckVar(eingabe).anzeigen(RGB(j,0,255-j))
							Sleep 2
						Next
						'For...Next-Schleife: Richtiges Rechteck blinkt gr�n
						For j = 0 To 3
							RechteckVar(i).anzeigen(RGB(0,255,0))
							Sleep 400
							RechteckVar(i).anzeigen(RGB(0,100,255))
							Sleep 400
						Next
					EndIf
					ende = 1
				EndIf
			Next
			sleep 1'CPU schonen
			If ende = 1 Then Exit For
		Next
		AbbrechenButtonZeigen()
		Warten(1)
		'Sleep'Warten
	Loop Until Punkte >= 100

	Sleep 800
	Select Case Uebersetzungen.Sprache
		Case 1:
			Select Case level
				Case 1 
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte und damit das Level geloest!  ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"Um das naechste Level spielen zu koennen, brauchst du",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"einen Freischaltcode. Dieser lautet:     LSTART1     ",RGB(255,200,15)
				Case 2
					Draw String (0,0+Abstand*14),"Super! Nun hast du mit 100 Punkten auch Level 2 durch-",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"gespielt. Hier ist der naechste Freischaltcode fuer ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"das Level 3:    S3LEVEL      Viel Spass!            ",RGB(255,200,15)
				Case 3
					Draw String (0,0+Abstand*14),"Du hast nun die Haelfte aller Level gespielt! Weiter",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"so! Der naechste Levelcode fuer das Level 4 heisst:  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"   LEV4WIS3                                          ",RGB(255,200,15)
				Case 4
					
					Draw String (0,0+Abstand*14),"Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"fehlen demnach noch 2. Der Levelcode fuer das Level 5  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"lautet:    LEVE54321L                                ",RGB(255,200,15)
				Case 5
					Draw String (0,0+Abstand*14),"Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"noch das Level 6. Auch dafuer gibt es wieder einen  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"Code:    LE654STAR                                    ",RGB(255,200,15)
				Case 6
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte und das Level geloest! Damit  ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"hast du auch das komplette Spiel durchgespielt! Herz-",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"lichen Glueckwunsch!     ",RGB(255,200,15)
				Case Else
					
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"aber nichts besonderes ist, haettest du das Spiel gar ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"nicht spielen brauchen...",RGB(255,200,15)
			End Select
		Case 2:
			Select Case level
				Case 1 
					Draw String (0,0+Abstand*14),"You now have 100 points and solved the level! To be   ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"able to play the next level, you will need an unlock  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"code. This is: LSTART1                                ",RGB(255,200,15)
				Case 2
					Draw String (0,0+Abstand*14),"Great! Now you have played through level 2 with 100   ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"points. Here is the next unlock code for the level 3: ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"          S3LEVEL      Have fun!                      ",RGB(255,200,15)
				Case 3:                   
					Draw String (0,0+Abstand*14),"You have now played half of all levels! Continue like",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"this! The next level code for level 4 is:            ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"   LEV4WIS3                                          ",RGB(255,200,15)
				Case 4
					Draw String (0,0+Abstand*14),"You have already played through 4 of 6 levels. Great!",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"Now 2 more to go. The level code for level 5 is: ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"   LEVE54321L                                ",RGB(255,200,15)
				Case 5
					Draw String (0,0+Abstand*14),"You have almost completed the game. Now only level 6 ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"is missing. For which there is again a code for this ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"level too::   LE654STAR                              ",RGB(255,200,15)
				Case 6
					Draw String (0,0+Abstand*14),"You now have 100 points and solved the level! With this",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"you have played through the whole game! That's great!  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"Congratulations!",RGB(255,200,15)
				Case Else
					Draw String (0,0+Abstand*14),"You now have 100 points! Since that is with only ONE",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"rectangle but nothing special, you wouldn't have to ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"play the game at all..",RGB(255,200,15)
			End Select
		Case 3:
		    'TODO: Muss noch �bersetzt werden (auf Franz�sisch)
			Select Case level
				Case 1 
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte und damit das Level geloest!  ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"Um das naechste Level spielen zu koennen, brauchst du",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"einen Freischaltcode. Dieser lautet:     LSTART1     ",RGB(255,200,15)
				Case 2
					Draw String (0,0+Abstand*14),"Super! Nun hast du mit 100 Punkten auch Level 2 durch-",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"gespielt. Hier ist der naechste Freischaltcode fuer ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"das Level 3:    S3LEVEL      Viel Spass!            ",RGB(255,200,15)
				Case 3
					Draw String (0,0+Abstand*14),"Du hast nun die Haelfte aller Level gespielt! Weiter",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"so! Der naechste Levelcode fuer das Level 4 heisst:  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"   LEV4WIS3                                          ",RGB(255,200,15)
				Case 4
					
					Draw String (0,0+Abstand*14),"Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"fehlen demnach noch 2. Der Levelcode fuer das Level 5  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"lautet:    LEVE54321L                                ",RGB(255,200,15)
				Case 5
					Draw String (0,0+Abstand*14),"Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"noch das Level 6. Auch dafuer gibt es wieder einen  ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"Code:    LE654STAR                                    ",RGB(255,200,15)
				Case 6
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte und das Level geloest! Damit  ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"hast du auch das komplette Spiel durchgespielt! Herz-",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"lichen Glueckwunsch!     ",RGB(255,200,15)
				Case Else
					
					Draw String (0,0+Abstand*14),"Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck ",RGB(255,200,15)
					Draw String (0,0+Abstand*15),"aber nichts besonderes ist, haettest du das Spiel gar ",RGB(255,200,15)
					Draw String (0,0+Abstand*16),"nicht spielen brauchen...",RGB(255,200,15)
			End Select
	End Select 'Sprache
	


	Warten()
End Sub

Sub Programm()
    Sprachauswahl()
	Do
		Dim as Short level
		level = FrageNachLevel()
		Spielen(level)
	Loop Until Weiterspielen() = 0
End Sub


'=======================================Programm===================================
FensterOeffnen()
Programm()
FensterSchliessen()
End
