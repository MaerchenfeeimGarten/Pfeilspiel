#include once "fbgfx.bi"
#include once "GrafikEi.bi"
#include once "timer/delay.bi"
#include once "GrafElem/Rechteck.bi"

Namespace BildschirmHelfer
	Dim As Integer FPS = 43
	Dim As Integer StepsPerFrame = 3
	Dim Shared As FB.Image Ptr img1, img2

	Sub lockScreen()
		ScreenCopy 0, 1          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
		ScreenSet 1, 0           ' eine Seite anzeigen, während die andere bearbeitet wird
	End Sub
	
	sub SchliessenButtonAbarbeiten()
		static as Rechteck schliessenButton
		schliessenButton.farbe = RGB(255,60,60)
		schliessenButton.farbe_rand = RGB(225,0,0)
		schliessenButton.beschriftung = "x"
		schliessenButton.x1 = GrafikEinstellungen.breite - (GrafikEinstellungen.groesseTextzeichen.x+2)*GrafikEinstellungen.skalierungsfaktor
		schliessenButton.y1 = 0
		schliessenButton.x2 = GrafikEinstellungen.breite - 1
		schliessenButton.y2 = (GrafikEinstellungen.groesseTextzeichen.x+2)*GrafikEinstellungen.skalierungsfaktor
		schliessenButton.anzeigen()
		if schliessenButton.wirdGeklickt() then
			end
		end if
	end sub
	
	Sub unlockScreen()
		ScreenSet 0, 0           ' die aktive Seite auf die sichtbare Seite einstellen
		ScreenSync               ' auf die Bildschirmaktualisierung warten
		ScreenCopy 1, 0          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
		SchliessenButtonAbarbeiten()
	End Sub


	Declare Sub HintergrundZeichnen(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
	Sub HintergrundZeichnen(R1 As integer,G1 As Integer,B1 As Integer,R2 As Integer,G2 As Integer,B2 As Integer)
		dim as integer y
		For y = 0 To GrafikEinstellungen.hoehe
			Dim As Integer ueberblendetes_r, ueberblendetes_g, ueberblendetes_b
			ueberblendetes_r = R1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+R2*((y)/GrafikEinstellungen.hoehe)
			ueberblendetes_g = G1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+G2*((y)/GrafikEinstellungen.hoehe) 
			ueberblendetes_b = B1*((GrafikEinstellungen.hoehe-y)/GrafikEinstellungen.hoehe)+B2*((y)/GrafikEinstellungen.hoehe)
			Line (0,y)-(GrafikEinstellungen.breite,y),RGB( ueberblendetes_r ,  ueberblendetes_g , ueberblendetes_b )
		Next
	End Sub

	
	Sub Ueberblenden(dauer as Double = 3)
		Dim as Double starttime = timer
		Dim as Double i = 0
		do while i < 255 
			i = timelerp(starttime,dauer,0,255)
			BildschirmHelfer.lockscreen()
			cls
			put (0,0),img2,ALPHA,255
			put (0,0),img1,ALPHA,int(i)
			BildschirmHelfer.unlockscreen()
		loop
	End sub
	
	Declare Sub FensterSchliessen()
	Sub FensterSchliessen()
		'Effekt zum Beenden:
		BildschirmHelfer.lockscreen
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		
		put (0,0), Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(0, 0, 0, 255),32), PSET
		
		GrafikHelfer.schreibeSkaliertInsGitter(0,int(GrafikEinstellungen.hoehe/GrafikEinstellungen.groesseTextzeichen.y/GrafikEinstellungen.skalierungsfaktor-1),"Pfeilspiel TNG international - Version 0.0.4 - von MaerchenfeeImGarten - 2024", GrafikEinstellungen.skalierungsfaktor, RGB(45,60,45))
		
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img1
		Put(0,0),BildschirmHelfer.img2,pset
		BildschirmHelfer.unlockscreen
		BildschirmHelfer.Ueberblenden(6)
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
		
		ScreenRes  GrafikEinstellungen.breite,GrafikEinstellungen.hoehe ,32,2, &h04 Or 8 
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
