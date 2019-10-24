*** Variables ***
${google_search}     name=q
${urlPageDownload}   https://file-examples.com/index.php/sample-documents-download/sample-doc-download/
${downloadDOC}       //a[contains(text(),'Download sample DOC file')]

*** Keywords ***
Open Google Page
    Go To            https://www.google.com/

Search Google
    [Arguments]      ${screenshotName}
    Input Text       ${google_search}  Google
    Press Keys       None  ENTER
    Take Screenshot  ${screenshotName}

Print Title
    ${url}           Get Title
    Log To Console   ${url}

Open Page Download
    Go To            ${urlPageDownload}

Download File
    Click Element    ${downloadDOC}
    Sleep            5  #Time to download the file

Print Name File Downloaded
    ${name}          Check File Downloaded
    Log To Console   ${name}