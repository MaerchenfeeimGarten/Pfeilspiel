'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'
#include once "GElement.bi"

Type KlickbaresGrafikElement extends GrafikElement
	Declare abstract function istPunktDarauf(p as Punkt) as boolean
	Declare abstract function istMausDarauf() as boolean
	Declare abstract function wirdGeklickt() as boolean
End Type
