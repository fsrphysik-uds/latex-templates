% Copyright (C) 2026 Fachschaftsrat Physik der Universität des Saarlandes
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3c
% of this license or (at your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2008 or later.
%
% This work has the LPPL maintenance status `maintained'.
% The Current Maintainer of this work is Jannik Zenker.
%
% This work consists of the files fsrbase.sty and fsrprotocol.cls.
% The logo media/fsr-logo.png is NOT part of this work and is not
% covered by the LPPL (see README.md).
%
% --- Dokumentenklasse für Fachschaftsprotokolle --- %
% Basis der Fachschaftsprotokolle ist die Die Dokumentklasse "scrartcl". Die Einstellungen in der Reihnefolge:
% fontsize: Schriftgröße
% paper: Papierformat
% pagesize: Papierformat im PDF ("auto" überträgt das Papierformat aus der Option "paper" auf diese Option).
% parskip: Setzt bei neuen Absätzen einen etwas größeren Abstand zum vorherigen Abschnitt, statt die Zeile einzurücken (ähnlich zu Microsoft Word),
% DIV: Steuert die sogenannte "Satzspiegelberechnung". Diese kontrolliert, wie groß das Verhältnis zwischen Randbereich und Textbereich ist.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fsrprotocol}
\LoadClass[fontsize=11pt, parskip=half, DIV=12]{scrartcl}
\KOMAoptions{paper=a4,pagesize=auto}
\RequirePackage{fsrbase} % Paket, welches default optionen für alle Dokumente des FSR enthält (z.B. Farben, Standard-Pakete oder ein Befehl fürs Logo)

% --- Befehle --- %
% Zum einfacheren Schreiben von Protokollen, definieren wir hier eigene Makros, welche uns Arbeit abnehmen:

% Hilfskommando, welches eine Variable nimmt und einen Fehler in den Logs ausgibt, wenn diese vom Protokollanten nicht gesetzt wurde
\newcommand{\Checkrequiredmacro}[1]{%
  \@ifundefined{#1}{
    \ClassError{fsrprotocol}{Makro \expandafter\string\csname#1\endcsname\space ist nicht definiert}{Bitte definiere \expandafter\string\csname#1\endcsname\space vor \string\begin{document}.}
}{}
}

% Kommando, welches die Kontaktinformationen des FSR ausgibt
\newcommand{\Printcontactinformation}{
	\noindent
	\textbf{Fachschaftsrat aller Physikstudiengänge} \\
	Universität des Saarlandes \\
	Campus E2.6, Raum E.01 \\
	66123 Saarbrücken
}

% Kommando, welches den Titel setzt (mitsamt Datum, Uhrzeit und Ort aus den Variablen)
\newcommand{\Printprotocolheader}{
	\noindent
	\hspace*{0.28\linewidth}%
	\begin{minipage}{0.38\linewidth}
		\centering
		\Large\textbf{Sitzungsprotokoll}
	\end{minipage}%
	\begin{minipage}{0.28\linewidth}
		\raggedleft
		\smash{\raisebox{-2.3cm}{\fsrlogo[4.3cm]}}
	\end{minipage}%
	\par\vspace{2em}
	\Printcontactinformation
	\par
	\textbf{Datum:} \Sitzungsdatum \\
	\textbf{Zeitraum:} \Sitzungszeitraum \\
	\textbf{Ort:} \Sitzungsort \\
	\textbf{Sitzungsleitung:} \Sitzungsleitung \\
	\textbf{Protokollführer:} \Protokollfuehrer \\
	\textbf{Anwesende:} \Anwesenheitsliste \\
	\textbf{Gäste:} \Gaesteliste
	\par\vspace{1em}
	\par\hrule
	\vspace{1em}
}

% Kommandos/Umgebungen für Tagesordnungspunkte/Abstimmungen
% Hilfscounter um Tops/Abstimmungen zu zählen
\newcounter{topcounter} % Für Tagesordnungspunkte
\newcounter{votecounter} % Für Abstimmungen

% Umgebung, um die Tagesordnungspunkte am Anfang des Protokolls aufzulisten
\newenvironment{Toplist}{%
	\textbf{Tagesordnungspunkte}
	\begin{enumerate}
		}{%
	\end{enumerate}
	\par\vspace{1em}
	\par\hrule
}

% Umgebung um Tagesordnungspunkt zu erstellen
% 1. Argument: Titel des Tagesordnungspunkts
\newenvironment{Top}[1]{%
	\stepcounter{topcounter}%
	\setcounter{votecounter}{0}%
	\par\vspace{1em}%
	\textbf{TOP \thetopcounter: #1}%
	\begin{addmargin}[1.5em]{0em}%
		}{%
	\end{addmargin}%
}

% Dieses Kommando wird verwendet, um Abstimmungen zu erstellen.
% 1. Argument = Optional: Vermerk unter dem die Abstimmung NICHT erstellt wird (z.B. bei Vertagung oder Rückzug des Antrags)
% 2. Argument: Enthält das Thema, worüber abgestimmt wird.
% 3. Argument: Anzahl der "Ja"-Stimmen
% 4. Argument: Anzahl der "Nein"-Stimmen
% 5. Argument: Anzahl der Enthaltungen
\newcommand{\Abstimmung}[5][]{%
	\stepcounter{votecounter}%
	\par
	\textit{Abstimmung \thetopcounter.\thevotecounter: #2%
		\ifx&#1&\else\ (\textcolor{cyan}{#1})\fi%
	}%
	\ifx&#1&%
	\begin{center}
		\begin{tabular}{|c|c|c|}
			\hline
			\textbf{Ja} & \textbf{Nein} & \textbf{Enthaltungen} \\
			\hline
			#3          & #4            & #5                    \\
			\hline
		\end{tabular}
		\:
		\ifnum#3>#4
			\textcolor{green!60!black}{angenommen}
		\else
			\textcolor{red}{abgelehnt}
		\fi
	\end{center}
	\fi
}

% --- Fester Dokumentinhalt --- %
% Prüfen, ob der Protokollant die unten stehenden Variablen vor Beginn des Dokuments definiert hat. Danach Titel einfügen
\AtBeginDocument{%
	\Checkrequiredmacro{Anwesenheitsliste}
	\Checkrequiredmacro{Gaesteliste}
	\Checkrequiredmacro{Protokollfuehrer}
	\Checkrequiredmacro{Sitzungsdatum}
	\Checkrequiredmacro{Sitzungsleitung}
	\Checkrequiredmacro{Sitzungsort}
	\Checkrequiredmacro{Sitzungszeitraum}
	\Printprotocolheader
}
