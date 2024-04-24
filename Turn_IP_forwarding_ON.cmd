@echo off
chcp 65001 >nul

:: Sett på IP forwarding i registeret for server slik at OpenVPN klienter kan pinge LAN.
reg add HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v IPEnableRouter /D 1 /f

:: RRAS må også startes.
sc config RemoteAccess start= auto
sc start RemoteAccess
timeout /t 5 /nobreak
sc query RemoteAccess

echo.
echo Hvis tjenesten kjører OK, er du ferdig.
echo.
pause