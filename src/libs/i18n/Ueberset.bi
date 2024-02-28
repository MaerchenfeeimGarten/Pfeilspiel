#include once "libs/strings/strings.bi"

Namespace Uebersetzungen
	enum TextFarbe explicit
		ROT
		GRUEN
		BLAU
		TURKIES
		VIOLETT
		GELB
		ORANGE
		SCHWARZ
		WEISS
		BRAUN
	end enum
	
	enum TextEnum explicit
		WELCHES_LEVEL 
		ABBRECHEN 
		WOLLEN_NEUES_SPIEL 
		JA 
		NEIN 
		WEITER 
		LEVELCODE_PROMPT
		WILLKOMMEN_BEI_LEVEL 
		FALSCHE_EINGABE_ENDE
		PUNKTE_VON_PUNKTE 
		AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK 
		AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK 
		AUSWAHL_RECHTECK_KLICK 
		FALSCH_NEUER_VERSUCH 
		L_E_V_E_L 
		RICHTIG_PLUS_10 
		FALSCH_MINUS_10 
		FALSCH 
		BITTE_WAEHLE_SPIEL
		STANDARD_SPIEL
		VIELFALT_PPT
		AUFGABE_PFEIL_ZEIGT_AUF_LETZTES_RECHTECK
		AUFGABE_PFEIL_FLIEGT_AUF_LETZTES_RECHTECK
		AUFGABE_PFEIL_ZEITG_AUF_LETZTES_RECHTECK
		AUFGABE_PFEIL_ZEIGT_AUF_ROTES_RECHTECK
		AUFGABE_PFEIL_ZEIGT_AUF_GRUENES_RECHTECK
		AUFGABE_PFEIL_ZEIGT_AUF_BLAUES_RECHTECK
		COMPUTERFEHLER
		SPRACHE_WAEHLEN
	end enum 

	enum SpracheEnum explicit
		DEUTSCH = 1
		ENGLISCH
		FRANZOESISCH
	end enum
		
	Dim Shared Sprache as SpracheEnum
	
	Declare Function uebersetzterText(s as SpracheEnum, t as TextEnum) As String
	Declare Function uebersetzterGlueckwunschtext(s as SpracheEnum, level as Integer, zeilenauswahl as Integer, levelcode as String) As String
	Declare function ersetzteFarbennameVonPfeil(s as Uebersetzungen.SpracheEnum, text as string, f as TextFarbe) as String

End Namespace

Function Uebersetzungen.uebersetzterText(s as Uebersetzungen.SpracheEnum, t as Uebersetzungen.TextEnum) As String
	select case T
		case TextEnum.WELCHES_LEVEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Welches Level wollen Sie spielen?"
				case SpracheEnum.ENGLISCH: return "Which level do you want to play?"
				case SpracheEnum.FRANZOESISCH: return "Quel niveau voulez-vous jouer?"
			end select
		case TextEnum.ABBRECHEN:
			select case s
				case SpracheEnum.DEUTSCH: return "abbrechen"
				case SpracheEnum.ENGLISCH: return "cancel"
				case SpracheEnum.FRANZOESISCH: return "annuler"
			end select
		case TextEnum.WOLLEN_NEUES_SPIEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Wollen Sie ein neues Spiel anfangen?"
				case SpracheEnum.ENGLISCH: return "Do you want to begin a new game?"
				case SpracheEnum.FRANZOESISCH: return "Voulez-vous commencer un nouveau jeu?"
			end select
		case TextEnum.JA:
			select case s
				case SpracheEnum.DEUTSCH: return "Ja"
				case SpracheEnum.ENGLISCH: return "Yes"
				case SpracheEnum.FRANZOESISCH: return "Oui"
			end select
		case TextEnum.NEIN:
			select case s
				case SpracheEnum.DEUTSCH: return "Nein"
				case SpracheEnum.ENGLISCH: return "No"
				case SpracheEnum.FRANZOESISCH: return "Non"
			end select
		case TextEnum.WEITER:
			select case s
				case SpracheEnum.DEUTSCH: return "weiter"
				case SpracheEnum.ENGLISCH: return "proceed"
				case SpracheEnum.FRANZOESISCH: return "continuer"
			end select
		case TextEnum.LEVELCODE_PROMPT:
			select case s
				case SpracheEnum.DEUTSCH: return "Levelcode? >"
				case SpracheEnum.ENGLISCH: return "Password for this level? >"
				case SpracheEnum.FRANZOESISCH: return "Mot de passe pour ce niveau? >"
			end select
		case TextEnum.WILLKOMMEN_BEI_LEVEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Willkommen bei L E V E L   "
				case SpracheEnum.ENGLISCH: return "Welcome to  L E V E L  "
				case SpracheEnum.FRANZOESISCH: return "Bienvenue au N I V E A U   "
			end select
		case TextEnum.FALSCHE_EINGABE_ENDE:
			select case s
				case SpracheEnum.DEUTSCH: return "Falsche Eingabe. Programm wird geschlossen."
				case SpracheEnum.ENGLISCH: return "Wrong Password. The program will be closed."
				case SpracheEnum.FRANZOESISCH: return "Mot de passe faux. Le programme sera clos."
			end select
		case TextEnum.PUNKTE_VON_PUNKTE:
			select case s
				case SpracheEnum.DEUTSCH: return " Punkte von 100, die nîtig sind, um das Level zu beenden."
				case SpracheEnum.ENGLISCH: return " points out of 100, which are necessary to finish the level."
				case SpracheEnum.FRANZOESISCH: return " points sur 100, qui sont nÇcessaires pour terminer le niveau."
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: sur quel le rectangle la fläche rouge pointe-t-elle?"
			end select
		case TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow flies to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: a quel rectangle la fläche rouge vole-t-elle?"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEITG_AUF_LETZTES_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil zuletzt?"
				case SpracheEnum.ENGLISCH: return "Task: Which last rectangle does the red arrow points to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle la fläche rouge montre-t-elle en dernier lieu?"
			end select
		case TextEnum.AUSWAHL_RECHTECK_KLICK:
			select case s
				case SpracheEnum.DEUTSCH: return "Zur Auswahl auf das Rechteck klicken."
				case SpracheEnum.ENGLISCH: return "Click on the rectangle to select."
				case SpracheEnum.FRANZOESISCH: return "Cliquez sur le rectangle pour sÇlectionner."
			end select
		case TextEnum.FALSCH_NEUER_VERSUCH:
			select case s
				case SpracheEnum.DEUTSCH: return "Falsche Eingabe. Neuer Versuch: "
				case SpracheEnum.ENGLISCH: return "Incorrect input. Next try: "
				case SpracheEnum.FRANZOESISCH: return "Inconte incorrect. Prochaine tentative: "
			end select
		case TextEnum.L_E_V_E_L:
			select Case s
				case SpracheEnum.DEUTSCH: return "L E V E L   "
				case SpracheEnum.ENGLISCH: return "L E V E L   "
				case SpracheEnum.FRANZOESISCH: return "N I V E A U  "
			end select
		case TextEnum.RICHTIG_PLUS_10:
			select Case s
				case SpracheEnum.DEUTSCH: return "Richtig. Du bekommst 10 weitere Punkte."
				case SpracheEnum.ENGLISCH: return "Right. You get 10 more points."
				case SpracheEnum.FRANZOESISCH: return "C'est vrai. Vous gagnez 10 points."
			end select
		case TextEnum.FALSCH_MINUS_10:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch. Es werden 10 Punkte abgezogen."
				case SpracheEnum.ENGLISCH: return "Incorrect. You loose 10 points."
				case SpracheEnum.FRANZOESISCH: return "Faux. Vous perdez 10 points."
			end select
		case TextEnum.FALSCH:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch."
				case SpracheEnum.ENGLISCH: return "Incorrect."
				case SpracheEnum.FRANZOESISCH: return "Faux."
			end select
		case TextEnum.BITTE_WAEHLE_SPIEL:
			select Case s
				case SpracheEnum.DEUTSCH: return "Bitte wÑhlen Sie ein Spiel aus."
				case SpracheEnum.ENGLISCH: return "Please choose a game."
				case SpracheEnum.FRANZOESISCH: return "S'il vous plait, choisissez un jeu."
			end select
		case TextEnum.STANDARD_SPIEL
			select Case s
				case SpracheEnum.DEUTSCH: return "Standard"
				case SpracheEnum.ENGLISCH: return "Default"
				case SpracheEnum.FRANZOESISCH: return "Par dÇfaut"
			end select
		case TextEnum.VIELFALT_PPT
			select Case s
				case SpracheEnum.DEUTSCH: return "Vielfalt.ppt"
				case SpracheEnum.ENGLISCH: return "diversity.ppt"
				case SpracheEnum.FRANZOESISCH: return "DiversitÇ.ppt"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_LETZTES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil zuletzt?"
				case SpracheEnum.ENGLISCH: return "Task: On which rectangle does the red arrow last show?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle la fläche rouge montre-t-elle en dernier lieu?"
			end select
		case TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_LETZTES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil zuletzt?"
				case SpracheEnum.ENGLISCH: return "Task: On which rectangle does the red arrow last fly?"
				case SpracheEnum.FRANZOESISCH: return "Tache : Sur quel rectangle la fläche rouge vole-t-elle en dernier lieu?"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_ROTES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches rote Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: On which red rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle rouge pointe-t-elle la fläche rouge?"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_GRUENES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches grÅne Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: On which green rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle vert la fläche rouge pointe-t-elle?"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_BLAUES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches blaue Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: On which blue rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle bleu la fläche rouge pointe-t-elle?"
			end select
		case TextEnum.COMPUTERFEHLER
			select Case s
				case SpracheEnum.DEUTSCH: return "Upsi. Auch der Computer macht mal einen Fehler..."
				case SpracheEnum.ENGLISCH: return "Upsi. The computer also makes a mistake... "
				case SpracheEnum.FRANZOESISCH: return "Upsi. L'ordinateur fait aussi une erreur... "
			end select
		case TextEnum.SPRACHE_WAEHLEN
			select Case s
				case SpracheEnum.DEUTSCH: return "DE: Bitte eine Sprache wÑhlen."
				case SpracheEnum.ENGLISCH: return "EN: Please choose a language. "
				case SpracheEnum.FRANZOESISCH: return "FR: Veuillez choisir une langue"
			end select
	end select 'TextId
end function

function Uebersetzungen.ersetzteFarbennameVonPfeil(s as Uebersetzungen.SpracheEnum, text as string, f as TextFarbe) as String
	select case f
		case TextFarbe.ROT
			return text
		case TextFarbe.GRUEN
			select Case s
				case SpracheEnum.DEUTSCH
					strings.replace(text, "rote Pfeil", "grÅne Pfeil")
				case SpracheEnum.ENGLISCH
					strings.replace(text, "red arrow", "green arrow")
				case SpracheEnum.FRANZOESISCH
					strings.replace(text,"fläche rouge", "fläche verte ")
			end select
		case TextFarbe.BLAU
			select Case s
				case SpracheEnum.DEUTSCH
					 strings.replace(text, "rote Pfeil", "blaue Pfeil")
				case SpracheEnum.ENGLISCH
					  strings.replace(text, "red arrow", "blue arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche bleue ")
			end select
		case TextFarbe.TURKIES
			select Case s
				case SpracheEnum.DEUTSCH
					 strings.replace(text, "rote Pfeil", "tÅrkise Pfeil")
				case SpracheEnum.ENGLISCH
					  strings.replace(text, "red arrow", "turquoise arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche turquoise")
			end select
		case TextFarbe.SCHWARZ
			select Case s
				case SpracheEnum.DEUTSCH
					 strings.replace(text, "rote Pfeil", "schwarze Pfeil")
				case SpracheEnum.ENGLISCH
					  strings.replace(text, "red arrow", "black arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche noire")
			end select
		case TextFarbe.WEISS
			select Case s
				case SpracheEnum.DEUTSCH
					 strings.replace(text, "rote Pfeil", "wei·e Pfeil")
				case SpracheEnum.ENGLISCH
					  strings.replace(text, "red arrow", "white arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche blanche")
			end select
		case TextFarbe.ORANGE
			select Case s
				case SpracheEnum.DEUTSCH
					strings.replace(text, "rote Pfeil", "orange Pfeil")
				case SpracheEnum.ENGLISCH
					strings.replace(text, "red arrow", "orange arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche orange")
			end select
		case TextFarbe.VIOLETT
			select Case s
				case SpracheEnum.DEUTSCH
					strings.replace(text, "rote Pfeil", "violette Pfeil")
				case SpracheEnum.ENGLISCH
					strings.replace(text, "red arrow", "violet arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche violette")
			end select
		case TextFarbe.GELB
			select Case s
				case SpracheEnum.DEUTSCH
					strings.replace(text, "rote Pfeil", "gelbe Pfeil")
				case SpracheEnum.ENGLISCH
					strings.replace(text, "red arrow", "yellow arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche jaune")
			end select
		case TextFarbe.BRAUN
			select Case s
				case SpracheEnum.DEUTSCH
					strings.replace(text, "rote Pfeil", "braune Pfeil")
				case SpracheEnum.ENGLISCH
					strings.replace(text, "red arrow", "brown arrow")
				case SpracheEnum.FRANZOESISCH
					 strings.replace(text,"fläche rouge", "fläche brune")
			end select
	end select
	return text
end function
function Uebersetzungen.uebersetzterGlueckwunschtext(s as Uebersetzungen.SpracheEnum, level as Integer, zeilenauswahl as Integer, levelcode as String) As String
	dim as Integer AnzeilZeilen = 3
	dim Zeile(1 to AnzeilZeilen) as String
	Select Case s
		Case Uebersetzungen.SpracheEnum.DEUTSCH:
			Select Case level
				Case 1 
					Zeile(1) = "Du hast nun 100 Punkte und damit das Level gelîst!  "
					Zeile(2) = "Um das nÑchste Level spielen zu kînnen, brauchst du"
					Zeile(3) = "einen Freischaltcode. Dieser lautet:     "+levelcode+"     "
				Case 2
					Zeile(1) = "Super! Nun hast du mit 100 Punkten auch Level 2 durch-"
					Zeile(2) = "gespielt. Hier ist der nÑchste Freischaltcode fÅr "
					Zeile(3) = "das Level 3:    "+levelcode+"      Viel Spa·!            "
				Case 3
					Zeile(1) = "Du hast nun die HÑlfte aller Level gespielt! Weiter"
					Zeile(2) = "so! Der nÑchste Levelcode fÅr das Level 4 hei·t:  "
					Zeile(3) = "   "+levelcode+"                                          "
				Case 4
					Zeile(1) = "Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt"
					Zeile(2) = "fehlen demnach noch 2. Der Levelcode fÅr das Level 5  "
					Zeile(3) = "lautet:    "+levelcode+"                                "
				Case 5
					Zeile(1) = "Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-"
					Zeile(2) = "noch das Level 6. Auch dafÅr gibt es wieder einen  "
					Zeile(3) = "Code:    "+levelcode+"                                    "
				Case 6
					Zeile(1) = "Du hast nun 100 Punkte und das Level gelîst! Damit  "
					Zeile(2) = "hast du auch das komplette Spiel durchgespielt! Herz-"
					Zeile(3) = "lichen GlÅckwunsch!     "
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, hÑttest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
		Case Uebersetzungen.SpracheEnum.ENGLISCH:
			Select Case level
				Case 1 
					Zeile(1) = "You now have 100 points and solved the level! To be   "
					Zeile(2) = "able to play the next level, you will need an unlock  "
					Zeile(3) = "code. This is: "+levelcode+"                                "
				Case 2
					Zeile(1) = "Great! Now you have played through level 2 with 100   "
					Zeile(2) = "points. Here is the next unlock code for the level 3: "
					Zeile(3) = "          "+levelcode+"      Have fun!                      "
				Case 3:                   
					Zeile(1) = "You have now played half of all levels! Continue like"
					Zeile(2) = "this! The next level code for level 4 is:            "
					Zeile(3) = "   "+levelcode+"                                          "
				Case 4
					Zeile(1) = "You have already played through 4 of 6 levels. Great!"
					Zeile(2) = "Now 2 more to go. The level code for level 5 is: "
					Zeile(3) = "   "+levelcode+"                                "
				Case 5
					Zeile(1) = "You have almost completed the game. Now only level 6 "
					Zeile(2) = "is missing. For which there is again a code for this "
					Zeile(3) = "level too::   "+levelcode+"                              "
				Case 6
					Zeile(1) = "You now have 100 points and solved the level! With this"
					Zeile(2) = "you have played through the whole game! That's great!  "
					Zeile(3) = "Congratulations!"
				Case Else
					Zeile(1) = "You now have 100 points! Since that is with only ONE"
					Zeile(2) = "rectangle but nothing special, you wouldn't have to "
					Zeile(3) = "play the game at all.."
			End Select
		Case Uebersetzungen.SpracheEnum.FRANZOESISCH:
			'TODO: Muss noch Åbersetzt werden (auf Franzîsisch)
			Select Case level
				Case 1 
					Zeile(1) = "Vous avez maintenant 100 points et vous avez ainsi"
					Zeile(2) = "resolu le niveau. Pour jouer au niveau suivant, vous"
					Zeile(3) = "avez besoin d'un code d'activation:   "+levelcode
				Case 2
					Zeile(1) = "C'est super. Maintenant vous avez jouÇ jusqu'au niveau"
					Zeile(2) = "2 avec 100 points. Voici le prochain code d'activation"
					Zeile(3) = "pour le niveau 3: "+levelcode+" Amusez-vous bien. " 
				Case 3
					Zeile(1) = "Vous avez maintenant jouÇ la moitiÇ de tous les niveaux." 
					Zeile(2) = "Continuez comme áa. Le code de niveau suivant pour le"
					Zeile(3) = "niveau 4 est: "+levelcode
				Case 4
					Zeile(1) = "Vous avez dÇjÖ jouÇ 4 niveaux sur 6. C'est super. Il "
					Zeile(2) = "manque donc donc encore 2. Le code de niveau 5 est:"
					Zeile(3) = "   " +levelcode+"                                "
				Case 5
					Zeile(1) = "Vous avez presque jouÇ Ö travers le jeu. Aujourd'hui,"
					Zeile(2) = "seul le niveau manque de 6. Il existe egalement un code"
					Zeile(3) = "a cet effet:     "+levelcode+"                   "
				Case 6
					Zeile(1) = "Vous avez maintenant 100 points et le niveau. Avec cela,"
					Zeile(2) = "vous avez jouÇ tout au long du jeu. FÇlicitations."
					Zeile(3) = ""
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, hÑttest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
	End Select 'Sprache
	return Zeile(zeilenauswahl)
End Function
