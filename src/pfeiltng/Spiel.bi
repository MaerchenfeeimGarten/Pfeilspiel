#Include Once "fbgfx.bi"
#Include once "../libs/Textbox/textbox.bi"
#Include once "../libs/Punkt.bi"
#Include once "../libs/MathHelf.bi"
#Include once "../libs/GrafikEi.bi"
#Include once "../libs/Bildschi.bi"
#Include once "../libs/GrafikHe.bi"
#Include once "../libs/GrafElem/Pfeil.bi"
#Include once "../libs/GrafElem/Rechteck.bi"
#Include once "../libs/i18n/Ueberset.bi"
#Include once "../libs/timer/delay.bi"
#Include once "../libs/SpielEle/AbbruchB.bi"
#Include once "../libs/SpielEle/Logo.bi"
#Include once "../libs/Bildschi.bi"

#Include once "SpielAuf/Saufgabe.bi"

'===========================================Spiel========================================

type SpielInterface extends Object
	public:
		declare abstract sub spielen(level as short, spiel as short)
		declare abstract function getNoetigePunkte() as short
		declare abstract function getAktuellePunkte() as short
		declare abstract sub setAktuellePunkte(punkte as short)
		declare abstract function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare abstract sub zeichneHintergrund()
		declare abstract sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
		declare abstract function getLevelCode(level as short, spiel as short) as String
end type

type SpielDekorator extends SpielInterface
	public:
		declare abstract sub spielen(level as short, spiel as short)
		declare abstract function getNoetigePunkte() as short
		declare abstract function getAktuellePunkte() as short
		declare abstract sub setAktuellePunkte(punkte as short)
		declare abstract function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare abstract sub zeichneHintergrund()
		declare abstract sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
		declare abstract function getLevelCode(level as short, spiel as short) as String
	private:
		as SpielInterface pointer SpielInterfaceSpeicher
end type

type StandardSpiel extends SpielInterface
	public:
		declare virtual sub spielen(level as short, spiel as short)
		declare constructor()
		declare function getAnzahlLevel() as Short
		declare virtual function getNoetigePunkte() as short
		declare virtual function getAktuellePunkte() as short
		declare virtual sub setAktuellePunkte(punkte as short)
		declare virtual function getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
		declare virtual sub zeichneHintergrund()
		declare virtual sub zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
		declare virtual function getLevelCode(level as short, spiel as short) as String
	private:
		as Short anzahlLevel
		as Short aktuellePunkte
		as Short modus
end type

Constructor StandardSpiel()
	this.anzahlLevel = 6
	this.aktuellePunkte = 0
end Constructor

function StandardSpiel.getAktuellePunkte() as short
	return this.aktuellePunkte
end function

sub StandardSpiel.setAktuellePunkte(punkte as short)
	this.aktuellePunkte = punkte
end sub

function StandardSpiel.getAnzahlLevel() as Short
	return this.anzahlLevel
end function

function StandardSpiel.getNoetigePunkte() as Short
	return 100
end function

function StandardSpiel.getSpielAufgabe(level as Short) as SpielAufgabenInterface ptr
	Dim as SpielAufgabenInterface pointer sai
	sai = new standardSpielAufgabe()
	if modus = 1 then
		if level <= 4 then
		
			sai = new standardSpielAufgabe()
			select case level
				case 1
					sai->setAnzahlDerRechtecke(5)
				case 2
					sai->setAnzahlDerRechtecke(9)
				case 3
					sai->setAnzahlDerRechtecke(17)
				case 4
					sai->setAnzahlDerRechtecke(27)
			end select
			function = sai
		Else
			Dim as SpielAufgabenInterface pointer sai
			sai = new SpielAufgabenWurf() 
			
			select case level
				case 5
					sai->setAnzahlDerRechtecke(9)
				case 6
					sai->setAnzahlDerRechtecke(17)
			end select
			
			function = sai
		end if
	else
		dim as short multiplikator = 1
		if level >= 2 then
			if rnd() > 0.3 then
				sai = new standardSpielAufgabe() 'TODO spielaufgabe mit letzes Objekt, das ausgewählt wird
			Else
				sai = new SpielAufgabeDasLetzte()
			end if
		end if
		if level >= 3 and rnd() > 0.3 then
			dim as  SpielAufgabeFarben pointer saf
			saf = new SpielAufgabeFarben()
			multiplikator = 2
			if level >= 4  and rnd() > 0.2 then
				saf->setDurcheinander(true)
			end if
			sai = saf
		end if
		if level >= 5 and rnd() < 0.2 then
			sai = new SpielAufgabenWurf()
		end if
		
		if level >= 6 then
			sai->setAnzahlDerPfeile(int(rnd()*3)+1)
		end if
		sai->setAnzahlDerRechtecke((5+rnd()*level*2)*multiplikator)
		return sai
	end if
end function

Sub StandardSpiel.spielen(level as short, spiel as short)
	this.modus = spiel 'TODO Entfernen, wenn statt modus und spiel - Übergabe zwei Klassen für die unterschiedlichen Spiele existieren.

	dim as boolean abbruch = false
	Do
		GET (0,0)-(GrafikEinstellungen.breite-1,GrafikEinstellungen.hoehe-1) , BildschirmHelfer.img2
		
		Dim as SpielAufgabenInterface pointer aktuelleSpielAufgabe = getSpielAufgabe(level)
		
		BildschirmHelfer.lockScreen()
		this.zeichneHintergrund()
		this.zeichneLevelInfo(level, this.getAktuellePunkte)
		
		Dim as trinaer erfolg = aktuelleSpielAufgabe->aufgabeAnbietenUndErfolgZurueckgeben()
		
		if erfolg = trinaer._true then
			this.setAktuellePunkte(this.getAktuellePunkte() + 10)
			
			Color RGB(0,255,0),RGB(255,255,255)
 			GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,8,GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.RICHTIG_PLUS_10), GrafikEinstellungen.skalierungsfaktor, RGB(0,255,0))
			Color RGB(0,0,0), RGB(255,255,255)
	
		elseif erfolg = trinaer._false then
			If this.getAktuellePunkte() > 0 Then 
				Color RGB(255,0,0),RGB(255,255,255)
				GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,8,GrafikEinstellungen.umbruchNach, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH_MINUS_10),GrafikEinstellungen.skalierungsfaktor, GrafikEinstellungen.DunkleresRot )
				Color RGB(0,0,0),RGB(255,255,255)
			Else
				Color RGB(255,0,0),RGB(255,255,255)
				GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,8, GrafikEinstellungen.umbruchNach, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.FALSCH),GrafikEinstellungen.skalierungsfaktoR, GrafikEinstellungen.DunkleresRot)
				Color RGB(0,0,0),RGB(255,255,255) 
			End If
			
			this.setAktuellePunkte(this.getAktuellePunkte() - 10)
		else 'trinaer._null
			
			Color RGB(0,255,0),RGB(255,255,255)
 			GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,8,GrafikEinstellungen.umbruchNach,Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.COMPUTERFEHLER), GrafikEinstellungen.skalierungsfaktor, RGB(70,70,70))
			Color RGB(0,0,0), RGB(255,255,255)
		end if
		if getAktuellePunkte() < 0 then
			this.setAktuellePunkte(0)
		end if
		
		MenueFuehrung.Warten(true)
		sleep 1
	Loop Until this.getAktuellePunkte() >= this.getNoetigePunkte() or abbruch

	Sleep 800
	if not abbruch then
		dim as Integer AnzeilZeilen = 3
		
		dim as integer i
		dim as integer vorschub = 13
		for i = 1 to AnzeilZeilen 
			dim as String text = Uebersetzungen.uebersetzterGlueckwunschtext(Uebersetzungen.Sprache, level, i, getLevelCode(level+1,spiel))
			vorschub  = GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,vorschub, GrafikEinstellungen.umbruchNach,text,GrafikEinstellungen.skalierungsfaktor, RGB(255,200,15))+1
		next
		
		MenueFuehrung.Warten()
	end if

End Sub

sub StandardSpiel.zeichneHintergrund()
	BildschirmHelfer.HintergrundZeichnen(215+40,133+40,44+40,129+40,47+40,90+40)
end sub

sub StandardSpiel.zeichneLevelInfo(aktuellesLevel as Short, punkte as Short)
	GrafikHelfer.schreibeSkaliertInsGitter(0,0, Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.L_E_V_E_L) & aktuellesLevel, GrafikEinstellungen.skalierungsfaktor)  
	GrafikHelfer.schreibeSkaliertInsGitterMitUmbruch(0,1,GrafikEinstellungen.umbruchNach, "" & Punkte & Uebersetzungen.uebersetzterText(Uebersetzungen.Sprache, Uebersetzungen.TextEnum.PUNKTE_VON_PUNKTE), GrafikEinstellungen.skalierungsfaktor)  
end sub

function StandardSpiel.getLevelCode(level as short, spiel as short) as String
	if spiel = 1 and level >= 1 and level <= 6 then
		Dim levelcode(1 to 6) as String = {"","009662","286735","530147","592542","499469"}
		return levelcode(level)
	Elseif spiel = 2 and level>= 1 and level <= 6 then
		Dim levelcode(1 to 7) as String = {"","780845","921615","084068","954167","347574","867379"}
		return levelcode(level)
	end if
	return ""
end function 
