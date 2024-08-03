'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'

#include once "fbgfx.bi"
#include once "GrafikEi.bi"
#include once "GrafikHe.bi"
#include once "timer/delay.bi"
#include once "GrafElem/Rechteck.bi"
#include once "i18n/Ueberset.bi"

Namespace BildschirmHelfer
	Dim As Integer FPS = 43
	Dim As Integer StepsPerFrame = 3
	Dim Shared As FB.Image Ptr img1, img2
	Dim as boolean locked = false

	Declare Sub SchliessenButtonAbarbeiten()
	Declare Sub FensterSchliessen()
		
	Sub lockScreen()
		locked = true
		SCREENLOCK
		'ScreenCopy 0, 1          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
		'ScreenSet 1, 0           ' eine Seite anzeigen, während die andere bearbeitet wird
	End Sub
	
	Sub unlockScreen(schliessenbutton as boolean = True)
		if schliessenbutton then
			SchliessenButtonAbarbeiten()
		end if 
		SCREENUNLOCK
		'ScreenSet 0, 0           ' die aktive Seite auf die sichtbare Seite einstellen
		ScreenSync               ' auf die Bildschirmaktualisierung warten
		'ScreenCopy 1, 0          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
		locked = false
	End Sub
	

	
	Type AuswahlWirklichBeendenDialog extends object
		private:
			menubild_statischer_teil as Any Ptr
			menubild_statischer_teil_generiert as boolean
			declare sub Zeichnen(i as Double, startbild as Any Ptr)' 0 <= i <= 255
		public:
			declare sub Ausfuehren()
			declare Constructor ( )
			declare Destructor ( )
	end Type 
	
	Constructor AuswahlWirklichBeendenDialog ( )
		menubild_statischer_teil_generiert = false
		menubild_statischer_teil = ImageCreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe)
	End Constructor
	
	Destructor AuswahlWirklichBeendenDialog ( )
		ImageDestroy menubild_statischer_teil
		menubild_statischer_teil = 0
	end Destructor
	
	
	Sub AuswahlWirklichBeendenDialog.Zeichnen(i as Double, startbild as Any Ptr)' 0 <= i <= 255
		if not locked then BildschirmHelfer.lockscreen()
		
		'Puffer für statische Teile verwenden, sobald diese 1x gezeichnet worden sind. Dies erhöht die Framerate.
		if not menubild_statischer_teil_generiert then
			'Weißer Hintergrund
			cls
			Line (0,0)-(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe), RGB(255,255,255), BF
			
			'Frage zeichnen
			GrafikHelfer.zentriertSchreiben(GrafikEinstellungen.breite/2, GrafikEinstellungen.hoehe/3/2, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PROGRAMM_WIRKLICH_BEENDEN),GrafikEinstellungen.skalierungsfaktor , RGB(0,0,0))
			
			'Nein
			GrafikHelfer.zentriertSchreiben(GrafikEinstellungen.breite/3*2 + GrafikEinstellungen.breite/3/2, GrafikEinstellungen.hoehe/2,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.NEIN), GrafikEinstellungen.skalierungsfaktor , RGB(0,120,0))
			
			'Ja
			GrafikHelfer.zentriertSchreiben(GrafikEinstellungen.breite/3/2, GrafikEinstellungen.hoehe/3*2 + GrafikEinstellungen.hoehe/3/2, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.JA),GrafikEinstellungen.skalierungsfaktor , RGB(164,0,0))
			
			'Statische Elemente des startbild's:
			put (0, GrafikEinstellungen.hoehe/3), startbild, (0,GrafikEinstellungen.hoehe/3)-(GrafikEinstellungen.breite/3*2, GrafikEinstellungen.hoehe/3*2),PSET
			put (GrafikEinstellungen.breite/3, GrafikEinstellungen.hoehe/3*2), startbild, (GrafikEinstellungen.breite/3,GrafikEinstellungen.hoehe/3*2)-(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe),PSET
		
' 			'Bis hier her gezeichnetes speichern
			get (0,0)-(GrafikEinstellungen.breite-1, GrafikEinstellungen.hoehe-1), menubild_statischer_teil
			menubild_statischer_teil_generiert = true
		Else
			Put (0,0), menubild_statischer_teil, PSet
		end if
		
		'Dynamische Elemente zeichnen:
		if not i>=254.98 then 'Dynamische Elemente nicht zeichnen, wenn der Scrollewert i auf Maximum ist (Abzüglich von ein wenig wegen Double-Ungenauigkeiten). Dies ist eine Fehlerbehebung für einen of-by-one-Fehler.
			'Dynamisches Schieben: Oberes Bildschirm-Drittel nach oben schieben:
			put (0, 0), startbild, (0,int(GrafikEinstellungen.hoehe/3.0*(i/255.0)))-(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe/3),PSET
			
			'Dynamisches Schieben: Mittleres, rechtes Bildschirm-Neuntel nach rechts schieben:
			put (int(GrafikEinstellungen.breite/3*(2+1*(i/255.0))), GrafikEinstellungen.hoehe/3), startbild, (GrafikEinstellungen.breite/3*2,GrafikEinstellungen.hoehe/3)-(GrafikEinstellungen.breite-int(GrafikEinstellungen.breite/3*(i/255.0)), GrafikEinstellungen.hoehe/3*2),PSET
			
			'Dynamisches Schieben: Unteres, linkes Bildschirm-Neuntel nach links schieben:
			put (0, GrafikEinstellungen.hoehe/3*2), startbild, (int(GrafikEinstellungen.breite/3.0*(i/255.0)), GrafikEinstellungen.hoehe/3*2)-(GrafikEinstellungen.breite/3,GrafikEinstellungen.hoehe),PSET
		end if
		unlockscreen(false)
		sleep 10
	end sub
	
	Sub AuswahlWirklichBeendenDialog.Ausfuehren()
		'Speichern der aktuellen MaerchenZeit
		Dim as MaerchenZeit StartZeit = MaerchenZeitAngeber()
		
		'Speichern der aktuellen Bildschirm-Sperrsituation.
		Dim as Boolean wasLocked = locked
		
		'Sicherstellen, das Bildschirm am Anfang dieser Sub immer geblockt ist.
		if not wasLocked then
			lockScreen()
		end if
		
		'Bildschirminhalt beim Start dieser Sub sichern.
		Dim startbild As Any Ptr 
		startbild= ImageCreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe)
		get (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1),startbild
		
		'Eingangsanimation
		Dim as MaerchenZeit starttime = MaerchenZeitAngeber()
		Dim as Double i = 0
		Dim as Double dauer = 3'Sekunden
		do while i < 255 
			i = timelerp(starttime,dauer,0,255)
			This.Zeichnen(i, startbild)
		loop
		
		dim as integer xm, ym, MM,MDruck
		do' warten, bis die Maustaste gedrückt wurde
			sleep 10
			GetMouse xm,ym,MM,MDruck
		loop until MDruck > 0
		do' warten, bis die Maustaste wieder losgelassen wurde, und dann Mausposition speichern.
			sleep 10
			GetMouse xm,ym,MM,MDruck
		loop until MDruck = 0
		
		'Ausgangsanimation
		starttime = MaerchenZeitAngeber()
		i = 0
		dauer = 3'Sekunden
		do while i < 255 
			i = timelerp(starttime,dauer,0,255)
			This.Zeichnen(255-i, startbild)
		loop
		
		'Programm beenden, wenn Mausposition auf "Nein"-Feld war.
		if xm < GrafikEinstellungen.breite/3 and ym > GrafikEinstellungen.hoehe/3*2 then
			'Ausgangsanimation
			FensterSchliessen()
		end if
		
		'Aufräumen
		If startbild Then ImageDestroy startbild
		
		'Wiederherstellen der StartZeit
		MaerchenZeitAngeber(StartZeit)
		
		'Wiederherstellung der Anfangs-Bildschirm-Sperrsituation.
		if not wasLocked and locked then
			unlockScreen()
		elseif wasLocked and not locked then
			lockScreen()
		end if
	end sub
	
	
	
	sub SchliessenButtonAbarbeiten()
		static as Rechteck schliessenButton
		schliessenButton.farbe = RGB(255,60,60)
		schliessenButton.farbe_rand = RGB(225,0,0)
		schliessenButton.beschriftung = "x"
		schliessenButton.x1 = GrafikEinstellungen.breite - (GrafikEinstellungen.groesseTextzeichen.x+2)*GrafikEinstellungen.skalierungsfaktor
		schliessenButton.y1 = 0
		schliessenButton.x2 = GrafikEinstellungen.breite - 1
		schliessenButton.y2 = (GrafikEinstellungen.groesseTextzeichen.x+2)*GrafikEinstellungen.skalierungsfaktor
		
		if locked then
			schliessenButton.anzeigen()
		end if
		if schliessenButton.wirdGeklickt() then
			dim dialog as AuswahlWirklichBeendenDialog
			dialog.ausfuehren()
		end if
	end sub
	



	Declare Sub HintergrundZeichnen(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
	Sub HintergrundZeichnen(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
		dim as integer y
		For y = 0 To GrafikEinstellungen.hoehe
			Dim As double ueberblendetes_r, ueberblendetes_g, ueberblendetes_b
			ueberblendetes_r = 1.0*R1*((1.0*GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+1.0*R2*((1.0*y)/GrafikEinstellungen.hoehe)
			ueberblendetes_g = 1.0*G1*((1.0*GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+1.0*G2*((1.0*y)/GrafikEinstellungen.hoehe) 
			ueberblendetes_b = 1.0*B1*((1.0*GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+1.0*B2*((1.0*y)/GrafikEinstellungen.hoehe)
			Line (0,y)-(GrafikEinstellungen.breite,y),RGB( int(ueberblendetes_r) ,  int(ueberblendetes_g) , int(ueberblendetes_b))
			
			'Machbandeffekt austricksen durch Dithering
			Line (y mod 2,y)-(GrafikEinstellungen.breite,y),RGB( int(ueberblendetes_r+0.3) ,  int(ueberblendetes_g+0.3) , int(ueberblendetes_b+0.3)), ,&b1010101010101010
		Next
	End Sub

	
	Sub Ueberblenden(dauer as Double = 3, schliessenButton as Boolean = true)
		Dim as MaerchenZeit starttime = MaerchenZeitAngeber()
		Dim as Double i = 0
		do while i < 255 
			i = timelerp(starttime,dauer,0,255)
			BildschirmHelfer.lockscreen()
			put (0,0),img2,PSET
			put (0,0),img1,ALPHA,int(i)
			BildschirmHelfer.unlockscreen(schliessenButton)
			sleep 1
		loop
	End sub
	
	Sub FensterSchliessen()
		'Effekt zum Beenden:
		BildschirmHelfer.lockscreen
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		
		put (0,0), Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(0, 0, 0, 255),32), PSET
		
		GrafikHelfer.schreibeSkaliertInsGitter(0,int(GrafikEinstellungen.hoehe/GrafikEinstellungen.groesseTextzeichen.y/GrafikEinstellungen.skalierungsfaktor-1),"Pfeilspiel TNG international - v0.0.8 - (c) MaerchenfeeImGarten 2024 - AGPL-3.0", GrafikEinstellungen.skalierungsfaktor, RGB(45,60,45))
		
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen(false)
		BildschirmHelfer.Ueberblenden(6, false)
		Sleep 2000
		imagedestroy img1
		imagedestroy img2
		End
	End Sub
		
	Declare Sub FensterOeffnen()
	Sub FensterOeffnen()
		Dim as Integer xx,yy
		ScreenInfo xx, yy
		
		Select Case Command(1)
			Case "1"
				xx = 640
				yy = 480
			Case "2"
				xx = 800
				yy = 600
			Case "3"
				xx = 1024
				yy = 768
			Case "4"
				xx = 1280
				yy = 768
			Case "5"
				xx = 1200
				yy = 800
		End Select
		
		if xx= 512 and yy=512 then 'wasm
			xx = 1280
			yy = 768
		end if
		
		GrafikEinstellungen.breite = xx
		GrafikEinstellungen.hoehe = yy
		
		Print "Breite= " & GrafikEinstellungen.breite
		Print "Hoehe = " & GrafikEinstellungen.hoehe
		

		GrafikEinstellungen.skalierungsfaktor = 1.0*GrafikEinstellungen.breite/640
		if GrafikEinstellungen.skalierungsfaktor < 1 then
			GrafikEinstellungen.skalierungsfaktor = 1
		end if
		Print "Skalierungsfaktor= " & GrafikEinstellungen.skalierungsfaktor
		
		
		' Wert     Symbol                   Wirkung
		' -------------------------------------------------------------------------------------------------------------
		' &h00     GFX_WINDOWED             Normaler Fenstermodus ==> Standard-Option
		' &h01     GFX_FULLSCREEN           Vollbildmodus
		' &h02     GFX_OPENGL               OpenGL-Modus
		' &h04     GFX_NO_SWITCH            kein Moduswechsel
		' &h08     GFX_NO_FRAME             kein Rahmen
		' &h10     GFX_SHAPED_WINDOW        Splashscreen-Modus
		' &h20     GFX_ALWAYS_ON_TOP        Fenster, das immer auf oberster Ebene bleibt
		' &h40     GFX_ALPHA_PRIMITIVES     Bearbeite auch ALPHA-Werte bei Drawing Primitives wie PSET, LINE, etc.
		' &h80     GFX_HIGH_PRIORITY        Höhere Priorität für Grafikprozesse, nur unter Win32
		' &h10000  GFX_STENCIL_BUFFER       Stencil Buffer (Schablonenpuffer) verwenden (nur im OpenGL-Modus)
		' &h20000  GFX_ACCUMULATION_BUFFER  Accumulation Buffer (nur im OpenGL-Modus)
		' &h40000  GFX_MULTISAMPLE          Bewirkt im Vollbildmodus Antialiasing durch die ARB_multisample-Erweiterung
		'   -1     GFX_NULL                 Grafikmodus ohne visuelles Feedback
		ScreenRes  GrafikEinstellungen.breite,GrafikEinstellungen.hoehe ,32,2, &h04 Or 8 Or &h01
		
		
		
		Width GrafikEinstellungen.breite\8, GrafikEinstellungen.hoehe\16 ' für eine Schriftgröße von 8x16
		' Für eine Schriftgröße von 8x14 muss hoch\14 gesetzt
		' werden, für eine Schriftgröße von 8x8 entsprechend hoch\8
		GrafikEinstellungen.groesseTextzeichen.x = 8
		GrafikEinstellungen.groesseTextzeichen.y = 16
		'BildschirmHelfer.img1 und BildschirmHelfer.img2 vorbereiten
		BildschirmHelfer.img1 = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(255, 0, 0, 255),32)
		BildschirmHelfer.img2 = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(255, 0, 0, 255),32)
	End Sub

End Namespace 
