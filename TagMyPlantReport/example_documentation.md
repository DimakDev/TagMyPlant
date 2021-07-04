# Inhaltsverzeichnis

- [Belegarbeit: XSD4Visu+ (Muster)](#belegarbeitxsd4visu-muster)
- [Motivation](#motivation)
- [Anforderungen](#anforderungen)
    - [Einleitung](#einleitung)
    - [Allgemeine Beschreibung](#allgemeine-beschreibung)
        - [Produkt Umgebung](#produkt-umgebung)
        - [Benutzer Eigenschaften](#benutzer-eigenschaften)
    - [Spezifische Anforderungen](#spezifische-anforderungen)
        - [Funktionale Anforderungen](#funktionale-anforderungen)
        - [Externe Schnittstellenanforderungen](#externe-schnittstellenanforderungen)
        - [Qualitätsmerkmale](#qualitaetsmerkmale)
- [Entwurfsvarianten](#entwurfsvarianten)
    - [XSD 1.0 oder XSD 1.1](#xsd-10-oder-xsd-11)
    - [Struktur des XML-Schemas](#struktur-des-xml-schemas)
    - [Dokumentation](#dokumentation)
- [Entwurf](#entwurf)
    - [XML Schema](#xml-schema)
    - [Dokumentation](#dokumentation1)
- [Werkzeuge](#werkzeuge)
- [Implementierung](#implementierung)
    - [XML Schema](#xml-schema1)
    - [Python Script zum Ersetzen der IDs](#python-script-zum-ersetzen-der-ids)
    - [XSL-Transformation](#xsl-transformation)
- [Diskussion der Ergebnisse](#diskussion-der-ergebnisse)
- [Quellennachweis und Literaturverzeichnis](#quellennachweis-und-literaturverzeichnis)
- [Lizenzen der verwendeten Software](#lizenzen-der-verwendeten-software)
- [Anhang](#anhang)

# Belegarbeit: XSD4Visu+ (Muster)

Bearbeitender: ??</br>
Studiengang: ??</br>
Matrikelnummer: ??

# Motivation

SCADA-Systeme werden in der Automatisierungstechnik zum Erstellen umfangreicher Bedien- und Beobachtungslösungen für technische Anlagen und Prozesse genutzt. Besonders die manuelle Erstellung von Bedienbildern erfordert einen großen Aufwand, obwohl alle dafür erforderlichen Daten bereits digital in Form von Planungsdaten und Anlagendaten zur Verfügung stehen. Daher ist eine automatische Generierung dieser Bedienbilder in Rahmen einer modellgetriebenen Entwicklung denkbar und erstrebenswert. Nach einer Umwandlung der Anlagendaten in ein Anlagenmodell kann aus diesem Modell wiederum ein HMI-Modell generiert werden und daraus wiederum eine lauffähige HMI-Anwendung.

Da die SCADA-Software Visu+ der Firma Phoenix Contact eine XML-Schnittstelle für alle Projektierungsdaten des SCADA-Systems und somit auch für die Bedienbilder des HMI anbietet, eignet sich diese Software für die Integration in die modellgetriebene Entwicklung. Das HMI-Modell kann im XML-Format direkt in Visu+ importiert und dort ausgeführt werden. Vor allem in der Entwicklungsphase der Modelltransformation ist allerdings eine Validierung der generierten XML notwendig, um eventuelle Probleme bei der Transformation zu erkennen. Außerdem wird eine ausführliche Dokumentation der XML-Elemente und Attribute in geeigneter Form benötigt, um dem Entwickler die zur Verfügung stehenden Projektierungsmöglichkeiten eines Bedienbildes schnell und einfach zugänglich zu machen.

Da von Phoenix Contact weder ein XML Schema noch eine ausführliche Dokumentation der XML-Dateien bereit gestellt wird, ist im Rahmen dieses Projekts eine XSD für die XML-Datei der Bedienbilder zu erstellen, die mit Kommentaren zur Dokumentation versehen ist. Anhand dieses Schemas kann die XML später validiert werden und der Entwickler hat einen Überblick über den Aufbau und die Projektierungsmöglichkeiten der XML.

# Anforderungen

## Einleitung

Für die XML-Dateien, die zur Projektierung der Bedienbilder in der SCADA-Software Visu+ der Firma Phoenix Contact dienen, soll ein XML-Schema entwickelt. Außerdem ist eine ausführliche Dokumentation der Funktionen, die über die Werte der XML-Elemente und -Attribute festgelegt werden, durchzuführen.

## Allgemeine Beschreibung

### Produkt Umgebung

Die XSD-Datei soll in die modellgetriebene Entwicklung integrierbar und deshalb in Eclipse mit dem Plugin xsd2ecore lauffähig und validierbar sein. Aus der XSD-Datei soll mithilfe von xsd2ecore ein Ecore-Modell generiert werden können.

### Benutzer Eigenschaften

Die XSD-Datei, sowie die Dokumentation dieser, sind für die Anwendung in der Entwicklung einer Lösung zur modellgetriebenen Erstellung von Bedienbildern gedacht und wird somit von Benutzern mit umfangreichen Kenntnissen im Bereich XML und Softwareentwicklung genutzt.

## Spezifische Anforderungen

### Funktionale Anforderungen

- **F1** Das XML-Schema soll mindestens die allgemeinen Einstellungen zum Prozessbild und die Objekttypen „base“, „poly“, „Button“ und „group“ beschreiben. Je nach Aufwand sind außerdem die Objekttypen „TabObj“, „ListBox“ und ggf. „Gauge“ zu beschreiben.
- **F2** Falsche Werteeingaben oder ein falscher Aufbau der XML-Datei sind soweit möglich durch Restriktionen oder Ähnliches im XML-Schema zu verbieten.
- **F3** Es ist eine umfangreiche Dokumentation der XSD-Datei zu erstellen.

### Externe Schnittstellenanforderungen

- **S1** Die zu erstellende XSD-Datei soll in Eclipse mit dem Plugin xsd2ecore lauffähig und validierbar sein. Aus der XSD-Datei soll mithilfe von xsd2ecore ein Ecore-Modell generiert werden können.

### Qualitätsmerkmale

- **Q1** Das zu entwickelnde XML-Schema soll in Visu+ erstellte XML-Dateien der Prozessbilder korrekt validieren.
- **Q2** Das XML-Schema soll XML-Dateien, die in Visu+ nicht gültig wären, nicht validieren.
- **Q3** Die Funktion und der Wertebereich jedes Elements oder Attributs soll aus der Dokumentation der XSD-Datei ersichtlich sein.
- **Q4** Die Dokumentation soll in eine übersichtliche, gut lesbare Form gebracht werden.

# Entwurfsvarianten

## XSD 1.0 oder XSD 1.1

Beim Entwurf stellte sich zunächst die Frage, ob die XML Schema Spezifikation in Version 1.0 oder 1.1 genutzt werden soll. Durch die Verwendung von „assert“, „assertion“ und „alternative“ aus der XSD 1.1 Spezifikation ist es möglich komplexere Werte- und Typbeschränkungen für Elemente und Attribute anzugeben, die von den Werten anderer Elemente oder Attribute abhängen [1]. Solche Abhängigkeiten kommen in der XML-Datei der Prozessbilder vor, z.B. bestimmt der Wert des Elements object eines Grafikobjekts, welche Geschwisterelemente object besitzt, sind mit den Mitteln der XSD 1.0 Spezifikation allerdings nicht beschreibbar. Andererseits wurde als Anforderung definiert, dass es möglich sein soll die XSD-Datei in Eclipse mit dem Plugin „xsd2ecore“ zu validieren und ein Ecore-Modell daraus zu generieren. Da das Plugin „xsd2ecore“ nur die XSD 1.0 Spezifikation unterstützt, scheidet die Verwendung von XSD 1.1 trotz der erweiterten Beschreibungsmöglichkeiten aus.

## Struktur des XML-Schemas

Bei der Strukturierung der XSD-Datei können die Elemente und Attribute entweder genauso wie in der zugehörigen XML-Datei geschachtelt aufgeschrieben werden. In diesem Fall sind alle Elemente und Attribute lokal definitiert. Die andere Möglichkeit ist eine globale Definition von Attributen, Elementen und Typen. Dies bietet den Vorteil, dass bei mehrmals vorkommenden Typen, Attributen oder Elementen nur auf die globale Definition referenziert werden muss. Außerdem ist bei sehr umfangreichen Schemata durch diese Strukturierung eine bessere Lesbarkeit und Erweiterbarkeit gegeben. Daher wird diese Methode der Strukturierung angewandt.

## Dokumentation

Zur Dokementation des XML-Schemas bieten sich mehrere Möglichkeiten. So wäre beispielsweise eine separate Dokumentation möglich, was jedoch laut Anforderungen nicht gewünscht ist. Eine andere Möglichkeit ist das Einfügen von Kommentaren in die XSD-Datei, was allerdings aufgrund des Umfangs der Datei sehr unübersichtlich werden würde. Die dritte Möglichkeit ist das Einfügen von Kommentaren im sogenannten annotation-Element in der XSD-Datei in der Form:

```
<xs:annotation>
  <xs:documentation>Kommentar</xs:documentation>
</xs:annotation>
```

Diese Kommentare können als erstes Kindelement jedes Elements, Attributs und Typs eingefügt werden. Dadurch bietet sich die Möglichkeit mithilfe einer passenden XSLT die Dokumentation z.B. als HTML-Datei darzustellen. Zusätzlich sind die Kommentare auch in der XSD-Datei direkt vorhanden.

# Entwurf

Der entgültige Entwurf besteht aus der Erstellung einer XML Schema Datei, die die XML Datei eines Prozessbildes - wie sie von Visu+ erzeugt wird - beschreibt. Zur Dokumentation soll außerdem eine html-Datei aus der XSD durch XSL-Transformation erstellt werden. Diese beiden Teilaufgaben werden in den folgenden Abschnitten näher erläutert.

## XML Schema

Das XML Schema wird basierend auf der Analyse von in Visu+ erzeugten XML-Dateien erstellt. Die Analyse ergibt, dass das Wurzelelement der XML „MovResource“ sechs mögliche Kindelemente, die jeweils maximal einmal vorkommen, besitzt. Vier davon - „General“, „Background“, „Style“ und „Execution“ - enthalten allgemeine Einstellungen zum Prozessbild als Attribute. Das Kindelement „VariableList“ kann beliebig viele Kindelemente „Variable“ enthalten, die die lokalen Variablen des Prozessbildes beschreiben. Das sechste Kindelement von „MovResource“ - die „ListSynopticDraw“ - enthält beliebig viele Kindelemente „child“, die jeweils ein grafisches Objekt des Prozessbildes beschreiben. Dieser grundlegende Aufbau der Prozessbild-XML ist in Abbildung 1 zu sehen.

Der Aufbau des Elements „child“ wurde besonders ausführlich analysiert, da dieser sehr komplex ist. Die Kindelemente von „child“ hängen vom Typ des grafischen Objekts ab, der im ersten Kindelement von child „object“ als Wert angegeben wird. Da eine solche Abhängigkeit zwischen dem Wert eines Elements und dem Vorhandensein eines anderen Elements mit der XSD 1.0 Spezifikation nicht beschreibbar ist, müssen unabhängig vom Objekttyp (bzw. für jeden Wert von „object“) alle möglichen Kindelemente von „child“ zugelassen werden. Dies wird im Abschnitt „Implementierung“ näher erläutert.
Einige Kindelemente von „child“ besitzt jeder Objekttyp wie z.B. „Name“, das den Namen des Objekts als Wert sowie weitere Einstellungen wie z.B. das Zugriffslevel als Attribute enthält. Andere treten nur bei bestimmten Objekttypen auf. Beispielsweise tritt „type“ bei „base“-Objekten (geometrische Formen wie Kreise, Linien, Rechtecke,…) auf, aber nicht bei „Edit“-Objekten (E/A-Felder). „Edit“-Objekte besitzen stattdessen das Element „editbox“, welches einige gleiche Eigenschaften wie „type“ z.B. die x- und y-Position des Objekt, sowie außerdem einige spezielle Eigenschaften dieses Objekttyps, beschreibt.
Einen Spezialfall stellt außerdem das Objekt vom Typ „group“ dar, das eine Gruppierung beliebiger Objekte einschließlich anderer gruppierter Objekte enthalten kann. Der Aufbau dieses „group“-Objekts sieht folgendermaßen aus:

```
<child>
   <object>group</object>
   <childs>
      <child>...</child>
      <child>...</child>
      ...
      <child>...</child>
   </childs>
</child>
```

Die beschriebenen, sowie einige weitere Kindelemente von „child“ sind beispielhaft in Abbildung 2 dargestellt.

Nachdem die Struktur der XML-Datei analysiert wurde, kann darauf aufbauend das XML Schema implementiert werden.

## Dokumentation

Zur Dokumentation der XSD soll - wie bei den Entwurfsvarianten bereits dargestellt - zu jedem Element, Attribut und Typ eine „annotation“ mit der Beschreibung eingefügt werden. Da für alle Einstellungen in Visu+ bereits IDs und englische Beschreibungstexte im Eigenschaftsfenster angegeben sind, bietet es sich an diese zu verwenden. Aufgrund des hohen Aufwands die kompletten Texte abzuschreiben, sollen zunächst nur die IDs der Einstellungen in die XSD geschrieben werden. Später soll automatisch durch ein zu erstellendes python-Script aus der Datei PropVis.xml, die sich unter den Programmdateien von Visu+ befindet und aus der Visu+ selbst die Beschreibungstexte anhand der zugehörigen IDs bezieht, die Texte zu den IDs gesucht und in die XSD eingesetzt werden (siehe Abbildung 3).

Anschließend wird ein XSLT-Stylesheet verwendet um die html-Dokumentation aus der XSD zu generieren (siehe Abbildung 3).

# Werkzeuge

Für die Implementierung wurde ein XSLT-Stylesheet von „xs3p“ [2] verwendet. Um eine XSL-Transformation durchzuführen ist zusätzlich ein XSLT-Prozessor notwendig. Für diesen Zweck wurde „Saxon-HE 9.7“ verwendet. Für die Verwendung von Saxon 9.7 wird mindestens JDK 1.6 benötigt. Zum Ausführen der XSL-Transformation muss die Kommandozeile im Projektordner geöffnet werden und folgender Befehl ausgeführt werden (siehe Saxon Dokumentation [3]):

```
java -jar saxon\saxon9he.jar -s:prozessbild_doc.xsd -xsl:xs3p-1.1.5\xs3p.xsl -o:prozessbild_doc.html
```

Dabei gibt -s die XSD-Datei und -xsl das Stylesheet von xs3p an. Die gewünschte Ausgabedatei (html) unter der Option -o benannt werden.

# Implementierung

## XML Schema

Bei der Implementierung wurde das XML-Schema gemäß dem Entwurf umgesetzt. Es konnten die Objekttypen „base“, „poly“, „Button“, „Edit“, „TabObj“ und „group“ umgesetzt werden.

- Am Anfang der XSD-Datei erfolgt die Definition von Typen. Für Werte, die nicht mit den vordefinierten XSD-Datentypen ausgedrückt werden konnten, wurden Typen definiert, die mit „restriction“, „enumeration“, „pattern“ usw. die zulässigen Werte genau definieren. Auch für Attribute, die Ressourcen wie z.B. eine Variable oder ein Prozessbild angeben, wurden Typen definiert, die zwar beliebige Strings zulassen, aber später evtl. an einer anderen Stelle in einem Programm eine Überprüfung erlauben, ob irgendwo ein z.B. gültiger Variablenname gefordert ist.
- Nach den Typen werden die Attribute, die den Eigenschaften und Einstellungen in Visu+ entsprechen, definiert. Diese sind soweit möglich in der selben Reihenfolge sortiert und durch entsprechende Kommentare voneinander abgetrennt, wie im Eigenschaftsfenster in Visu+.
- Danach werden die Elemente definiert, wobei sich ganz unten in der Datei das Wurzelement befindet, dessen Kindelemente darüber usw.. Auf die Elemente und Attribute wird jeweils mit einer Referenz „ref“ verwiesen. Überall, wo diese nicht mit den Default-Werten übereinstimmen, wurden die Eigenschaften „maxOccurs“ und „minOccurs“ festgelegt.
- Entsprechend der Erläuterungen im Abschnitt „Entwurf“ wurde jedem Element, Attribut und Typ ein Dokumentationstext hinzugefügt, wobei bei allen Einstellungen, die in Visu+ eine ID besitzen, diese eingetragen wurde. Bei den Übrigen wurde ein eigener Dokumentationstext auf Englisch hinzugefügt.

Bei der Erstellung der XSD ergaben sich auch einige Probleme, die im Folgenden näher erläutert werden.

- Die in einer „group“ gruppierten Objekte, die als Kindelemente von „childs“ angegeben werden, besitzen anstelle des Elements „object“ ein Element „type“ zur Angabe des Objecttyps. Dadurch besitzt beispielsweise ein „base“-Objekt, das sich in einer „group“ befindet, zwei unterschiedliche Elemente „type“ als Kindelemente von „child“. Da durch „xs:all2 die Eigenschaft „maxOccurs“ auf maximal 1 beschränkt ist, muss eine „xs:sequence“ für die Kindelemente von „child“ verwendet werden. Dies erzeugt wiederum Probleme, da bei verschiedenen Objekttypen die Reihenfolge von gleichen Elementen vertauscht ist. Da Visu+ zwar die Elemente immer in einer bestimmten Reihenfolge abspeichert, aber auch XML-Code annimmt, bei dem die Elemente vertauscht sind, ist der Import von Dateien, die dieser XSD entsprechen möglich.
- Es gibt Attribute in der von Visu+ erstellten XML-Datei, deren Namen mit einer Zahl beginnt z.B. „3DRoundLevel“. Dies ist laut XML Spezifikation nicht zulässig, weswegen diese Attribute nicht in die XSD aufgenommen wurden und deren Verwendung nicht zulässig ist.
- Einige Attribute, für die ganzzahlige Werte zulässig sind, werden von Visu+ ab 1000000 in Exponentialdarstellung (1,0e+06) in die XML-Datei geschrieben. Die Exponentialdarstellung könnte zwar durch den Datentyp „xs:float“ zugelassen werden, müsste dann allerdings wieder auf Ganzzahlen beschränkt werden. Außerdem wird in der Exponentialdarstellung ein Punkt statt eines Kommas - wie von Visu+ verwendet - erwartet. Daher wurden nur Zahlen zwischen -999999 und 999999 zugelassen, was für die betroffenen Attribute einen ausreichenden Wertebereich darstellt.
- Visu+ setzt bei einigen Elementen, bei denen beliebig viele Ressourcen angegeben werden können, diese Ressourcen als Attribute n0, n1, n2, usw. des Elements. Da in der XSD jedes Attribut definiert werden muss, konnte nur eine begrenzte Anzahl implementiert werden. Diese Anzahl umfasst momentan die Attribute bis n299 und kann bei Bedarf erweitert werden. Beispielsweise das Element „Screens“ kann einen Auflistung von beliebig vielen Prozessbildern enthalten, die folgendermaßen angegeben werden:

```
<Screens n0="Prozessbild1.visscr" n1="Prozessbild2.visscr" ... />
```

## Python Script zum Ersetzen der IDs

Nach der Fertigstellung der XSD wird das python-Script „replaceID.py“ geschrieben. Dieses liest die XSD-Datei „prozessbild.xsd“ ein, sucht nach den IDs, sucht diese in der Datei „PropVis.xml“, entnimmt dort den zugehörigen Dokumentationstext einschließlich der ID am Ende des Textes und ersetzt die ID in der XSD durch den Text. Die resultierende XSD-Datei wird als „prozessbild\_doc.xsd“ abgespeichert. Das Script kann jederzeit wieder ausgeführt werden, es müssen sich nur die beiden Quelldateien mit den Namen „prozessbild.xsd“ und „PropVis.xml“ im selben Ordner wie das Script befinden.

## XSL-Transformation

Wie im Abschnitt „Werkzeuge“ bereits erläutert, wird für die Erzeugung der html-Dokumentation das Stylesheet von xs3p, sowie der XSLT-Prozessor von Saxon verwendet. Durch Ausführen der Transformation mittels des Prozessors über die Kommandozeile wird die Datei „prozessbild_doc.html“ erzeugt. In der Dokumentation sind alle Elemente, Attribute und Typen verlinkt. Ein Beipiel eines Elements ist in Abbildung 5 zu sehen.

# Diskussion der Ergebnisse

Wie im Abschnitt „Implementierung“ bereits erläutert, gab es Probleme bei der Abbildung der XML-Datei, die von Visu+ erzeugt wird, in ein passendes XML-Schema. Deshalb beschränkt die XSD an einigen Stellen die Möglichkeiten von Visu+ (Beipiele: Wertebereich der Attribute über +-999999, Wegglassen von Attributen, deren Namen mit Zahlen beginnen). Daher können von Visu+ erzeugte XML-Dateien teilweise nicht als korrekt validiert werden. Andersherum nimmt Visu+ sehr großzügig Elemente an Stellen an, an denen diese eigentlich nicht sein sollten und löscht diese einfach automatisch weg, statt die gesamte Datei nicht anzunehmen. Daher stellt die fehlende Restriktion bei den Kindelementen von „child“ kein Problem beim Import von XML-Dateien dar. Auch die Sortierung dieser Kindelemente ist zwar in Visu+ immer gleich (sequenz), jedoch sortiert Visu+ auch hier Elemente, die in einer anderen Reihenfolge importiert wurden, einfach um. Dadurch kann es allerdings passieren, dass nach dem Öffnen einer Datei in Visu+ und erneutem Abspeichern, bei dem Visu+ einige Elemente umsortiert, diese nicht mehr mit der XSD validierbar ist.

Insgesamt führt dies dazu, dass Anforderung Q1 nicht erfüllt werden konnte, da nicht alle in Visu+ erstellten XML-Datei korrekt validieren. Dennoch ist Anforderung Q2 erfüllt. Das bedeutet, dass Visu+ Dateien, die mit der XSD validiert wurden annimmt und als Prozessbild darstellt. Somit ist die Vorraussetzung für die Verwendung der XSD im Rahmen der modellgetriebene HMI-Generierung gegeben.

Die übrigen Anforderung sind ebenfalls erfüllt, d.h. die Objekttypen “base”, “poly”, “Button”, “TabObj” und “group” wurden beschrieben. Es wurde ein übersichtliche, ausführliche Dokumentation erstellt, aus der die Wertebereiche und Funktionen aller Elemente und Attribute ersichtlich sind. Die XSD ist in Eclipse mit dem Plugin xsd2ecore lauffähig und validierbar.

# Quellennachweis und Literaturverzeichnis

[1] W3C Recommendation: W3C XML Schema Definition Language (XSD) 1.1 Part 1: Structures, 05. April 2012, URL:[http://www.w3.org/TR/2012/REC-xmlschema11-1-20120405/](http://www.w3.org/TR/2012/REC-xmlschema11-1-20120405/ "http://www.w3.org/TR/2012/REC-xmlschema11-1-20120405/") (Stand: 10.01.2016).</br>
[2] xs3p Website, URL:[http://xml.fiforms.org/xs3p/](http://xml.fiforms.org/xs3p/ "http://xml.fiforms.org/xs3p/") (Stand: 10.01.2016)</br>
[3] Saxon 9.7 Dokumentation, URL:[http://www.saxonica.com/documentation/\#!using-xsl](http://www.saxonica.com/documentation/#!using-xsl "http://www.saxonica.com/documentation/#!using-xsl")

# Lizenzen der verwendeten Software

Saxon-HE - Version 9.6

1.  Ist eine Einzellizenz für das verwendete Medium vorhanden: ja
2.  Handelt es sich um eine standardisierte Lizenz: ja, Mozilla Public License Version 2.0
3.  Ist eine kommerzielle Verwendung erlaubt: ja
4.  Müssen Autor und/oder Quelle im oder bei dem Medium oder in einem Verzeichnis genannt werden: ja
5.  Ist eine Veränderung des Mediums erlaubt: ja
    1.  wenn ja, muss die veränderte Version unter derselben Lizenz wieder veröffentlicht werden: ja

xs3p - Version 1.1.5

1.  Ist eine Einzellizenz für das verwendete Medium vorhanden: ja
2.  Handelt es sich um eine standardisierte Lizenz: DSTC Public License (DPL), Lizenztext im Anhang
3.  Ist eine kommerzielle Verwendung erlaubt: ja
4.  Müssen Autor und/oder Quelle im oder bei dem Medium oder in einem Verzeichnis genannt werden: ja
    1.  wenn ja wie? In jeder Datei muss der Text aus Anhang A der Lizenzvereinbarung eingefügt werden, die Lizenzvereinbarung selbst muss eingefügt werden

5.  Ist eine Veränderung des Mediums erlaubt: ja
    1.  wenn ja, muss die veränderte Version unter derselben Lizenz wieder veröffentlicht werden: ja, und Veränderungen müssen dokumentiert werden

# Anhang

- Quellcode: [xsd4visu.zip](/lib/exe/fetch.php?media=protele:example_documentation:xsd4visu.zip "protele:example_documentation:xsd4visu.zip")
- Präsentation: [abschlusspraesentation.pptx](/lib/exe/fetch.php?media=protele:example_documentation:abschlusspraesentation.pptx "protele:example_documentation:abschlusspraesentation.pptx")
- Lizenztexte:
    - DSTC Public License (für xs3p) siehe Quellcodeordner /xs3p-1.1.5/LICENSE.html
    - Mozilla Public License version 2.0 siehe Quellcodeordner /saxon/notices/LICENSE.txt
