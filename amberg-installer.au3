; Function to wait for specific text in the active window and click a control
Func WaitForTextAndClick($windowTitle, $targetText, $timeout, $controlInstance)
    ConsoleWrite($windowTitle & @CRLF)
    For $i = 1 To $timeout
        If StringInStr(WinGetText($windowTitle), $targetText) > 0 Then
            ConsoleWrite("in func waiting ")
            ControlClick($windowTitle, "", $controlInstance)
            Return True
        EndIf
        Sleep(1000) ; Wait 1 second before checking again
    Next
    Return False
EndFunc

; Function to select language from dropdown
Func SelectLanguage($windowTitle, $language)
    Local $dropdownControl = "[CLASS:ComboBox; INSTANCE:1]"
    ControlCommand($windowTitle, "", $dropdownControl, "SelectString", $language)
    Sleep(1000)
EndFunc

; Create a Scripting.Dictionary object for storing language translations
Global $languageStrings = ObjCreate("Scripting.Dictionary")

; Map of short codes to full language names and titles
Global $languageMap = ObjCreate("Scripting.Dictionary")
$languageMap.Add("en", "English (United States)")
$languageMap.Add("fr", "Français (France)")
$languageMap.Add("de", "Deutsch (Deutschland)")
$languageMap.Add("it", "Italiano (Italia)")
$languageMap.Add("es", "Español (España)")
$languageMap.Add("cs", "Čeština (Česko)")

; English translations
Global $enStrings = ObjCreate("Scripting.Dictionary")
$enStrings.Add("welcome", "Welcome to the Prerequisites Setup Wizard")
$enStrings.Add("select_prerequisites", "Select prerequisites to be installed")
$enStrings.Add("license_agreement", "I agree to the License terms and conditions.")
$enStrings.Add("finish", "Finish")

; French translations
Global $frStrings = ObjCreate("Scripting.Dictionary")
$frStrings.Add("welcome", "Bienvenue dans l'Assistant de Configuration des prérequis")
$frStrings.Add("select_prerequisites", "Sélectionnez les prérequis à installer")
$frStrings.Add("license_agreement", "J'accepte les termes et conditions de la licence.")
$frStrings.Add("finish", "Terminer")

; German translations
Global $deStrings = ObjCreate("Scripting.Dictionary")
$deStrings.Add("welcome", "Willkommen bei den Voraussetzungen Setup Assistent")
$deStrings.Add("select_prerequisites", "Wählen Sie die erforderlichen Komponenten für die Installation")
$deStrings.Add("license_agreement", "Ich akzeptiere die Lizenzbedingungen.")
$deStrings.Add("finish", "Fertigstellen")

; Italian translations
Global $itStrings = ObjCreate("Scripting.Dictionary")
$itStrings.Add("welcome", "Benvenuti a Installazione Guidata Prerequisiti")
$itStrings.Add("select_prerequisites", "Selezionare prerequisiti per l'installazione")
$itStrings.Add("license_agreement", "Accetto i termini e le condizioni della Licenza.")
$itStrings.Add("finish", "Termina")

; Spanish translations
Global $esStrings = ObjCreate("Scripting.Dictionary")
$esStrings.Add("welcome", "Bienvenido al Asistente de instalación de requisitos previos")
$esStrings.Add("select_prerequisites", "Seleccione prerequisitos para ser instalados")
$esStrings.Add("license_agreement", "Estoy de acuerdo con los términos de licencia y condiciones.")
$esStrings.Add("finish", "Finalizar")

; Czech translations
Global $csStrings = ObjCreate("Scripting.Dictionary")
$csStrings.Add("welcome", "Průvodce Prerekvizitami")
$csStrings.Add("select_prerequisites", "Vyberte prerekvizity, které budou nainstalovány")
$csStrings.Add("license_agreement", "Souhlasím s licenčními podmínkami.")
$csStrings.Add("finish", "Dokončit")

; Add language dictionaries to the main dictionary
$languageStrings.Add("en", $enStrings)
$languageStrings.Add("fr", $frStrings)
$languageStrings.Add("de", $deStrings)
$languageStrings.Add("it", $itStrings)
$languageStrings.Add("es", $esStrings)
$languageStrings.Add("cs", $csStrings)

; Set the selected language based on user input, for example, "en", "fr", "de", etc.
Global $selectedLanguage = $CmdLine[1] ; Change this to the appropriate language code
; Access the full name and title directly using the short form
Global $fullLanguageName = $languageMap.Item($selectedLanguage)
Opt("WinTitleMatchMode", 2)
Global $windowTitle = "Amberg Track Pro"
; Run the installer
Run("AmbergTrackProOffice_1.4.11.203.exe")
Sleep(5000) ; Wait for installer window

; Wait for the first installer window
If WinWaitActive($windowTitle, "", 60) Then
    ConsoleWrite("hi")
    SelectLanguage($windowTitle, $fullLanguageName)
    Sleep(2000)
    ControlClick($windowTitle, "", "[CLASS:AI_DirectUIWindow; INSTANCE:2]") ; Click first "Next" button
    Sleep(2000)

    ; Step 1: Welcome screen
    If Not WaitForTextAndClick($windowTitle, $languageStrings.Item($selectedLanguage).Item("welcome"), 60, "[CLASS:AI_DirectUIWindow; INSTANCE:2]") Then
        ConsoleWrite("The Prerequisites Setup Wizard text did not appear." & @CRLF)
        Exit
    EndIf
    Sleep(2000)

    ; Step 2: Select prerequisites
    If Not WaitForTextAndClick($windowTitle, $languageStrings.Item($selectedLanguage).Item("select_prerequisites"), 60, "[CLASS:AI_DirectUIWindow; INSTANCE:3]") Then
        ConsoleWrite("The 'Select prerequisites to be installed' text did not appear." & @CRLF)
        Exit
    EndIf
    Sleep(2000)

    ; Step 3: License agreement
    If Not WaitForTextAndClick($windowTitle, $languageStrings.Item($selectedLanguage).Item("license_agreement"), 180, "[CLASS:AI_DirectUIWindow; INSTANCE:3]") Then
        ConsoleWrite("The 'License agreement' text did not appear." & @CRLF)
        Exit
    EndIf
    Sleep(1000)
    ControlClick($windowTitle, "", "[CLASS:AI_DirectUIWindow; INSTANCE:4]")

    ; Step 4: Finish screen
    If Not WaitForTextAndClick($windowTitle, $languageStrings.Item($selectedLanguage).Item("finish"), 420, "[CLASS:AI_DirectUIWindow; INSTANCE:4]") Then
        ConsoleWrite("The 'Finish' text did not appear." & @CRLF)
        Exit
    EndIf
    Sleep(500)

Else
    ConsoleWrite("Installer window did not appear." & @CRLF)
EndIf

; Final step: Close the installer
If WinWait("Amberg Track Pro Office", "", 60) Then
    WinActivate("Amberg Track Pro Office")
    ControlClick(WinGetTitle(""), "", "[CLASS:Button; INSTANCE:1]")
Else
    ConsoleWrite("Final window did not appear." & @CRLF)
EndIf
