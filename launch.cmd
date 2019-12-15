@echo off
rem edited By G7JTT May 2019 / Evolution 
rem Feb 2019 by Evariste F5OEO - QO-100 Release 0.9 (Completely rewritten)
rem Started from original tool
rem Idea from Portsdown OBS, vmix ffmpeg script
rem Bitrate calculator : http://www.satbroadcasts.com/DVB-S_Bitrate_and_Bandwidth_Calculator.html
rem ================= SETUP ONCE ===========

set callsign=MY0CALL
rem Set appropriately
set raspi_ip=230.0.0.10
rem set raspi_ip=192.168.1.26
set ip=%raspi_ip%:10000

cls
color 1F

echo  ----------------------------------------------------
echo ^|------------------   DVBS2 QPSK   ------------------^|
echo ^|----------------------------------------------------^|
echo ^|                                                    ^|
echo ^|  1 : SR125  FEC 3/5    .   13 : SR500  FEC 1/3     ^|
echo ^|  2 : SR125  FEC 5/6    .   14 : SR500  FEC 1/2     ^|
echo ^|  3 : SR250  FEC 3/5    .   15 : SR500  FEC 2/3     ^|
echo ^|  4 : SR250  FEC 5/6    .   16 : SR500  FEC 3/4     ^|
echo ^|  5 : SR250  FEC 8/9    .   17 : SR500  FEC 4/5     ^|
echo ^|  6 : SR333  FEC 1/3    .   18 : SR500  FEC 5/6     ^|
echo ^|  7 : SR333  FEC 1/2    .   19 : SR500  FEC 8/9     ^|
echo ^|  8 : SR333  FEC 2/3    .   20 : SR1000 FEC 1/3     ^|
echo ^|  9 : SR333  FEC 3/4    .   21 : SR1000 FEC 1/2     ^|
echo ^| 10 : SR333  FEC 4/5    .   22 : SR1000 FEC 2/3     ^|
echo ^| 11 : SR333  FEC 5/6    .   23 : SR1000 FEC 3/4     ^|
echo ^| 12 : SR333  FEC 8/9    .   24 : SR1000 FEC 4/5     ^|
echo ^|                        .   25 : SR1000 FEC 5/6     ^|
echo ^|                        .   26 : SR1000 FEC 8/9     ^|
echo ^|                                                    ^|
echo  ----------------------------------------------------
rem echo ^|   ^|
:question
set /p choice=Please, choose your video format (1,2,3,...) :

if /I "%choice%"=="1" (SET TSBITRATE=161300)
if /I "%choice%"=="2" (SET TSBITRATE=224400)
if /I "%choice%"=="3" (SET TSBITRATE=322600)
if /I "%choice%"=="4" (SET TSBITRATE=448900)
if /I "%choice%"=="5" (SET TSBITRATE=478900)
if /I "%choice%"=="6" (SET TSBITRATE=237600)
if /I "%choice%"=="7" (SET TSBITRATE=357700)
if /I "%choice%"=="8" (SET TSBITRATE=477800)
if /I "%choice%"=="9" (SET TSBITRATE=537800)
if /I "%choice%"=="10" (SET TSBITRATE=573900)
if /I "%choice%"=="11" (SET TSBITRATE=597900)
if /I ("%choice%"=="12" (SET TSBITRATE=637900) 

if /I "%choice%"=="13" (SET TSBITRATE=356700)
if /I "%choice%"=="14" (SET TSBITRATE=537000)
if /I "%choice%"=="15" (SET TSBITRATE=717400)
if /I "%choice%"=="16" (SET TSBITRATE=807600)
if /I "%choice%"=="17" (SET TSBITRATE=861700)
if /I "%choice%"=="18" (SET TSBITRATE=897700)
if /I "%choice%"=="19" (SET TSBITRATE=957900)

if /I "%choice%"=="20" (SET TSBITRATE=713400)
if /I "%choice%"=="21" (SET TSBITRATE=533000)
if /I "%choice%"=="22" (SET TSBITRATE=1434800)
if /I "%choice%"=="23" (SET TSBITRATE=1615100)
if /I "%choice%"=="24" (SET TSBITRATE=1723300)
if /I "%choice%"=="25" (SET TSBITRATE=1795500)
if /I "%choice%"=="26" (SET TSBITRATE=1915700)
if /I "%choice%"=="" (goto :question)

rem goto question

set /a videorate = %TSBITRATE% * 6 / 10000

echo  ----------------------------------------------------
echo       [Your choice : %choice%]
echo       Bitrate = Muxrate    =  %TSBITRATE%                
echo                 Video rate =  %videorate% Kbps     
echo  ---------------------------------------------------- 
set res=0
set /p choice2=Ready to kill existing ffmpeg and launch the new one ? (Y/N)
echo       [Your choice : %choice2%]
if /I "%choice2%" == "Y" (set res=1)
if /I "%choice2%" == "y" (set res=1)
if /I %res% NEQ 1 (goto :end )
	taskkill /im ffmpeg.exe
	echo Launching now external ffmpeg. (Please launch/start streaming-record manually OBS)
	start "OBS to udp/ts" /high ^
	C:\ffmpeg\bin\ffmpeg ^
	-i udp://230.0.0.11:20000 -c:v copy -max_delay 1000000 -muxrate %TSBITRATE%  -c:a copy ^
	-f mpegts -mpegts_original_network_id 1 -mpegts_transport_stream_id 1 -mpegts_service_id 1 -mpegts_pmt_start_pid 4096 -streamid 0:256 -streamid 1:257 ^
	-metadata service_provider="QO-100" -metadata service_name=%callsign% ^
	-flush_packets 0 -f mpegts "udp://%ip%:10000?pkt_size=1316&bitrate=%TSBITRATE%"
	)
:end
color 0F
echo.
rem ======================== Launch ffmpeg OBS =========================
