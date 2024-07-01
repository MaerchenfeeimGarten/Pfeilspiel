'
' SPDX-FileCopyrightText: 2010 Ray Britton, 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier: X11
'

'Draw string/inkey input type

'Ray Britton (C) 2010
'Veroeffentlicht unter der X11/MIT Lizenz
'Quelle: http://www.freebasic.net/forum/viewtopic.php?t=15355
'Eingedeutscht von Sebastian
'  http://www.freebasic-portal.de/benutzer/sebastian-1.html

#include once "fbgfx.bi"

type TextBoxType 'Textbox-Klasse
    private: 'Private Attribute
        as string message 'Die eingegebene Zeichenkette
        as string prompt 'Eingabeaufforderung (z.B. ein "-->" Symbol)
        as integer max 'Sichtbare Laenge des Eingabefelds in Zeichen
                       'Hinweis: Wenn eine Eingabeaufforderung angegeben wurde, ergibt
                       'sich die Anzahl der Zeichen auf dem Bildschirm als(max-LEN(prompt))
        as integer length 'Gegenwaertige Laenge des eingegebenen Strings
        as integer startpoint=1 'Zeichenposition Ausgabebeginn
        as integer x,y 'Position des Texts (X-/Y-Koordinaten)
        as uinteger colour=rgb(255,255,255) 'Schriftfarbe
        as fb.image ptr textback 'Puffer für grafischen Hintergrund
    public: 'Oeffentliche Methoden
        declare constructor(newx as integer, newy as integer, newmax as integer)
        declare destructor()
        declare sub CopyBackground()
        declare sub SetColour(newcolour as uinteger)
        declare sub SetXY(newx as integer, newy as integer)
        declare sub NewLetter(letter as string)
        declare sub Redraw()
        declare sub SetPrompt(newprompt as string)
        declare sub SetString(news as string)
        declare function GetString () as string
        declare function GetX() as integer
        declare function GetY() as integer
        declare function GetColour() as uinteger
end type

sub textboxtype.setstring(news as string)
    if news<>"" then
        message=left(news,len(message)-1)
        length=len(message)
        newletter(right(news,1))
    else
        message=""
        length=0
        Redraw()
    end if
end sub

Constructor TextBoxType(newx as integer, newy as integer, newmax as integer)
    'Ueberprueft, ob ein Grafikmodus aktiv ist
    if ScreenPtr<>0 then 'Wenn ja, ...
        textback=imagecreate(newmax*8+20,24) '...Speicher fuer Hintergrund reservieren
        x=newx
        y=newy
        max=newmax
    else 'Wenn nein, Fehlermeldung ausgeben:
        print "Fehler: Diese Eingaberoutine funktioniert nur in Grafikmodi."
        sleep
        end
    end if
end constructor

sub TextBoxType.Redraw()
    put (x-3,y-3),textback,pset 'Gesicherten Hintergrund wiederherstellen
    'Aktuellen Text ausgeben:
    draw string (x,y),str(prompt + mid(message,startpoint)),colour
end sub

sub TextBoxType.SetColour(newcolour as uinteger) 'Textfarbe setzen
    colour=newcolour
end sub

function TextBoxType.GetColour() as uinteger 'Textfarbe abfragen
    return colour
end function

function TextBoxType.GetString() as string 'Eingabe als STRING abfragen
    return message
end function

function TextBoxType.GetX() as integer 'X-Koordinate abfragen
    return x
end function

function TextBoxType.GetY() as integer 'Y-Koordinate abfragen
    return y
end function

sub TextBoxType.SetXY(newx as integer, newy as integer) 'Eingabe positionieren
    x=newx
    y=newy
end sub

destructor TextBoxType() 'Destructor fuer die Textbox
    imagedestroy(textback)
end destructor

sub TextBoxType.CopyBackground() 'Eingabehintergrund in Puffer sichern
    get (x-3,y-3)-(x+(max*8+15),y+18),textback
end sub

sub TextBoxType.SetPrompt(newprompt as string) 'Eingabeaufforderung festlegen
    prompt=newprompt
end sub

sub TextBoxType.NewLetter(letter as string)
    dim as integer redrawflag=0
    if asc(letter)=8 then 'Wenn das eingegebene Zeichen BACKSPACE war, ...
        message=left(message,len(message)-1) '... letztes Zeichen entfernen
        length-=1 'Laengenangabe um 1 verringern
        if length<0 then length=0 'Ggf. unsinnvollen, negativen Wert korrigeren
        redrawflag=1 'Eingabe wurde veraendert -> Neu zeichnen!
    end if
    if asc(letter)>31 and asc(letter)<127 then 'Buchstabe, Zahl oder Sonderzeichen ...
        message+=letter '... an gespeicherte Gesamteingabe anhaengen
        length+=1 'Laengenangabe um 1 erhoehen
        redrawflag=1
    end if
    if length+len(prompt)>max then 'Wird die maximale Feldlaenge ueberschritten, ...
        startpoint=length+len(prompt)-max 'scrollt die Eingabe: Ausgabe nicht mit dem
                                          'ersten Zeichen sondern spaeter beginnen
    else 'Kein Scrollen noetig.
        startpoint=1 'Daher Eingabe von Beginn an ausgeben
    end if
    if redrawflag=1 then Redraw() 'Falls noetig, neu zeichnen.
end sub
