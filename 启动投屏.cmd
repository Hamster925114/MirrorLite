<<<<<<< HEAD
﻿@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title MirrorLite 安卓 USB 投屏（演示版）

echo ============================================================
echo   MirrorLite  -  安卓 USB 投屏（演示版）
echo ============================================================
echo.

if not exist "%~dp0mirror.exe" (
  echo [错误] 找不到 mirror.exe，请把本文件放在演示包目录里运行。
  pause
  exit /b 1
)
if not exist "%~dp0adb.exe" (
  echo [错误] 找不到 adb.exe，演示包需要保持完整，不要单独拷贝 mirror.exe。
  pause
  exit /b 1
)

echo 正在检查设备...
"%~dp0adb.exe" devices 2>nul | findstr /r /c:"device$" >nul
if errorlevel 1 (
  echo.
  echo [没有检测到已授权的安卓设备]
  echo   1. 用 USB 数据线连接手机（不是只能充电的线）
  echo   2. 手机设置里打开「开发者选项」-「USB 调试」
  echo   3. 手机弹出「允许 USB 调试吗」时点「允许」
  echo   4. 小米/OPPO/vivo 还要打开「USB 调试（安全设置）」
  echo.
  echo 改好后重新双击本文件。
  pause
  exit /b 1
)

echo 设备已就绪，正在启动投屏窗口...
echo 提示：窗口里可以直接用鼠标点击、拖动、滚轮操作手机。
echo       F11 全屏，F1 显示/隐藏左上角信息，Esc 退出。
echo.
mirror.exe --launch
set "CODE=%ERRORLEVEL%"
if not "%CODE%"=="0" (
  echo.
  echo [投屏已退出，退出码 %CODE%]
  echo 如果窗口里提示连接失败，多半是手机锁屏了：点亮屏幕后重新双击本文件。
  pause
)
=======
﻿@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title MirrorLite 安卓 USB 投屏（演示版）

echo ============================================================
echo   MirrorLite  -  安卓 USB 投屏（演示版）
echo ============================================================
echo.

if not exist "%~dp0mirror.exe" (
  echo [错误] 找不到 mirror.exe，请把本文件放在演示包目录里运行。
  pause
  exit /b 1
)
if not exist "%~dp0adb.exe" (
  echo [错误] 找不到 adb.exe，演示包需要保持完整，不要单独拷贝 mirror.exe。
  pause
  exit /b 1
)

echo 正在检查设备...
"%~dp0adb.exe" devices 2>nul | findstr /r /c:"device$" >nul
if errorlevel 1 (
  echo.
  echo [没有检测到已授权的安卓设备]
  echo   1. 用 USB 数据线连接手机（不是只能充电的线）
  echo   2. 手机设置里打开「开发者选项」-「USB 调试」
  echo   3. 手机弹出「允许 USB 调试吗」时点「允许」
  echo   4. 小米/OPPO/vivo 还要打开「USB 调试（安全设置）」
  echo.
  echo 改好后重新双击本文件。
  pause
  exit /b 1
)

echo 设备已就绪，正在启动投屏窗口...
echo 提示：窗口里可以直接用鼠标点击、拖动、滚轮操作手机。
echo       F11 全屏，F1 显示/隐藏左上角信息，Esc 退出。
echo.
mirror.exe --launch
set "CODE=%ERRORLEVEL%"
if not "%CODE%"=="0" (
  echo.
  echo [投屏已退出，退出码 %CODE%]
  echo 如果窗口里提示连接失败，多半是手机锁屏了：点亮屏幕后重新双击本文件。
  pause
)
>>>>>>> 204ad6a (The Test Version)
endlocal