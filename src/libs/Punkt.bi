Type Punkt
	as integer x
	as integer y
	Declare Constructor(_x as integer, _y as integer)
	Declare Constructor()
End Type 

Constructor Punkt(_x as integer, _y as integer)
	This.x = _x
	This.y = _y
end Constructor

Constructor Punkt()
    This.x = 0
    This.y = 0
end Constructor

Type PunktSingle
	as Single x
	as Single y
	Declare Constructor(_x as Single, _y as Single)
	Declare Constructor()
End Type 

Constructor PunktSingle(_x as Single, _y as Single)
	This.x = _x
	This.y = _y
end Constructor

Constructor PunktSingle()
    This.x = 0
    This.y = 0
end Constructor
