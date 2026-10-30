#ifndef RUNNER_WIDGET_WINDOW_H_
#define RUNNER_WIDGET_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include <memory>
#include <string>

#include "win32_window.h"

class WidgetWindow : public Win32Window {
 public:
  WidgetWindow(const flutter::DartProject& project, const std::string& widgetType);
  virtual ~WidgetWindow();

 protected:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  flutter::DartProject project_;
  std::string widget_type_;
  UINT taskbar_created_message_ = 0;
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

#endif  // RUNNER_WIDGET_WINDOW_H_