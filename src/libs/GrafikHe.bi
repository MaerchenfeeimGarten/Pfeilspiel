#include once "MathHelf.bi"
#include once "GrafikEi.bi"


#define RGBA_R( c ) ( CULng( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CULng( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CULng( c )        And 255 )
#define RGBA_A( c ) ( CULng( c ) Shr 24         )

Namespace GrafikHelfer

	Declare function farbeUeberblenden(f1 as integer, f2 as integer, step as integer) as integer
	function farbeUeberblenden(f1 as integer, f2 as integer, stepp as integer) as integer
		dim as integer r = RGBA_R(f1)*((255.0-stepp)/255.0) + RGBA_R(f2)*(stepp/255.0)
		dim as integer g = RGBA_G(f1)*((255.0-stepp)/255.0) + RGBA_G(f2)*(stepp/255.0)
		dim as integer b = RGBA_B(f1)*((255.0-stepp)/255.0) + RGBA_B(f2)*(stepp/255.0)
		dim as integer a = RGBA_A(f1)*((255.0-stepp)/255.0) + RGBA_A(f2)*(stepp/255.0)
		return rgba(r,g,b,a)
	end function

	'Quelle: https://www.freebasic.net/forum/viewtopic.php?t=22261
	Declare sub dickeLinie(byval x1 As Integer,byval y1 As Integer,byval x2 As Integer,byval y2 As Integer,byval size As Integer,byval c As UInteger)
	Sub dickeLinie(byval x1 As Integer,byval y1 As Integer,byval x2 As Integer,byval y2 As Integer,byval size As Integer,byval c As UInteger)
		size = size / 2 ' Durchmesser-> Radius 
		
		if size < 1 then ' auch dünne Linien erlauben mit eine Dicke von 1
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
	
	Declare sub zentriertSchreiben(xxx as Integer, yyy as Integer, text as String, skalierungsfaktor as Single = 1, farbe as Integer = RGB(0,0,0))
	sub zentriertSchreiben(xxx as Integer, yyy as Integer, text as String, skalierungsfaktor as Single = 1, farbe as Integer = RGB(0,0,0))
		if skalierungsfaktor <= 1 + Epsilon then
			Draw String ((xxx-len(text)*GrafikEinstellungen.groesseTextzeichen.x/2),(yyy-GrafikEinstellungen.groesseTextzeichen.y/2)), text, farbe
		else
			TextSkaliertZeichnen(Punkt((xxx-len(text)*GrafikEinstellungen.groesseTextzeichen.x/2*skalierungsfaktor),(yyy-GrafikEinstellungen.groesseTextzeichen.y/2*skalierungsfaktor)),text,skalierungsfaktor, farbe)
		end if 
	end sub
	
	Declare sub schreibeSkaliertInsGitter(x as Integer,y as Integer,text as String, skalierungsfaktor as Single = 1, farbe as Integer = RGB(0,0,0))
	sub schreibeSkaliertInsGitter(x as Integer,y as Integer,text as String, skalierungsfaktor as Single = 1, farbe as Integer = RGB(0,0,0))
		Dim as integer hoehe, breite
		if y < 0 then 'mittig
			hoehe = GrafikEinstellungen.hoehe/2 - GrafikEinstellungen.groesseTextzeichen.y*skalierungsfaktor/2
		Else
			hoehe = y*GrafikEinstellungen.groesseTextzeichen.y*skalierungsfaktor
		end if
		if x < 0 then 'mittig
			breite = GrafikEinstellungen.breite/2 - GrafikEinstellungen.groesseTextzeichen.x*skalierungsfaktor*len(text)/2
		Else
			breite = x*GrafikEinstellungen.groesseTextzeichen.x*skalierungsfaktor
		end if
		if skalierungsfaktor < 1 + Epsilon then
			Draw String (breite,hoehe), text, farbe
		else
			TextSkaliertZeichnen(Punkt(breite, hoehe), text, skalierungsfaktor, farbe)
		end if 
	End Sub
End Namespace 
