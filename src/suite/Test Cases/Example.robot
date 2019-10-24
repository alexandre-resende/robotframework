*** Settings ***
Suite Setup                           Browser Open
Suite Teardown                        Close Browser
Test Teardown                         Take Screenshot on Error
Resource                              ${EXECDIR}/src/suite/PageObjects/Global.robot
Resource                              ${dir_Example}/

# mvn robotframework:run "-Dsuites=Example"
*** Test Case ***
TC001 Login as User
    [Tags]  Example
    [Documentation]  Open Google Page
    [Timeout]  5 minutes
    Open Google Page
    Search Google  Screenshot Name

TC002 Fail Test
    [Tags]  Example
    [Documentation]  Fail Test
    Fail  Test Case Failed

TC003 Conditional Test Case - Pass
    [Tags]  Example
    [Documentation]  Conditional Test Case - Fail
    Fail If Previous Test Failed
    Log To Console  This test case will fail and not print this message

TC004 Pass Test
    [Tags]  Example
    [Documentation]  Pass Test
    Print Title

TC005 Conditional Test Case - Pass
    [Tags]  Example
    [Documentation]  Conditional Test Case - Pass
    Fail If Previous Test Failed
    Log To Console  This test case will pass

TC006 Download File
    [Tags]  Example
    [Documentation]  Download File
    Open Page Download
    Clear Folder Downloads
    Download File
    Print Name File Downloaded

TC007 Test Case Stopped
    [Tags]  Example
    [Documentation]  Test Case Stopped
    Fatal Error  Test Case Stopped
    Log To Console  Stop before this message

TC008 Test Not Performed
    [Tags]  Example
    [Documentation]  Test Not Performed
    Log To Console  Execution stopped by a fatal error