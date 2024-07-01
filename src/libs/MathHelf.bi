'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'
#include once "Punkt.bi"
Const Pi = 3.14159265358979323846
Const Epsilon = 0.000001
Randomize Timer

Namespace MatheHelfer
	Declare Function LogBaseX (ByVal Number As Double, ByVal BaseX As Double) As Double
	Function LogBaseX (ByVal Number As Double, ByVal BaseX As Double) As Double
		LogBaseX = Log( Number ) / Log( BaseX )
		'For reference:   1/log(10)=0.43429448
	End Function
	
	Declare Function Wurfparabel overload (WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81) As single
	Declare Function Wurfparabel overload (WinkelInGrad As Integer,Geschwindigkeit As Single, Start_x As Integer, Start_y As Integer,x As Integer,Gravitation As Single = 9.81, zoomfactor as single) As single
	
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
End Namespace 
