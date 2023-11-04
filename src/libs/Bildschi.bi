#include once "fbgfx.bi"
#include once "GrafikEi.bi"
#include once "timer/delay.bi"

Namespace BildschirmHelfer
	Dim As Integer FPS = 43
	Dim As Integer StepsPerFrame = 3
	Dim Shared As FB.Image Ptr img1, img2

	Sub lockScreen()
	ScreenCopy 0, 1          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
	ScreenSet 1, 0           ' eine Seite anzeigen, während die andere bearbeitet wird
	End Sub

	Sub unlockScreen()
	ScreenSet 0, 0           ' die aktive Seite auf die sichtbare Seite einstellen
	ScreenSync               ' auf die Bildschirmaktualisierung warten
	ScreenCopy 1, 0          ' Bild von der vorher aktiven Seite auf die sichtbare Seite kopieren
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

	Declare Sub FensterSchliessen()
	Sub FensterSchliessen()
		'Effekt zum Beenden:
		var img = Imagecreate(GrafikEinstellungen.breite, GrafikEinstellungen.hoehe, RGBA(0, 0, 0, 255),32)
		
		Dim as Integer i
		for i = 255 to 0 Step -StepsPerFrame/2
		put (0,0),img,ALPHA,1
		regulate(FPS,125)
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
		Dim as Double starttime = timer
		Dim as Double i = 0
		do while i < 255 
			i = timelerp(starttime,3,0,255)
			BildschirmHelfer.lockscreen()
			cls
			put (0,0),img2,ALPHA,255
			put (0,0),img1,ALPHA,int(i)
			BildschirmHelfer.unlockscreen()
			'regulate(FPS,125)
		loop
	End sub
		
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
