*** Settings ***
Variables                 ${EXECDIR}/src/suite/Properties/properties.py  #${EXECDIR}/src/suite/  #../
Library                   ${EXECDIR}/src/suite/Libraries/Library.py
Library                   ${EXECDIR}/src/suite/Libraries/Browser.py
Library                   SeleniumLibrary
Library                   OperatingSystem
Library                   Collections
Library                   DateTime
Library                   BuiltIn
Library                   String

*** Variables ***
# Directories
${dir_Files}              ${EXECDIR}${/}src${/}suite${/}Files${/}
${dir_PO}                 ${EXECDIR}${/}src${/}suite${/}PageObjects${/}
${dir_properties}         ${EXECDIR}${/}src${/}suite${/}Properties${/}
${dir_Downloads}          ${EXECDIR}${/}src${/}suite${/}Downloads${/}
${dir_reports}            ${EXECDIR}${/}target${/}site${/}
# Page Objects
${dir_Global}             ${dir_PO}Global.robot
${dir_Example}            ${dir_PO}Example.robot
# Properties
${file_properties}        ${dir_properties}properties.py

*** Keywords ***
Browser Open
    ${dir_report}         Get Report Directory
    Run Keyword If       '${properties.navigator}' == 'Chrome' and '${properties.headless}' == 'True'    Open Chrome Headless
    Run Keyword If       '${properties.navigator}' == 'Chrome' and '${properties.headless}' == 'False'   Open Chrome Standard
    Run Keyword If       '${properties.navigator}' == 'Firefox' and '${properties.headless}' == 'True'   Open Firefox Headless
    Run Keyword If       '${properties.navigator}' == 'Firefox' and '${properties.headless}' == 'False'  Open Firefox Standard

Open Chrome Standard
    ${options}            Get Options chrome  ${dir_Downloads}
    Create Webdriver      Chrome  chrome_options=${options}
    Maximize Browser Window

Open Chrome Headless
    ${options}            Get Options headlesschrome  ${dir_Downloads}
    Create Webdriver      Chrome  chrome_options=${options}
    Set Window Size       1920  1080
    Enable Downloads

Open Firefox Standard
    ${options}            Get Options firefox  ${dir_Downloads}
    Create Webdriver      Firefox  firefox_options=${options}
    Maximize Browser Window

Open Firefox Headless
    ${options}            Get Options headlessfirefox  ${dir_Downloads}
    Create Webdriver      Firefox  firefox_options=${options}
    Set Window Size       1920  1080

Enable Downloads          # Only to Headless Chrome
    ${SeleniumLib}        Get Library Instance  SeleniumLibrary
    ${webdriver}          Call Method   ${SeleniumLib}  _current_browser
    Enable Download In Headless Chrome  ${webdriver}    ${dir_Downloads}

Get Report Directory
    ${allDir}             List Directories In Directory  ${EXECDIR}${/}target${/}site${/}
    ${totalDir}           Count Directories In Directory  ${EXECDIR}${/}target${/}site${/}
    ${totalDir}           Evaluate  ${totalDir} -1
    ${lastDir}            Get From List  ${allDir}  ${totalDir}
    ${lastDir}            Remove Whitespace  ${lastDir}
    [Return]              ${dir_reports}${lastDir}${/}

Fail If Previous Test Failed
    Run Keyword If              '${PREV_TEST_STATUS}' == 'FAIL'  Fail  Skipping test because '${PREV_TEST_NAME}' failed.

Take Screenshot
    [Arguments]                  ${screenshotName}
    ${screenshotName}            Get Screenshot Name  ${screenshotName}
    Capture Page Screenshot      ${screenshotName}

Take Screenshot on Error
    ${testCaseName}              Get Variable Value  ${TEST NAME}
    Run Keyword If Test Failed   Take Screenshot     ${testCaseName}

Get Screenshot Name
    [Arguments]                  ${screenshotName}
    ${projectName}               Get Title
    ${projectNameSize}           Get Length     ${projectName}
    ${projectNameSize}           Evaluate       ${projectNameSize} + 1
    ${suiteName}                 BuiltIn.Get Variable Value  ${SUITE NAME}
    ${suiteNameSize}             Get Length     ${suiteName}
    ${suiteName}                 Get Substring  ${suiteName}  ${projectNameSize}  ${suiteNameSize}
    ${suiteName}                 Evaluate       '${suiteName}'.replace(' ','_')
    ${testCaseName}              Get Variable Value  ${TEST NAME}
    ${dirScreenshot}             Get Report Directory
    ${completeDirectory}         Set Variable  ${dirScreenshot}${/}screenshots${/}${suiteName}${/}${testCaseName}
    ${exists}  	                 Run Keyword And Return Status	Directory Should Exist  ${completeDirectory}
    Run Keyword If              '${exists}' == 'False'          Create Directory        ${completeDirectory}
    Run Keyword If              '${exists}' == 'False'          Set Global Variable     ${screenshotNumber}  1
    Directory Should Exist       ${completeDirectory}
    Get Screenshot Number        ${completeDirectory}
    ${screenshotNumber}          Fill Zero Left  ${screenshotNumber}  3
    ${nameOfScreenshot}          Set Variable    ${completeDirectory}${/}${screenshotNumber}
    ${nameOfScreenshot}          Catenate        ${nameOfScreenshot}  ${screenshotName}.png
    ${nameOfScreenshot}          Evaluate       '${nameOfScreenshot}'.replace('//','/')
    [Return]                     ${nameOfScreenshot}

Get Screenshot Number
    [Arguments]                  ${completeDirectory}
    ${qtdFiles}                  Count Files In Directory  ${completeDirectory}
    ${qtdFiles}                  Evaluate  ${qtdFiles} + 1
    Set Global Variable          ${screenshotNumber}  ${qtdFiles}

Fill Zero Left
    [Arguments]          ${numero}  ${qtdCasas}
    ${numero}            Convert To String  ${numero}
    ${qtdAtual}          Get Length  ${numero}
    ${diff}              Evaluate  ${qtdCasas} - ${qtdAtual}
    :FOR    ${diff}      IN RANGE    ${qtdCasas}
    \  Exit For Loop If  ${qtdAtual} == ${qtdCasas}
    \  ${numero}         Set Variable  0${numero}
    \  ${qtdAtual}       Evaluate  ${qtdAtual} + 1
    [Return]             ${numero}

Clear Folder Downloads
    ${exists}                  Run Keyword and Return Status  Directory Should Exist  ${dir_Downloads}
    Run Keyword If            '${exists}' == 'False'  Create Directory  ${dir_Downloads}
    Empty Directory            ${dir_Downloads}
    Directory Should Be Empty  ${dir_Downloads}

Check File Downloaded
    ${status}                  Run Keyword and Return Status  Directory Should Not Be Empty  ${dir_Downloads}
    Run Keyword If            '${status}' == 'False'  Fail  ERROR! The directory '${dir_Downloads}' is empty.
    ${fileName}                List Files In Directory  ${dir_Downloads}
    ${fileName}  	           Get From List  ${fileName}  0
    File Should Not Be Empty   ${dir_Downloads}/${fileName}
    [Return]                   ${fileName}