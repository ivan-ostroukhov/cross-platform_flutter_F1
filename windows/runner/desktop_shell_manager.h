#ifndef RUNNER_DESKTOP_SHELL_MANAGER_H_
#define RUNNER_DESKTOP_SHELL_MANAGER_H_

#include <windows.h>

class DesktopShellManager {
 public:
  static HWND GetWorkerWHandle();
  static bool AttachToDesktop(HWND windowHandle);
};

#endif  // RUNNER_DESKTOP_SHELL_MANAGER_H_