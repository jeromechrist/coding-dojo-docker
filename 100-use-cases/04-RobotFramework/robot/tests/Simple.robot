*** Settings ***
Force Tags        Simple
Documentation     A test suite with tests for valid test
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Library           String
Resource          Keywords/resource.robot


*** Test Cases ***
View Main Page
    Open Browser To Main Page
    Main Page Should Be Open
    Welcome Page Should Be Open
    [Teardown]    Close Browser


View About Page
    Open Browser To Main Page
    Main Page Should Be Open
    Welcome Page Should Be Open
    Click On About Link
    [Teardown]    Close Browser