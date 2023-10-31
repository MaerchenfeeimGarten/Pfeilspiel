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
