#include once "GrafikElement.bi"

Type KlickbaresGrafikElement extends GrafikElement
	Declare abstract function istPunktDarauf(p as Punkt) as boolean
	Declare abstract function istMausDarauf() as boolean
	Declare abstract function wirdGeklickt() as boolean
End Type
