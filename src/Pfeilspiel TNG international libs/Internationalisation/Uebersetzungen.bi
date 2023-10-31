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
	end enum 

	enum SpracheEnum explicit
		DEUTSCH = 1
		ENGLISCH
		FRANZOESISCH
	end enum
		
	Dim Shared Sprache as SpracheEnum
	
	Declare Function uebersetzterText(s as SpracheEnum, t as TextEnum) As String

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
	end select 'TextId
End Function
