call ant
if %errorlevel% neq 0 exit /b %errorlevel%
set testLabels=ulid
set testFilter=
set testAdditional=C:\work\lucee-extensions\extension-ulid\tests
set testServices=mysql

ant -buildfile="C:\work\script-runner" -DluceeVersion="light-6.0.0.391-SNAPSHOT" -Dwebroot="C:\work\lucee6\test" -Dexecute="/bootstrap-tests.cfm" -DextensionDir="C:\work\lucee-extensions\extension-ulid\dist" -DextensionDir="C:\work\lucee-extensions\extension-ulid\dist"