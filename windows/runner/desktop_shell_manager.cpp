#include "desktop_shell_manager.h"
#include <iostream>
#include <string>

static void LogDebug(const std::string& msg) {
  std::cout << "[ApexDesktopWidget] " << msg << std::endl;
  OutputDebugStringA(("[ApexDesktopWidget] " + msg + "\n").c_str());
}

HWND DesktopShellManager::GetWorkerWHandle() {
  HWND progman = ::FindWindow(L"Progman", NULL);
  LogDebug("Progman HWND: " + std::to_string((uintptr_t)progman));
  if (!progman) return NULL;

  DWORD_PTR result = 0;
  LRESULT msgResult = ::SendMessageTimeout(progman, 0x052C, 0, 0, SMTO_NORMAL, 1000, &result);
  LogDebug("SendMessageTimeout 0x052C result: " + std::to_string(msgResult));

  HWND workerw = NULL;

  HWND hWorkerW = NULL;
  do {
    hWorkerW = ::FindWindowEx(NULL, hWorkerW, L"WorkerW", NULL);
    if (hWorkerW != NULL) {
      HWND shellDll = ::FindWindowEx(hWorkerW, NULL, L"SHELLDLL_DefView", NULL);
      LogDebug("Found WorkerW: " + std::to_string((uintptr_t)hWorkerW) + ", shellDll: " + std::to_string((uintptr_t)shellDll));
      if (shellDll == NULL) {
        workerw = hWorkerW;
        break;
      }
    }
  } while (hWorkerW != NULL);

  LogDebug("Selected WorkerW HWND: " + std::to_string((uintptr_t)workerw));
  return workerw;
}

bool DesktopShellManager::AttachToDesktop(HWND windowHandle) {
  LogDebug("AttachToDesktop called for HWND: " + std::to_string((uintptr_t)windowHandle));
  if (!windowHandle) return false;

  LONG_PTR exStyle = ::GetWindowLongPtr(windowHandle, GWL_EXSTYLE);
  exStyle &= ~WS_EX_LAYERED;
  exStyle |= WS_EX_TOOLWINDOW;
  ::SetWindowLongPtr(windowHandle, GWL_EXSTYLE, exStyle);

  LONG_PTR style = ::GetWindowLongPtr(windowHandle, GWL_STYLE);
  style &= ~(WS_POPUP | WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU);
  style |= WS_CHILD | WS_VISIBLE;
  ::SetWindowLongPtr(windowHandle, GWL_STYLE, style);

  HWND workerw = GetWorkerWHandle();
  LogDebug("GetWorkerWHandle returned: " + std::to_string((uintptr_t)workerw));

  bool reparented = false;
  if (workerw != NULL) {
    ::SetLastError(0);
    HWND oldParent = ::SetParent(windowHandle, workerw);
    DWORD err = GetLastError();
    LogDebug("SetParent result oldParent: " + std::to_string((uintptr_t)oldParent) + ", GetLastError: " + std::to_string(err));
    if (oldParent != NULL || err == 0) {
      reparented = true;
    }
  }

  if (!reparented) {
    LogDebug("Fallback: Configuring as HWND_BOTTOM desktop window");
    LONG_PTR popupStyle = ::GetWindowLongPtr(windowHandle, GWL_STYLE);
    popupStyle &= ~(WS_CHILD | WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU);
    popupStyle |= WS_POPUP | WS_VISIBLE;
    ::SetWindowLongPtr(windowHandle, GWL_STYLE, popupStyle);

    LONG_PTR popupExStyle = ::GetWindowLongPtr(windowHandle, GWL_EXSTYLE);
    popupExStyle |= WS_EX_TOOLWINDOW | WS_EX_LAYERED;
    ::SetWindowLongPtr(windowHandle, GWL_EXSTYLE, popupExStyle);

    BOOL posRes = ::SetWindowPos(windowHandle, HWND_BOTTOM, 60, 60, 240, 180, SWP_NOACTIVATE | SWP_SHOWWINDOW | SWP_FRAMECHANGED);
    LogDebug("Fallback SetWindowPos HWND_BOTTOM result: " + std::to_string(posRes));
  } else {
    BOOL posRes = ::SetWindowPos(windowHandle, HWND_TOP, 60, 60, 240, 180, SWP_NOACTIVATE | SWP_SHOWWINDOW | SWP_FRAMECHANGED);
    LogDebug("SetWindowPos HWND_TOP result: " + std::to_string(posRes));
  }

  ::ShowWindow(windowHandle, SW_SHOW);
  ::UpdateWindow(windowHandle);

  return true;
}