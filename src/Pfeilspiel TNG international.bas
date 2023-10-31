#Include Once "fbgfx.bi"
#Include once "libs/Textbox/textbox.bi"
#Include once "libs/Punkt.bi"
#Include once "libs/MathHelf.bi"
#Include once "libs/GrafikEi.bi"
#Include once "libs/Bildschi.bi"
#Include once "libs/GrafikHe.bi"
#Include once "libs/GrafElem/Pfeil.bi"
#Include once "libs/GrafElem/Rechteck.bi"
#Include once "libs/i18n/Ueberset.bi"
#Include once "libs/timer/delay.bi"

#ifdef __FB_DOS__ 
ScreenRes  640,480 ,32,2, &h04 Or 8 
#endif

'========================================Sub's==========================================
Declare Sub Programm()

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
      BildschirmHelfer.lockscreen
      GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
	  BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)

	  Color RGB(0,0,0),RGB(140,0,250)
	  GrafikHelfer.schreibeSkaliertInsGitter(1,-1, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WOLLEN_NEUES_SPIEL), GrafikEinstellungen.skalierungsfaktor)
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
	  
	  GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
 	  Put(0,0),BildschirmHelfer.img2,pset
 	  BildschirmHelfer.unlockscreen
 	  BildschirmHelfer.ueberblenden
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
					BildschirmHelfer.FensterSchliessen()
					End
				EndIf
				If weiter = 0 Then
					BildschirmHelfer.FensterSchliessen()
					end
				EndIf
			EndIf
		EndIf
	Loop Until Weiter.wirdGeklickt()
End Sub


Declare function LevelCodeInput( TextField as TextBoxType) as string
function LevelCodeInput( TextField as TextBoxType) as string
 
            dim as string letter
			TextField.SetPrompt(Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.LEVELCODE_PROMPT))
			'Input "Levelcode? ", SEingabe
			TextField.CopyBackground()
            DO
               BildschirmHelfer.lockscreen
                 TextField.Redraw()
               BildschirmHelfer.unlockscreen
               letter=inkey 'Eingabe abfragen
               if letter<>"" then 'Es wurde etwas eingeben.
                   TextField.NewLetter(letter) 'Zeichen an Textboxc	^ weiterreichen.
               end if
               if (asc(letter) = 27) then textfield.setstring("")
               sleep 1 'CPU-Auslastung reduzieren
                
             loop until  asc(letter)=13 'Ende durch ENTER
             return TextField.GetString()
End function 

Declare Sub Sprachauswahl()
Sub Sprachauswahl()
      BildschirmHelfer.lockscreen
      get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
	  BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)

	  Color RGB(0,0,0),RGB(140,0,250)
	  
	  ZeigeLogo(RGB(0,70,100))
	  
	  GrafikHelfer.schreibeSkaliertInsGitter(2,1,"DE: Bitte eine Sprache waehlen.",GrafikEinstellungen.skalierungsfaktor)
	  GrafikHelfer.schreibeSkaliertInsGitter(2,2,"EN: Please choose a language.",GrafikEinstellungen.skalierungsfaktor)
	  'GrafikHelfer.schreibeSkaliertInsGitter(2,3,"FR: Veuillez choisir une langue.",GrafikEinstellungen.skalierungsfaktor)

	  dim as Integer j,i
	  j = 2 'Anzahl der Sprachen. 
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
	  get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
	  Put(0,0),BildschirmHelfer.img2,pset
	BildschirmHelfer.unlockscreen
	BildschirmHelfer.ueberblenden
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
    BildschirmHelfer.lockscreen
      get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img2
	  BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
	  Color RGB(0,0,0),RGB(140,0,250)
	  GrafikHelfer.schreibeSkaliertInsGitter(2,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WELCHES_LEVEL),GrafikEinstellungen.skalierungsfaktor)
	  'init Textbox
	  dim TextField as textboxtype=textboxtype(2,1,40) 'Neue Textbox erzeugen

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

	  get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),BildschirmHelfer.img1
	  Put(0,0),BildschirmHelfer.img2,pset
	BildschirmHelfer.unlockscreen
	BildschirmHelfer.ueberblenden

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
			GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
			Warten()
			sleep 500
		Case 2 
			SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LSTART1" Or SEingabe = "lstart1" Then
			    GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
				BildschirmHelfer.FensterSchliessen
			EndIf
		Case 3
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "S3LEVEL" Or SEingabe = "s3level" Then
				GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
			Else
			    GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
				BildschirmHelfer.FensterSchliessen
			EndIf
		Case 4
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEV4WIS3" Or SEingabe = "lev4wis3" Then
				GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
				BildschirmHelfer.FensterSchliessen
			EndIf
		Case 5
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LEVE54321L" Or SEingabe = "leve54321l" Then
				GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
				BildschirmHelfer.FensterSchliessen
			EndIf
		Case 6
			 SEingabe =  LevelCodeInput(TextField)
			If SEingabe = "LE654STAR" Or SEingabe = "le654star" Then
				GrafikHelfer.schreibeSkaliertInsGitter(2,3,  Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.WILLKOMMEN_BEI_LEVEL)+str(Level)+" !", GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
			Else
				GrafikHelfer.schreibeSkaliertInsGitter(2,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCHE_EINGABE_ENDE), GrafikEinstellungen.skalierungsfaktor)
				Warten()
				sleep 500
				BildschirmHelfer.FensterSchliessen
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
	AktuellerPfeil.farbe = GrafikEinstellungen.DunkleresRot
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
	    GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
	    BildschirmHelfer.lockscreen
		'Cls
		BildschirmHelfer.HintergrundZeichnen(215,133,44,129,47,90)
		GrafikHelfer.schreibeSkaliertInsGitter(0,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.L_E_V_E_L) & Level, GrafikEinstellungen.skalierungsfaktor)  
		GrafikHelfer.schreibeSkaliertInsGitter(0,1, "" & Punkte & Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PUNKTE_VON_PUNKTE), GrafikEinstellungen.skalierungsfaktor)  
		
		If Level <= 4 Then
			GrafikHelfer.schreibeSkaliertInsGitter(0,3, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
		Else
			GrafikHelfer.schreibeSkaliertInsGitter(0,3,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK), GrafikEinstellungen.skalierungsfaktor)
		EndIf
		GrafikHelfer.schreibeSkaliertInsGitter(0,4, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.AUSWAHL_RECHTECK_KLICK), GrafikEinstellungen.skalierungsfaktor)
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
					If RechteckVar(i).istPunktDarauf(	Punkt(	RechteckVar(i).x1,int(MatheHelfer.Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,							AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge,RechteckVar(i).x1, 9.81, GrafikEinstellungen.skalierungsfaktor)))						) Then
							Exit Do
					EndIf
				Next
			Loop		
		EndIf
		
		
		AktuellerPfeil.anzeigen()

		For i = 1 To AnzahlRechtecke
			RechteckVar(i).anzeigen()
		Next
		
		'überblenden
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.ueberblenden()
		
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
		x = AktuellerPfeil.x1+ COS((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '_ Hier wird der Start für das einzeichnen auf die AktuellerPfeilspitze gesetzt.
		y = AktuellerPfeil.y1+ SIN((AktuellerPfeil.Richtung*Pi)/180)*AktuellerPfeil.laenge '/
		If level >= 5 Then 
				AktuellerPfeil.x1 = x 'X und Y müssen neu gespeichert werden, da diese Variablen noch gebraucht werden, die Werte aber nicht geändert
				AktuellerPfeil.y1 = y 'werden dürfen. Die "Orginale" AktuellerPfeil.x1 und AktuellerPfeil.y1 werden nicht mehr gebraucht.
		EndIf
		'Die folgende For...Next-Schleife zeichnet eine Linie der AktuellerPfeilrichtung Pixel-für-Pixel ein:
		ende = 0 'ende = 1 : Schleife wird abgebrochen
		For jj = 0 To Sqr(GrafikEinstellungen.breite^2+(GrafikEinstellungen.hoehe/4)^2)'ca. max. Länge einer schrägen Linie
			'lockScreen
			If level <= 4 Then 'Gerade Linie, durch (Co)Sinus berechnet
				x = x + COS((AktuellerPfeil.Richtung*Pi)/180)*1
				y = y + SIN((AktuellerPfeil.Richtung*Pi)/180)*1
				GrafikHelfer.dickeLinie  Int(x),Int(y),Int(x),Int(y), GrafikEinstellungen.skalierungsfaktor/2 , RGB(60,60,60)
			Else
				x_alt = x
				y_alt = y
				x = jj
				y = int(Mathehelfer.Wurfparabel(AktuellerPfeil.Richtung*-1,AktuellerPfeil.laenge,AktuellerPfeil.x1,AktuellerPfeil.y1,x,  9.81, GrafikEinstellungen.skalierungsfaktor))
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
						GrafikHelfer.schreibeSkaliertInsGitter(0,8,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.RICHTIG_PLUS_10), GrafikEinstellungen.skalierungsfaktor, RGB(0,255,0))
						Color RGB(0,0,0), RGB(255,255,255)
						Punkte = Punkte + 10
						

						
						'Richtiges Rechteck grün:
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
							GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH_MINUS_10),GrafikEinstellungen.skalierungsfaktor, GrafikEinstellungen.DunkleresRot )
							Color RGB(0,0,0),RGB(255,255,255)
							Punkte = Punkte - 10
						Else
							Color RGB(255,0,0),RGB(255,255,255)
							GrafikHelfer.schreibeSkaliertInsGitter(0,8, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH),GrafikEinstellungen.skalierungsfaktoR, GrafikEinstellungen.DunkleresRot)
							Color RGB(0,0,0),RGB(255,255,255) 
						EndIf
						
						'ZeigeRechteck(Rechteck(Eingabe),RGB(255,0,0))


						
						'Falsches Rechteck rot:
						Dim as Integer j
						For j = 0 To 255
							RechteckVar(eingabe).anzeigen(RGB(j,0,255-j))
							Sleep 2
						Next
						'For...Next-Schleife: Richtiges Rechteck blinkt grün
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
			dim as short accuracy = 1
			
#ifdef __FB_DOS__ 
			accuracy = 15
#endif
			if jj mod accuracy = 0 then
				regulate(450/accuracy,125)
			end if
			If ende = 1 Then Exit For
		Next
		AbbrechenButtonZeigen()
		Warten(1)
		'Sleep'Warten
	Loop Until Punkte >= 100

	Sleep 800
	dim as Integer AnzeilZeilen = 3
	dim Zeile(1 to AnzeilZeilen) as String
	Select Case Uebersetzungen.Sprache
		Case Uebersetzungen.SpracheEnum.DEUTSCH:
			Select Case level
				Case 1 
					Zeile(1) = "Du hast nun 100 Punkte und damit das Level geloest!  "
					Zeile(2) = "Um das naechste Level spielen zu koennen, brauchst du"
					Zeile(3) = "einen Freischaltcode. Dieser lautet:     LSTART1     "
				Case 2
					Zeile(1) = "Super! Nun hast du mit 100 Punkten auch Level 2 durch-"
					Zeile(2) = "gespielt. Hier ist der naechste Freischaltcode fuer "
					Zeile(3) = "das Level 3:    S3LEVEL      Viel Spass!            "
				Case 3
					Zeile(1) = "Du hast nun die Haelfte aller Level gespielt! Weiter"
					Zeile(2) = "so! Der naechste Levelcode fuer das Level 4 heisst:  "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt"
					Zeile(2) = "fehlen demnach noch 2. Der Levelcode fuer das Level 5  "
					Zeile(3) = "lautet:    LEVE54321L                                "
				Case 5
					Zeile(1) = "Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-"
					Zeile(2) = "noch das Level 6. Auch dafuer gibt es wieder einen  "
					Zeile(3) = "Code:    LE654STAR                                    "
				Case 6
					Zeile(1) = "Du hast nun 100 Punkte und das Level geloest! Damit  "
					Zeile(2) = "hast du auch das komplette Spiel durchgespielt! Herz-"
					Zeile(3) = "lichen Glueckwunsch!     "
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, haettest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
		Case Uebersetzungen.SpracheEnum.ENGLISCH:
			Select Case level
				Case 1 
					Zeile(1) = "You now have 100 points and solved the level! To be   "
					Zeile(2) = "able to play the next level, you will need an unlock  "
					Zeile(3) = "code. This is: LSTART1                                "
				Case 2
					Zeile(1) = "Great! Now you have played through level 2 with 100   "
					Zeile(2) = "points. Here is the next unlock code for the level 3: "
					Zeile(3) = "          S3LEVEL      Have fun!                      "
				Case 3:                   
					Zeile(1) = "You have now played half of all levels! Continue like"
					Zeile(2) = "this! The next level code for level 4 is:            "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "You have already played through 4 of 6 levels. Great!"
					Zeile(2) = "Now 2 more to go. The level code for level 5 is: "
					Zeile(3) = "   LEVE54321L                                "
				Case 5
					Zeile(1) = "You have almost completed the game. Now only level 6 "
					Zeile(2) = "is missing. For which there is again a code for this "
					Zeile(3) = "level too::   LE654STAR                              "
				Case 6
					Zeile(1) = "You now have 100 points and solved the level! With this"
					Zeile(2) = "you have played through the whole game! That's great!  "
					Zeile(3) = "Congratulations!"
				Case Else
					Zeile(1) = "You now have 100 points! Since that is with only ONE"
					Zeile(2) = "rectangle but nothing special, you wouldn't have to "
					Zeile(3) = "play the game at all.."
			End Select
		Case Uebersetzungen.SpracheEnum.FRANZOESISCH:
		    'TODO: Muss noch übersetzt werden (auf Französisch)
			Select Case level
				Case 1 
					Zeile(1) = "Du hast nun 100 Punkte und damit das Level geloest!  "
					Zeile(2) = "Um das naechste Level spielen zu koennen, brauchst du"
					Zeile(3) = "einen Freischaltcode. Dieser lautet:     LSTART1     "
				Case 2
					Zeile(1) = "Super! Nun hast du mit 100 Punkten auch Level 2 durch-"
					Zeile(2) = "gespielt. Hier ist der naechste Freischaltcode fuer "
					Zeile(3) = "das Level 3:    S3LEVEL      Viel Spass!            "
				Case 3
					Zeile(1) = "Du hast nun die Haelfte aller Level gespielt! Weiter"
					Zeile(2) = "so! Der naechste Levelcode fuer das Level 4 heisst:  "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt"
					Zeile(2) = "fehlen demnach noch 2. Der Levelcode fuer das Level 5  "
					Zeile(3) = "lautet:    LEVE54321L                                "
				Case 5
					Zeile(1) = "Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-"
					Zeile(2) = "noch das Level 6. Auch dafuer gibt es wieder einen  "
					Zeile(3) = "Code:    LE654STAR                                    "
				Case 6
					Zeile(1) = "Du hast nun 100 Punkte und das Level geloest! Damit  "
					Zeile(2) = "hast du auch das komplette Spiel durchgespielt! Herz-"
					Zeile(3) = "lichen Glueckwunsch!     "
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, haettest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
	End Select 'Sprache
	
	for i = 1 to AnzeilZeilen 
		GrafikHelfer.schreibeSkaliertInsGitter(0,13+i,Zeile(i),GrafikEinstellungen.skalierungsfaktor, RGB(255,200,15))
	next
	
	
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
BildschirmHelfer.FensterOeffnen()
Programm()
BildschirmHelfer.FensterSchliessen()
End
