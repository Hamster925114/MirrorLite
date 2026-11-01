@echo off
setlocal
cd /d "%~dp0"
title MirrorLite 1.0 安卓 USB 投屏

echo ============================================================
echo   MirrorLite 1.0  -  安卓 USB 投屏
echo ============================================================
echo.

if not exist "%~dp0mirror.exe" goto :noexe
if not exist "%~dp0adb.exe" goto :noadb

rem adb 会把日志写到 %%TEMP%%\adb.log。那个文件一旦不可写（被管理员或别的账户
rem 创建过、ACL 坏了），adb 连守护进程都起不来，报 cannot open ... Permission denied。
rem 所以这里把 TEMP/TMP 指到包内的可写目录，adb 和它拉起的 daemon 都继承这个设置。
if not exist "%~dp0adb-tmp" mkdir "%~dp0adb-tmp"
set "TMP=%~dp0adb-tmp"
set "TEMP=%~dp0adb-tmp"

"%~dp0adb.exe" version >nul 2>&1
if errorlevel 1 goto :adb_broken

rem 守护进程交给控制台程序来拉，比在 GUI 进程里拉更稳。
"%~dp0adb.exe" start-server >nul 2>&1

set /a tries=0

:retry
"%~dp0adb.exe" devices 2>nul | findstr /r /c:"device$" >nul
if not errorlevel 1 goto :start
set /a tries+=1
if %tries% geq 12 goto :nodevice
echo 正在等待设备就绪...（第 %tries% 次重试）
"%~dp0adb.exe" start-server >nul 2>&1
ping -n 2 127.0.0.1 >nul
goto :retry

:start
echo 设备已就绪，正在启动投屏窗口...
echo 提示：窗口里可以直接用鼠标点击、拖动、滚轮操作手机。
echo       F11 全屏，F1 显示/隐藏左上角信息，Esc 退出。
echo.
rem mirror.exe 是 GUI 程序，直接调用 cmd 不会等待，脚本一结束控制台就关，
rem 进程会被一起带走（表现为双击后一闪而过）。用 start /wait 让它等到底。
start "" /wait "%~dp0mirror.exe" --launch
echo.
echo 投屏已退出（退出码 %ERRORLEVEL%）。
echo 如果窗口里提示连接失败，多半是手机锁屏了：点亮屏幕后重新双击本文件。
goto :end

:nodevice
"%~dp0adb.exe" devices -l > "%~dp0诊断信息.txt" 2>&1
echo.
echo [没有检测到已授权的安卓设备]
echo.
echo 下面是 adb 现在看到的东西（也存进了 诊断信息.txt）：
echo ------------------------------------------------------------
type "%~dp0诊断信息.txt"
echo ------------------------------------------------------------
echo.
findstr /i /c:"unauthorized" "%~dp0诊断信息.txt" >nul
if not errorlevel 1 goto :hint_unauth
findstr /i /c:"offline" "%~dp0诊断信息.txt" >nul
if not errorlevel 1 goto :hint_offline
findstr /i /c:"Permission denied" "%~dp0诊断信息.txt" >nul
if not errorlevel 1 goto :hint_permdenied
findstr /i /c:"failed to start daemon" "%~dp0诊断信息.txt" >nul
if not errorlevel 1 goto :hint_daemon
findstr /i /c:"no permissions" "%~dp0诊断信息.txt" >nul
if not errorlevel 1 goto :hint_perm
goto :hint_empty

:hint_unauth
echo 原因：手机还没授权这台电脑。
echo   看手机屏幕，点「允许 USB 调试」（勾上「一律允许」更省事）。
echo   如果手机没弹窗：开发者选项里点一下「撤销 USB 调试授权」，再重新插线。
goto :end

:hint_offline
echo 原因：设备显示 offline，通常是 adb 状态卡住了。
echo   重新插一次数据线，或者重启手机的「USB 调试」开关。
goto :end

:hint_permdenied
echo 原因：adb 无法写日志文件，守护进程起不来（就是这条 Permission denied）。
echo   本脚本已经把 TEMP 指到包内目录，如果还报错，说明包放在只读位置，
echo   请把整个文件夹拷到桌面或 D 盘再运行。
goto :end

:hint_daemon
echo 原因：adb 守护进程起不来，常见是 5037 端口被别的 adb/手机助手占用。
echo   关掉手机助手、其它投屏软件后重试；还不行就重启电脑。
goto :end

:hint_perm
echo 原因：Windows 没有拿到 USB 设备权限。
echo   换一个 USB 口（优先主板后置口），或换一根数据线试试。
goto :end

:hint_empty
echo 原因：adb 完全没看到手机。按顺序检查：
echo   1. 数据线是不是只能充电的线（换一根能传文件的）
echo   2. 手机「开发者选项」-「USB 调试」是否打开
echo   3. 插线后手机通知栏的 USB 用途选「传输文件 / MTP」
echo   4. 关掉手机助手、其它投屏软件（它们会抢占 adb）
echo   5. 小米/OPPO/vivo 还要打开「USB 调试（安全设置）」
goto :end

:noexe
echo [错误] 找不到 mirror.exe，请把本文件放在程序目录里运行。
goto :end

:noadb
echo [错误] 找不到 adb.exe，程序需要保持目录完整，不要单独拷贝 mirror.exe。
goto :end

:adb_broken
echo [错误] adb.exe 无法运行。
echo   多半是压缩包没解压完整：请把整个 zip 解压到一个普通文件夹再双击，
echo   不要直接在压缩包里双击运行。
goto :end

:end
echo.
pause
endlocal