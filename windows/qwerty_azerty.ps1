# Zet toetsenbord taal en layout naar enkel 
# Belgisch Punt AZERTY of
# US Internationaal QWERTY

$toetsenbord = Read-Host -Prompt "Is toetsenbord AZERTY of QWERTY [A/Q]"; 

# Voor als per ongeluk 'A' of 'Q' werd getyped
$toetsenbord = $toetsenbord.ToLower(); 


if ($toetsenbord -eq 'a') { 
  
    # Volgens https://www.reddit.com/r/PowerShell/comments/1ecbt2v/changing_keyboard_layout_programatically_when/
    # Een nieuwe Powershell sessie oproepen moet alleen in een ps1/powershell script/bestand
    # Niet in .bat / batch bestand!!
    $WinPS = New-PSSession -UseWindowsPowerShell
    Invoke-Command -ScriptBlock {
    
        Write-Host "Belgisch punt AZERTY installatie begint nu..." 
        
        $targetLanguageTag = "nl-BE"; 
        $targetLayout = "00000813"; 
        #$languages = Get-WinUserLanguageList;

        # Check dat Belgian (Period) al geinstalleerd is
        $alreadyInstalled = $false
        foreach ($lang in $languages) {
            if ($lang.LanguageTag -eq $targetLanguageTag) {
                if ($lang.InputMethodTips -contains "0409:$targetLayout" -or
                    $lang.InputMethodTips -contains "0813:$targetLayout" -or
                    $lang.InputMethodTips -contains "nl-BE:$targetLayout") {
                    $alreadyInstalled = $true
                }
            }
        }

        if ( $alreadyInstalled) { 
            
            Write-Host "AZERTY all geinstalleerd!"; 
        
        } elseif (! $alreadyInstalled) {
            
            ## Create a new language entry for Belgian (Period)
            #$newLang = New-WinUserLanguageList -Language $targetLanguageTag
            #$newLang[0].InputMethodTips.Add("0409:$targetLayout")

            #$languages.Add($newLang[0])
            #Set-WinUserLanguageList $languages -Force

            $newLangList = New-WinUserLanguageList -Language $targetLanguageTag
        
            $newLangList[0].InputMethodTips.Clear()
            $newLangList[0].InputMethodTips.Add("0409:$targetLayout")

            Set-WinUserLanguageList $newLangList -Force

            Set-WinDefaultInputMethodOverride -InputTip "0409:$targetLayout"
            
            Write-Host "Belgian (Period) AZERTY geïnstalleerd!"
        }
    
    } -Session $WinPS

}elseif($toetsenbord -eq 'q'){

    $WinPS = New-PSSession -UseWindowsPowerShell
    Invoke-Command -ScriptBlock {

        Write-Host "US Internationaal QWERTY installatie begint nu..."

        $targetLanguageTag = "en-US"
        $targetLayout = "00020409"  
        # 0409 = US English, 020409 = US-International

        #$languages = Get-WinUserLanguageList

        $alreadyInstalled = $false
        foreach ($lang in $languages) {
            if ($lang.LanguageTag -eq $targetLanguageTag) {
                if ($lang.InputMethodTips -contains "0409:$targetLayout" -or
                    $lang.InputMethodTips -contains "en-US:$targetLayout") {
                    $alreadyInstalled = $true
                }
            }
        }
        
        if  ( $alreadyInstalled) {
            
            Write-Host "QWERTY all geinstalleerd!"
         
        } elseif (! $alreadyInstalled) {

            #$newLang = New-WinUserLanguageList -Language $targetLanguageTag
            #$newLang[0].InputMethodTips.Clear()
            #$newLang[0].InputMethodTips.Add("0409:$targetLayout")
            #$languages.Add($newLang[0])

            #Set-WinUserLanguageList $languages -Force

            $newLangList = New-WinUserLanguageList -Language $targetLanguageTag

            $newLangList[0].InputMethodTips.Clear()
            $newLangList[0].InputMethodTips.Add("0409:$targetLayout")
            
            Set-WinUserLanguageList $newLangList -Force

            Set-WinDefaultInputMethodOverride -InputTip "0409:$targetLayout"
            
            Write-Host "US Internationaal QWERTY geïnstalleerd!"
        }
       
    
    } -Session $WinPS
}
