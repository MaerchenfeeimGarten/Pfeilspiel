'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'
#Include Once "fbgfx.bi"
#Include "textbox.bi"
'========================================Dim's==========================================
Dim Shared As Integer i,j,Eingabe,Level
Dim Shared As Single x,y
Dim Shared As Integer xx,yy,Text_x,Text_y
DIM SHARED AS DOUBLE Pi
Dim Shared As String SEingabe
Dim Shared As integer hoehe,breite'Im ganzen Programm vertauscht!!!!!!!
Pi = 3.14159265358979323846
Randomize Timer
Dim Shared As FB.Image Ptr img1, img2
    
'========================================Type===========================================
Type Pfeil
AS INTEGER x1
AS INTEGER y1
As INTEGER laenge
AS INTEGER Richtung
End Type
Type Rechteck
AS INTEGER x1
AS INTEGER y1
AS INTEGER x2
AS INTEGER y2
End Type




'========================================Sub's==========================================
Declare Sub Programm()
Declare Function Wurfparabel(WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81) As Integer

Sub lockScreen()
  ScreenCopy 0, 1          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
  ScreenSet 1, 0           ' eine Seite anzeigen, während die andere bearbeitet wird
End Sub

Sub unlockScreen()
  ScreenSet 0, 0           ' die aktive Seite auf die sichtbare Seite einstellen
  ScreenSync               ' auf die Bildschirmaktualisierung warten
  ScreenCopy 1, 0          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
End Sub

Function Wurfparabel(WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81) As Integer
	Dim As Integer xx,y,g,v
	Dim As Single B
	B = WinkelInGrad / 180 * Pi 'Winkel
	g = Gravitation'Gravitation
	V = Geschwindigkeit'Geschwindigkeit
	xx = x
	xx = xx - Start_x' Start_x ist eine Koordinate auf dem Bildschirm, genauso wie x
	y = Tan(B)*  XX  -(  g  )/(2*  V^2*Cos( B )^2  )*  XX^2  
	Return y*-1+Start_y 	
End Function

Declare Sub Hintergrund(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
Sub Hintergrund(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
 	For y = 0 To breite
 		Line (0,y)-(hoehe,y),RGB(R1*((breite-y)/breite)+R2*((y)/breite)  ,  G1*((breite-y)/breite)+G2*((y)/breite)  ,  B1*((breite-y)/breite)+B2*((y)/breite))
 	Next
End Sub

Declare Sub FensterSchliessen()
Sub FensterSchliessen()
	'Effekt zum Beenden:
    var img = Imagecreate(hoehe, breite, RGBA(0, 0, 0, 255),32)
 
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
    for i = 0 to 255 Step 2
       cls
       put (0,0),img2,ALPHA,255
       put (0,0),img1,ALPHA,i
       
       sleep 10
    Next
End sub

Declare sub ZeigeRechteck(Rechteck As Rechteck,Farbe As Integer)
sub ZeigeRechteck(Rechteck As Rechteck,Farbe As Integer)
	Line (Rechteck.x1,Rechteck.y1)-(Rechteck.x2,Rechteck.y2),Farbe,BF
	Line (Rechteck.x1,Rechteck.y1)-(Rechteck.x2,Rechteck.y2),RGB(100,100,100),B
End Sub

Declare Function PunktAufRechteck(Rechteck As Rechteck,x As integer,y As Integer) As Integer
Function PunktAufRechteck(Rechteck As Rechteck,x As integer,y As Integer) As Integer
	If x >= Rechteck.x1 And x <= Rechteck.x2 Then
		If y >= Rechteck.y1 And y <= Rechteck.y2  Then
			Return 1
		EndIf
	EndIf
End Function
Declare Function MausAufRechteck(Rechteck As Rechteck) As Integer
Function MausAufRechteck(Rechteck As Rechteck) As Integer
	Dim As Integer Mx, My
	GetMouse Mx,My
	Return PunktAufRechteck(Rechteck,Mx,My)
End Function

Declare Function MausklickAufRechteck(Rechteck As Rechteck) As Integer
Function MausklickAufRechteck(Rechteck As Rechteck) As Integer
	Dim As Integer MM,MDruck
	GetMouse MM,MM,MM,MDruck
	If MDruck And 1 Then
		If MausAufRechteck(Rechteck) = 1 Then
			Return 1
		EndIf
	EndIf
End Function

Declare sub ZeigePfeil(Pfeil As Pfeil,Farbe As integer)
Sub ZeigePfeil(Pfeil As Pfeil,Farbe As integer)
	Line (Pfeil.x1,Pfeil.y1)-(Pfeil.x1+COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge,Pfeil.y1+SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge),Farbe
	Line (Pfeil.x1+COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge,Pfeil.y1+SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge)-(Pfeil.x1+COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge+   COS(((Pfeil.Richtung+130)*Pi)/180)*Pfeil.laenge/4,   Pfeil.y1+SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge+   SIN(((Pfeil.Richtung+130)*Pi)/180)*Pfeil.laenge/4),Farbe
	Line (Pfeil.x1+COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge,Pfeil.y1+SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge)-(Pfeil.x1+COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge+   COS(((Pfeil.Richtung-130)*Pi)/180)*Pfeil.laenge/4,   Pfeil.y1+SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge+   SIN(((Pfeil.Richtung-130)*Pi)/180)*Pfeil.laenge/4),Farbe
	
	
	
End Sub


Declare Sub AbbrechenButtonZeigen()
Sub AbbrechenButtonZeigen()
	'Abbrechen-Button laden
	Dim Abbrechen As Rechteck
	Abbrechen.x1 = 0+Hoehe/20+(hoehe/7+Hoehe/20)
	Abbrechen.y1 = breite - breite/10
	Abbrechen.x2 = (hoehe/7+Hoehe/20)*2
	Abbrechen.y2 =  breite - breite/15 + 18
	
	ZeigeRechteck(Abbrechen,RGB(250,100,100))
	Draw String ((Abbrechen.x1+Abbrechen.X2)/2-8*4.5,(Abbrechen.y1+Abbrechen.y2)/2-(Text_y/2)), "Abbrechen"
End Sub

Declare Function AbbrechenButton() As Integer
Function AbbrechenButton() As Integer
	'Abbrechen-Button laden
	Dim Abbrechen As Rechteck
	Abbrechen.x1 = 0+Hoehe/20+(hoehe/7+Hoehe/20)
	Abbrechen.y1 = breite - breite/10
	Abbrechen.x2 = (hoehe/7+Hoehe/20)*2
	Abbrechen.y2 =  breite - breite/15 + 18
	
	'ZeigeRechteck(Abbrechen,RGB(250,100,100))
	'Draw String ((Abbrechen.x1+Abbrechen.X2)/2-8*4.5,(Abbrechen.y1+Abbrechen.y2)/2-(4)), "Abbrechen"
	If MausklickAufRechteck(Abbrechen) = 1 Then
		Return 1
	Else
		Return 0
		
	EndIf
End Function

Declare Sub ZeigeLogo(Farbe As Integer = 0)
Sub ZeigeLogo(Farbe As Integer = 0)
	Line (hoehe*0.05,breite*0.3  -breite*0.25)-(hoehe*0.05,breite*0.6   -breite*0.25),Farbe    'Vertilaler Strich von P
	Line (hoehe*0.05,breite*0.3  -breite*0.25)-(hoehe*0.15,breite*0.375 -breite*0.25),Farbe    'Oberer Strich von P
	Line (hoehe*0.05,breite*0.45 -breite*0.25)-(hoehe*0.15,breite*0.375 -breite*0.25),Farbe    'Unterer Strich von P
	
	Line (hoehe*0.05 +hoehe*0.13,breite*0.3  -breite*0.25)-(hoehe*0.05 +hoehe*0.13,breite*0.6   -breite*0.25),Farbe    'Vertilaler Strich von F
	Line (hoehe*0.05 +hoehe*0.13,breite*0.3  -breite*0.25)-(hoehe*0.15 +hoehe*0.13,breite*0.3   -breite*0.25),Farbe    'Oberer Strich von F
	Line (hoehe*0.05 +hoehe*0.13,breite*0.45 -breite*0.25)-(hoehe*0.15 +hoehe*0.13,breite*0.45  -breite*0.25),Farbe    'Unterer Strich von F
	
	Line (hoehe*0.05 +hoehe*0.13*2,breite*0.3   -breite*0.25)-(hoehe*0.05 +hoehe*0.13*2,breite*0.6   -breite*0.25),Farbe    'Vertilaler Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2 ,breite*0.3  -breite*0.25)-(hoehe*0.15 +hoehe*0.13*2,breite*0.3   -breite*0.25),Farbe    'Oberer Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2,breite*0.45  -breite*0.25)-(hoehe*0.15 +hoehe*0.13*2,breite*0.45  -breite*0.25),Farbe    'Mittlerer Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2,breite*0.6   -breite*0.25)-(hoehe*0.15 +hoehe*0.13*2,breite*0.6  -breite*0.25),Farbe    'Unterer Strich von E
	
	Line (hoehe*0.05 +hoehe*0.13*3,breite*0.3   -breite*0.25)-(hoehe*0.05 +hoehe*0.13*3,breite*0.6   -breite*0.25),Farbe    'I
	
	Line (hoehe*0.05 +hoehe*0.13*3.2,breite*0.3   -breite*0.25)-(hoehe*0.05 +hoehe*0.13*3.2,breite*0.6   -breite*0.25),Farbe    'Vertilaler Strich von L
	Line (hoehe*0.05 +hoehe*0.13*3.2,breite*0.6   -breite*0.25)-(hoehe*0.15 +hoehe*0.13*3.2,breite*0.6  -breite*0.25),Farbe    'Unterer Strich von L
	
	Line (hoehe*0.05 +hoehe*0.13*4.2,breite*0.45  -breite*0.25)-(hoehe*0.15 +hoehe*0.13*4.2,breite*0.45  -breite*0.25),Farbe    '-
	
	
	
	Line (hoehe*0.05 +hoehe*0.13*0,breite*0.3   +breite*0.25)-(hoehe*0.05 +hoehe*0.13*0,breite*0.45  +breite*0.25),Farbe    'Linker Vertilaler Strich von S
	Line (hoehe*0.05 +hoehe*0.13*0 ,breite*0.3  +breite*0.25)-(hoehe*0.15 +hoehe*0.13*0,breite*0.3   +breite*0.25),Farbe    'Oberer Strich von S
	Line (hoehe*0.05 +hoehe*0.13*0,breite*0.45  +breite*0.25)-(hoehe*0.15 +hoehe*0.13*0,breite*0.45  +breite*0.25),Farbe    'Mittlerer Strich von S
	Line (hoehe*0.05 +hoehe*0.13*0,breite*0.6   +breite*0.25)-(hoehe*0.15 +hoehe*0.13*0,breite*0.6   +breite*0.25),Farbe    'Unterer Strich von S
	Line (hoehe*0.15 +hoehe*0.13*0,breite*0.45  +breite*0.25)-(hoehe*0.15 +hoehe*0.13*0,breite*0.6   +breite*0.25),Farbe		'Rechter Vertikaler Strich vom S
	
	Line (hoehe*0.05 +hoehe*0.13,breite*0.3  +breite*0.25)-(hoehe*0.05 +hoehe*0.13,breite*0.6   +breite*0.25),Farbe    'Vertilaler Strich von P
	Line (hoehe*0.05 +hoehe*0.13,breite*0.3  +breite*0.25)-(hoehe*0.15 +hoehe*0.13,breite*0.375 +breite*0.25),Farbe    'Oberer Strich von P
	Line (hoehe*0.05 +hoehe*0.13,breite*0.45 +breite*0.25)-(hoehe*0.15 +hoehe*0.13,breite*0.375 +breite*0.25),Farbe    'Unterer Strich von P
	
	Line (hoehe*0.05 +hoehe*0.13*2,breite*0.3  +breite*0.25)-(hoehe*0.05 +hoehe*0.13*2,breite*0.6   +breite*0.25),Farbe    'I
	
	Line (hoehe*0.05 +hoehe*0.13*2.2,breite*0.3   +breite*0.25)-(hoehe*0.05 +hoehe*0.13*2.2,breite*0.6   +breite*0.25),Farbe    'Vertilaler Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2.2 ,breite*0.3  +breite*0.25)-(hoehe*0.15 +hoehe*0.13*2.2,breite*0.3   +breite*0.25),Farbe    'Oberer Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2.2,breite*0.45  +breite*0.25)-(hoehe*0.15 +hoehe*0.13*2.2,breite*0.45  +breite*0.25),Farbe    'Mittlerer Strich von E
	Line (hoehe*0.05 +hoehe*0.13*2.2,breite*0.6   +breite*0.25)-(hoehe*0.15 +hoehe*0.13*2.2,breite*0.6   +breite*0.25),Farbe    'Unterer Strich von E
	
	Line (hoehe*0.05 +hoehe*0.13*3.2,breite*0.3   +breite*0.25)-(hoehe*0.05 +hoehe*0.13*3.2,breite*0.6   +breite*0.25),Farbe    'Vertilaler Strich von L
	Line (hoehe*0.05 +hoehe*0.13*3.2,breite*0.6   +breite*0.25)-(hoehe*0.15 +hoehe*0.13*3.2,breite*0.6   +breite*0.25),Farbe    'Unterer Strich von L
	
End Sub

Declare Function Weiterspielen() As Integer
Function Weiterspielen() As Integer
    lockscreen
      GET (0,0)-(hoehe-1,breite-1) , img2
	  Hintergrund(140,0,250,3,250,150)
	  Color RGB(0,0,0),RGB(140,0,250)
 	  draw string (10,breite/2-Text_y/2), "Wollen sie ein neues Spiel anfangen?"

 	   j = 2 'Anzahl der Buttons
	  'Auswahlbuttons laden:
	  Dim LevelAuswahl(100) As rechteck'Level muss man sich wegdenken... (war einfach zu faul den Namen zu ändern...)
	  For i = 1 To j
		LevelAuswahl(i).x1 = hoehe-Hoehe/4
		LevelAuswahl(i).x2 = hoehe-breite/70
		LevelAuswahl(i).y1 = (breite-breite/70)/j * (i-1) +(breite-breite/70)/70
		LevelAuswahl(i).y2 = (breite-breite/70)/j * (i)
	  Next
	  'Auswahlbuttons anzeigen:

	  ZeigeRechteck(Levelauswahl(1),RGB(0,100,255))
	  Draw String ((Levelauswahl(1).x1+Levelauswahl(1).x2)/2-10,(Levelauswahl(1).y1+Levelauswahl(1).y2)/2-Text_y/2),"Ja"
	  ZeigeRechteck(Levelauswahl(2),RGB(0,100,255))
	  Draw String ((Levelauswahl(2).x1+Levelauswahl(2).x2)/2-20,(Levelauswahl(2).y1+Levelauswahl(2).y2)/2-Text_y/2),"Nein"
	  GET (0,0)-(hoehe-1,breite-1) , img1
 	  Put(0,0),img2,pset
 	unlockscreen
 	ueberblenden
	'Auswahlbuttons abfragen:

	Do
		For i = 1 To j
			If MausklickAufRechteck(Levelauswahl(i)) = 1 Then
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
	Weiter.x1 = 0+Hoehe/20
	Weiter.y1 = breite - breite/10
	Weiter.x2 = hoehe/7+Hoehe/20
	Weiter.y2 =  breite - breite/15 + 18
	
	ZeigeRechteck(Weiter,RGB(100,250,100))
	Draw String ((Weiter.x1+Weiter.X2)/2-8*3,(Weiter.y1+Weiter.y2)/2-Text_y/2), "Weiter"
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
	Loop Until MausklickAufRechteck(Weiter) = 1
End Sub
Declare Sub FensterOeffnen()
Sub FensterOeffnen()
	
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
	If xx <= 800 Then hoehe  = 640  Else hoehe  = 800
	If yy <= 600 Then breite = 480  Else breite = 600 
	'If xx > 1024 Then hoehe  = 1024 
	'If yy >  768 Then breite = 768
	Print "Breite= " & hoehe
	Print "Hoehe = " & breite'/
	hoehe = xx
	breite = yy
	ScreenRes  hoehe,breite ,32,2, &h04 Or 8 
	Width hoehe\8, breite\16 ' für eine Schriftgröße von 8x16
	' Für eine Schriftgröße von 8x14 muss hoch\14 gesetzt
	' werden, für eine Schriftgröße von 8x8 entsprechend hoch\8
	Text_x = 8
	Text_y = 16
	'img1 und img2 vorbereiten
	img1 = Imagecreate(hoehe, breite, RGBA(255, 0, 0, 255),32)
    img2 = Imagecreate(hoehe, breite, RGBA(255, 0, 0, 255),32)

	
	'Starteffekt
	/'Dim As FB.Image Ptr img
	img = Imagecreate(hoehe, breite, RGBA(0, 0, 255, 255),32)
    screenlock
       Hintergrund(140,0,250,3,250,150)
       GET (0,0)-(hoehe-1,breite-1) , img
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
/'Declare Sub KugelBewegen(Kugel As BKugel, Winkel As Integer)
 Sub KugelBewegen(Kugel As BKugel, Winkel As Integer)
	Kugel.x=Kugel.x+COS((Winkel*Pi)/180)*Kugel.Geschwindigkeit
	Kugel.y=Kugel.y+SIN((Winkel*Pi)/180)*Kugel.Geschwindigkeit
 End Sub'/

Declare function LevelCodeInput( TextField as TextBoxType) as string
function LevelCodeInput( TextField as TextBoxType) as string
 
            dim as string letter
			TextField.SetPrompt("Levelcode? ")
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

Declare Sub FrageNachLevel()
Sub FrageNachLevel()
    lockscreen
      get (0,0)-(hoehe-1,breite-1),img2
	  Hintergrund(140,0,250,3,250,150)
	  Color RGB(0,0,0),RGB(140,0,250)
	  Draw String (Text_x*2, Text_y*1),  "Welches Level wollen sie spielen?"', Level
	  'init Textbox
	  dim TextField as textboxtype=textboxtype(text_x*2,text_y*2,40) 'Neue Textbox erzeugen

      TextField.SetColour(rgb(0,0,0))

    
	
	
	
	  ZeigeLogo(RGB(255,0,0))
	  j = 6 'Anzahl der Level
	  'Auswahlbuttons laden:
	  Dim LevelAuswahl(100) As rechteck
	  For i = 1 To j
	  	LevelAuswahl(i).x1 = hoehe-Hoehe/4
	 	LevelAuswahl(i).x2 = hoehe-breite/70
		LevelAuswahl(i).y1 = (breite-breite/70)/j * (i-1) +(breite-breite/70)/70
		LevelAuswahl(i).y2 = (breite-breite/70)/j * (i)
	  Next
	  'Auswahlbuttons anzeigen:

	  For i = 1 To j
	  	ZeigeRechteck(Levelauswahl(i),RGB(0,100,255))
	  	Draw String ((Levelauswahl(i).x1+Levelauswahl(i).x2)/2-10,(Levelauswahl(i).y1+Levelauswahl(i).y2)/2-Text_y/2),"" & i
	  Next
	  get (0,0)-(hoehe-1,breite-1),img1
	  Put(0,0),img2,pset
	unlockscreen
	ueberblenden
	'Auswahlbuttons abfragen:

	Do
		For i = 1 To j
			If MausklickAufRechteck(Levelauswahl(i)) = 1 Then
				Level = i
				Exit Do
			EndIf
		Next
	Loop
	Select Case Level
		Case 1
			Draw string (text_x*2, text_y*3), "Willkommen bei L E V E L   1 !"
			Warten()
			sleep 500
		Case 2 
             SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LSTART1" Or SEingabe = "lstart1" Then
			    Draw string (text_x*2, text_y*3), "Willkommen bei L E V E L   2 !"
				Warten()
				sleep 500
			Else
				Draw string (text_x*2, text_y*3),  "Falsche Eingabe. Programm wird geschlossen."
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 3
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "S3LEVEL" Or SEingabe = "s3level" Then
				Draw string (text_x*2, text_y*3),  "Willkommen bei L E V E L   3 !"
				Warten()
				sleep 500
			Else
				Draw string (text_x*2, text_y*3),  "Falsche Eingabe. Programm wird geschlossen."
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 4
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEV4WIS3" Or SEingabe = "lev4wis3" Then
				Draw string (text_x*2, text_y*3), "Willkommen bei L E V E L   4 !"
				Warten()
				sleep 500
			Else
				Draw string (text_x*2, text_y*3),  "Falsche Eingabe. Programm wird geschlossen."
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 5
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEVE54321L" Or SEingabe = "leve54321l" Then
				Draw string (text_x*2, text_y*3), "Willkommen bei L E V E L   5 !"
				Warten()
				sleep 500
			Else
				Draw string (text_x*2, text_y*3),  "Falsche Eingabe. Programm wird geschlossen."
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
		Case 6
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LE654STAR" Or SEingabe = "le654star" Then
				Draw string (text_x*2, text_y*3),  "Willkommen bei L E V E L   6 !"
				Warten()
				sleep 500
			Else
				Draw string (text_x*2, text_y*3), "Falsche Eingabe. Programm wird geschlossen."
				Warten()
				sleep 500
				FensterSchliessen
			EndIf
	End Select
End Sub

Declare Sub Spielen()
Sub Spielen()
	Dim As Integer Punkte, AnzahlRechtecke
	Dim As Integer ende,jj,x_alt,y_alt
	Dim Abstand As Integer
	Abstand = Text_y + 1
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
	
	
	
	Dim Pfeil As Pfeil
	Color RGB(0,0,0),RGB(255,255,255)
	Punkte = 0
	

	'Rechtecke laden
	Dim Rechteck(100) As Rechteck
	
	For i = 1 To AnzahlRechtecke
		Rechteck(i).x1 = hoehe-Hoehe/4
		Rechteck(i).x2 = hoehe-breite/70
		Rechteck(i).y1 = (breite-breite/70)/AnzahlRechtecke * (i-1) +(breite-breite/70)/70
		Rechteck(i).y2 = (breite-breite/70)/AnzahlRechtecke * (i)
	Next
	Do
	    GET (0,0)-(hoehe-1,breite-1) , img2
	    lockscreen
		'Cls
		Hintergrund(140,0,250,3,250,150)
		Draw String (0,0), "L E V E L   " & Level  
		Draw String (0,0+Abstand*1), "" & Punkte & " Punkte von 100, die noetig sind, um das Level zu beenden."
		
		If Level <= 4 Then
			Draw String (0,0+Abstand*3), "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil?"
		Else
			Draw String (0,0+Abstand*3), "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil?"
		EndIf
		Draw String (0,0+Abstand*4), "Zur Auswahl auf das Rechteck klicken."
		'per Zufall Pfeil erzeugen
		If level <= 4 Then
			Pfeil.x1 = 10 
			Pfeil.y1 =breite/2                                                                          
			Pfeil.laenge = (hoehe+breite)/2 /6                                                                                                                          
			Pfeil.Richtung = Rnd()*(68*breite/hoehe)-(68*breite/hoehe)/2                                                           '|
		ElseIf level >= 5 then
			Do
				Pfeil.x1 = 10 
				Pfeil.y1 =breite/2                                                                          
				Pfeil.laenge = (hoehe+breite)/2 /6                                                                                                                          
				Pfeil.Richtung = Rnd()*180-180/2
				For i = 0 To anzahlrechtecke
					If PunktAufRechteck(rechteck(i),rechteck(i).x1,Wurfparabel(Pfeil.Richtung*-1,Pfeil.laenge,Pfeil.x1+ COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge,Pfeil.y1+ SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge,rechteck(i).x1)) = 1 Then
						Exit Do
					EndIf
				Next
			Loop		
		EndIf
		
		
		'Pfeile anzeigen
		ZeigePfeil Pfeil,RGB(255,10,10)
		'Rechtecke zeigen
		For i = 1 To AnzahlRechtecke
			ZeigeRechteck(Rechteck(i),RGB(0,100,255))
			'Draw String (Rechteck(i).x1+2,Rechteck(i).y1+2),"" & i,RGB(0,0,0) Nummerierung bei Maus nicht nötig
		Next
		For i = 0 To 8
			'Print
		Next
		
		'Alte Eingabemetode:
		/'Input "Eingabe: ", Eingabe
		Do while  eingabe <0 or eingabe > AnzahlRechtecke
			Input "Falsche Eingabe. Neuer Versuch: ", Eingabe
		Loop '/
		
		'überblenden
		GET (0,0)-(hoehe-1,breite-1) , img1
		Put(0,0),img2,pset
		unlockscreen
		ueberblenden()
		'Eingabe machen
		Do
			'If AbbrechenButton() = 1 Then end
			For i = 1 To AnzahlRechtecke
				If MausklickAufRechteck(Rechteck(i)) = 1 Then
					Eingabe = i
					exit do
				EndIf
			Next
		Loop
		If Eingabe = 0 Then End
		'Richtung des Pfeils einzeichnen
		x = Pfeil.x1+ COS((Pfeil.Richtung*Pi)/180)*Pfeil.laenge '_ Hier wird der Start für das einzeichnen auf die Pfeilspitze gesetzt.
		y = Pfeil.y1+ SIN((Pfeil.Richtung*Pi)/180)*Pfeil.laenge '/
		If level >= 5 Then 
				Pfeil.x1 = x 'X und Y müssen neu gespeichert werden, da diese Variablen noch gebraucht werden, die Werte aber nicht geändert
				Pfeil.y1 = y 'werden dürfen. Die "Orginale" Pfeil.x1 und Pfeil.y1 werden nicht mehr gebraucht.
		EndIf
		'Die folgende For...Next-Schleife zeichnet eine Linie der Pfeilrichtung Pixel-für-Pixel ein:
		ende = 0 'ende = 1 : Schleife wird abgebrochen
		For jj = 0 To Sqr(hoehe^2+(breite/4)^2)'ca. max. Länge einer schrägen Linie
			'lockScreen
			If level <= 4 Then 'Gerade Linie, durch (Co)Sinus berechnet
				x = x + COS((Pfeil.Richtung*Pi)/180)*1
				y = y + SIN((Pfeil.Richtung*Pi)/180)*1
				PSet (Int(x),Int(y)),RGB(60,60,60)
			Else
				x_alt = x
				y_alt = y
				x = jj
				y = Wurfparabel(Pfeil.Richtung*-1,Pfeil.laenge,Pfeil.x1,Pfeil.y1,x)
				If x >= Pfeil.x1 Then
					line (Int(x_alt),Int(y_alt))-(Int(x),Int(y)),RGB(60,60,60)
				EndIf
				'Locate 1,1 : Print "x: " & x & " Y: " & Y
			EndIf
				
			'unlockScreen
			'Testen, ob Pixel auf einem Rechteck ist
			For i = 1 To AnzahlRechtecke
				If PunktAufRechteck(Rechteck(i),x,y) = 1 Then
					If i = Eingabe Then 
						'Print 
						'Print
						Color RGB(0,255,0),RGB(255,255,255)
						Draw String (0,0+Abstand*8),"Richtig. Du bekommst 10 weitere Punkte.",RGB(0,255,0)
						Color RGB(0,0,0),RGB(255,255,255)
						Punkte = Punkte + 10
						

						
						'Richtiges Rechteck grün:
						For j = 0 To 255
							ZeigeRechteck(Rechteck(i),RGB(0,j,255-j))
							Sleep 2
						Next



						
					Else
						'Print 
						'Print
						If Punkte > 0 Then 
							Color RGB(255,0,0),RGB(255,255,255)
							Draw String (0,0+Abstand*8), "Falsch. Es werden 10 Punkte abgezogen.",RGB(255,0,0)
							Color RGB(0,0,0),RGB(255,255,255)
							Punkte = Punkte - 10
						Else
							Color RGB(255,0,0),RGB(255,255,255)
							Draw String (0,0+Abstand*8), "Falsch.",RGB(255,0,0)
							Color RGB(0,0,0),RGB(255,255,255)
						EndIf
						
						'ZeigeRechteck(Rechteck(Eingabe),RGB(255,0,0))


						
						'Falsches Rechteck rot:
						For j = 0 To 255
							ZeigeRechteck(Rechteck(eingabe),RGB(j,0,255-j))
							Sleep 2
						Next
						'For...Next-Schleife: Richtiges Rechteck blinkt grün
						For j = 0 To 3
							ZeigeRechteck(Rechteck(i),RGB(0,255,0))
							Sleep 400
							ZeigeRechteck(Rechteck(i),RGB(0,100,255))
							Sleep 400
						Next
					EndIf
					ende = 1
				EndIf
			Next
			sleep 1'CPU schonen
			If ende = 1 Then Exit For
		Next
		'Draw String (0,0+Abstand*10), "weiter mit beliebiger Taste"
		AbbrechenButtonZeigen()
		Warten(1)
		'Sleep'Warten
	Loop Until InKey ="q" Or Punkte >= 100
	'Print 
	'Color RGB(0,100,0),RGB(255,200,15)
	Sleep 800
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


	Warten()
	'Draw String (0,0+Abstand*18),"Programm mit beliebiger Taste schliessen."
	'Sleep
End Sub

Sub Programm()
	Do
		FrageNachLevel()
		Spielen()
	Loop Until Weiterspielen() = 0
End Sub


'=======================================Programm===================================
FensterOeffnen()
Programm()
FensterSchliessen()
End
