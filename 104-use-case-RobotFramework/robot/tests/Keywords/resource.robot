*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           Selenium2Library


*** Variables ***
${SELENIUM}          http://hub:4444/wd/hub
${PAGE_INDEX}        http://aspnetapp
${WELCOME_INDEX}       ${PAGE_INDEX}/
${PAGE_TITLE}        Home Page - aspnetapp
# ${BROWSER}           Chrome
${DELAY}             0

*** Keywords ***


Open Browser To Main Page
    Open Browser    ${PAGE_INDEX}    browser=${BROWSER}    remote_url=${SELENIUM}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Main Page Should Be Open
    Sleep  1s

Main Page Should Be Open
    Title Should Be    ${PAGE_TITLE}

Welcome Page Should Be Open
    Location Should Be    ${WELCOME_INDEX}

Click On About Link
    Run Keyword And Ignore Error  Click Button  class=btn
    Click Link  xpath=//a[@href="/Home/About"]
    Location Should Be  ${PAGE_INDEX}/Home/About

