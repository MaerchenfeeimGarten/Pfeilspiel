Namespace Uebersetzungen
	
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
	end enum 

	enum SpracheEnum explicit
		DEUTSCH = 1
		ENGLISCH
		FRANZOESISCH
	end enum
		
	Dim Shared Sprache as SpracheEnum
	
	Declare Function uebersetzterText(s as SpracheEnum, t as TextEnum) As String
	Declare Function uebersetzterGlueckwunschtext(s as SpracheEnum, level as Integer, zeilenauswahl as Integer) As String


End Namespace

Function Uebersetzungen.uebersetzterText(s as Uebersetzungen.SpracheEnum, t as Uebersetzungen.TextEnum) As String
	select case T
		case TextEnum.WELCHES_LEVEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Welches Level wollen sie spielen?"
				case SpracheEnum.ENGLISCH: return "Which level do you want to play?"
				case SpracheEnum.FRANZOESISCH: return "Quel niveau voulez-vous jouer? "
			end select
		case TextEnum.ABBRECHEN:
			select case s
				case SpracheEnum.DEUTSCH: return "Abbrechen"
				case SpracheEnum.ENGLISCH: return "cancel"
				case SpracheEnum.FRANZOESISCH: return "Qannuler"
			end select
		case TextEnum.WOLLEN_NEUES_SPIEL:
			select case s
				case SpracheEnum.DEUTSCH: return "Wollen sie ein neues Spiel anfangen?"
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
				case SpracheEnum.FRANZOESISCH: return "a partir de"
			end select
		case TextEnum.LEVELCODE_PROMPT:
			select case s
				case SpracheEnum.DEUTSCH: return "Levelcode? "
				case SpracheEnum.ENGLISCH: return "Password for this level? "
				case SpracheEnum.FRANZOESISCH: return "Mot de passe pour ce niveau? "
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
				case SpracheEnum.DEUTSCH: return " Punkte von 100, die noetig sind, um das Level zu beenden."
				case SpracheEnum.ENGLISCH: return " points out of 100, which are necessary to finish the level."
				case SpracheEnum.FRANZOESISCH: return " points sur 100, qui sont necessaires pour terminer le niveau."
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow point to?"
				case SpracheEnum.FRANZOESISCH: return "Task: sur lequel le rectangle la fleche rouge pointe-t-elle?"
			end select
		case TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_RECHTECK:
			select case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil?"
				case SpracheEnum.ENGLISCH: return "Task: Which rectangle does the red arrow flies to?"
				case SpracheEnum.FRANZOESISCH: return "Tâche: a quel rectangle la fleche rouge vole-t-elle?"
			end select
		case TextEnum.AUSWAHL_RECHTECK_KLICK:
			select case s
				case SpracheEnum.DEUTSCH: return "Zur Auswahl auf das Rechteck klicken."
				case SpracheEnum.ENGLISCH: return "Click on the rectangle to select."
				case SpracheEnum.FRANZOESISCH: return "Cliquez sur le rectangle pour selectionner."
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
				case SpracheEnum.FRANZOESISCH: return "C'est vrai. Vous obtenez 10 points de plus."
			end select
		case TextEnum.FALSCH_MINUS_10:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch. Es werden 10 Punkte abgezogen."
				case SpracheEnum.ENGLISCH: return "Incorrect. You loose 10 points."
				case SpracheEnum.FRANZOESISCH: return "Faux. Il y aura 10 points."
			end select
		case TextEnum.FALSCH:
			select Case s
				case SpracheEnum.DEUTSCH: return "Falsch."
				case SpracheEnum.ENGLISCH: return "Incorrect."
				case SpracheEnum.FRANZOESISCH: return "Faux."
			end select
		case TextEnum.BITTE_WAEHLE_SPIEL:
			select Case s
				case SpracheEnum.DEUTSCH: return "Bitte wählen Sie ein Spiel aus."
				case SpracheEnum.ENGLISCH: return "Please choose a game."
				case SpracheEnum.FRANZOESISCH: return "S'il vous plait, choisissez un jeu."
			end select
		case TextEnum.STANDARD_SPIEL
			select Case s
				case SpracheEnum.DEUTSCH: return "Standard"
				case SpracheEnum.ENGLISCH: return "Default"
				case SpracheEnum.FRANZOESISCH: return "Par defaut"
			end select
		case TextEnum.VIELFALT_PPT
			select Case s
				case SpracheEnum.DEUTSCH: return "Vielfalt.ppt"
				case SpracheEnum.ENGLISCH: return "diversity.ppt"
				case SpracheEnum.FRANZOESISCH: return "diversite.ppt"
			end select
		case TextEnum.AUFGABE_PFEIL_ZEIGT_AUF_LETZTES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck zeigt der rote Pfeil zuletzt?"
				case SpracheEnum.ENGLISCH: return "Task: On which rectangle does the red arrow last show?"
				case SpracheEnum.FRANZOESISCH: return "Tache: Sur quel rectangle la fleche rouge montre-t-elle en dernier lieu? "
			end select
		case TextEnum.AUFGABE_PFEIL_FLIEGT_AUF_LETZTES_RECHTECK
			select Case s
				case SpracheEnum.DEUTSCH: return "Aufgabe: Auf welches Rechteck fliegt der rote Pfeil zuletzt?"
				case SpracheEnum.ENGLISCH: return "Task: On which rectangle does the red arrow last fly?"
				case SpracheEnum.FRANZOESISCH: return "Tache : Sur quel rectangle la fleche rouge vole-t-elle en dernier lieu?"
			end select
	end select 'TextId
end function

function Uebersetzungen.uebersetzterGlueckwunschtext(s as Uebersetzungen.SpracheEnum, level as Integer, zeilenauswahl as Integer) As String
	dim as Integer AnzeilZeilen = 3
	dim Zeile(1 to AnzeilZeilen) as String
	Select Case s
		Case Uebersetzungen.SpracheEnum.DEUTSCH:
			Select Case level
				Case 1 
					Zeile(1) = "Du hast nun 100 Punkte und damit das Level geloest!  "
					Zeile(2) = "Um das naechste Level spielen zu koennen, brauchst du"
					Zeile(3) = "einen Freischaltcode. Dieser lautet:     LSTART1     "
				Case 2
					Zeile(1) = "Super! Nun hast du mit 100 Punkten auch Level 2 durch-"
					Zeile(2) = "gespielt. Hier ist der naechste Freischaltcode fuer "
					Zeile(3) = "das Level 3:    S3LEVEL      Viel Spass!            "
				Case 3
					Zeile(1) = "Du hast nun die Haelfte aller Level gespielt! Weiter"
					Zeile(2) = "so! Der naechste Levelcode fuer das Level 4 heisst:  "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt"
					Zeile(2) = "fehlen demnach noch 2. Der Levelcode fuer das Level 5  "
					Zeile(3) = "lautet:    LEVE54321L                                "
				Case 5
					Zeile(1) = "Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-"
					Zeile(2) = "noch das Level 6. Auch dafuer gibt es wieder einen  "
					Zeile(3) = "Code:    LE654STAR                                    "
				Case 6
					Zeile(1) = "Du hast nun 100 Punkte und das Level geloest! Damit  "
					Zeile(2) = "hast du auch das komplette Spiel durchgespielt! Herz-"
					Zeile(3) = "lichen Glueckwunsch!     "
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, haettest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
		Case Uebersetzungen.SpracheEnum.ENGLISCH:
			Select Case level
				Case 1 
					Zeile(1) = "You now have 100 points and solved the level! To be   "
					Zeile(2) = "able to play the next level, you will need an unlock  "
					Zeile(3) = "code. This is: LSTART1                                "
				Case 2
					Zeile(1) = "Great! Now you have played through level 2 with 100   "
					Zeile(2) = "points. Here is the next unlock code for the level 3: "
					Zeile(3) = "          S3LEVEL      Have fun!                      "
				Case 3:                   
					Zeile(1) = "You have now played half of all levels! Continue like"
					Zeile(2) = "this! The next level code for level 4 is:            "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "You have already played through 4 of 6 levels. Great!"
					Zeile(2) = "Now 2 more to go. The level code for level 5 is: "
					Zeile(3) = "   LEVE54321L                                "
				Case 5
					Zeile(1) = "You have almost completed the game. Now only level 6 "
					Zeile(2) = "is missing. For which there is again a code for this "
					Zeile(3) = "level too::   LE654STAR                              "
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
			'TODO: Muss noch übersetzt werden (auf Französisch)
			Select Case level
				Case 1 
					Zeile(1) = "Du hast nun 100 Punkte und damit das Level geloest!  "
					Zeile(2) = "Um das naechste Level spielen zu koennen, brauchst du"
					Zeile(3) = "einen Freischaltcode. Dieser lautet:     LSTART1     "
				Case 2
					Zeile(1) = "Super! Nun hast du mit 100 Punkten auch Level 2 durch-"
					Zeile(2) = "gespielt. Hier ist der naechste Freischaltcode fuer "
					Zeile(3) = "das Level 3:    S3LEVEL      Viel Spass!            "
				Case 3
					Zeile(1) = "Du hast nun die Haelfte aller Level gespielt! Weiter"
					Zeile(2) = "so! Der naechste Levelcode fuer das Level 4 heisst:  "
					Zeile(3) = "   LEV4WIS3                                          "
				Case 4
					Zeile(1) = "Du hast schon 4 von 6 Level durchgespielt. Super! Jetzt"
					Zeile(2) = "fehlen demnach noch 2. Der Levelcode fuer das Level 5  "
					Zeile(3) = "lautet:    LEVE54321L                                "
				Case 5
					Zeile(1) = "Du hast das Spiel fast durchgespielt. Jetzt fehlt nur-"
					Zeile(2) = "noch das Level 6. Auch dafuer gibt es wieder einen  "
					Zeile(3) = "Code:    LE654STAR                                    "
				Case 6
					Zeile(1) = "Du hast nun 100 Punkte und das Level geloest! Damit  "
					Zeile(2) = "hast du auch das komplette Spiel durchgespielt! Herz-"
					Zeile(3) = "lichen Glueckwunsch!     "
				Case Else
					Zeile(1) = "Du hast nun 100 Punkte! Da das bei nur EINEM Rechteck "
					Zeile(2) = "aber nichts besonderes ist, haettest du das Spiel gar "
					Zeile(3) = "nicht spielen brauchen..."
			End Select
	End Select 'Sprache
	return Zeile(zeilenauswahl)
End Function
