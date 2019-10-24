*** Settings ***
Resource            ${dir_Global}/
Variables           ${file_properties}/
Library             BuiltIn
Library             DatabaseLibrary

*** Keywords ***
Connect DB Oracle
    Connect To Database Using Custom Params  jaydebeapi  'oracle.jdbc.driver.OracleDriver', 'jdbc:oracle:thin:@${properties.dbOracle_host}:${properties.dbOracle_port}/${properties.dbOracle_schema}', ['${properties.dbOracle_user}', '${properties.dbOracle_pass}']

Connect DB Postgres
    Connect To Database Using Custom Params  jaydebeapi  'org.postgresql.Driver','jdbc:postgresql://${properties.dbPostgres_host}:${properties.dbPostgres_port}/${properties.dbPostgres_schema}','${properties.dbPostgres_user}','${properties.dbPostgres_pass}'

Disconnect Database
    Disconnect from Database

Search on Database
    [Arguments]             ${db}  ${query}
    Run Keyword If         '${db}' == 'Oracle'    Connect DB Oracle
    Run Keyword If         '${db}' == 'Postgres'  Connect DB Postgres
    ${result}               Query  ${sql}
    Disconnect Database
    [Return]                ${result}

Search on Database - Not Null  # Fail If Result Is Null
    [Arguments]             ${db}  ${query}
    ${result}               Search on Database  ${db}  ${query}
    ${isNull}               Run Keyword And Return Status  Should Not Be Empty  ${result}
    ${messageError}         Set Variable  The query '${sql}' has no result.
    Run Keyword If         '${isNull}' == 'False'  Fail  ${messageError}
    [Return]                ${result}