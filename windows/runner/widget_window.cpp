#include "widget_window.h"

#include <dwmapi.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <optional>

#include "desktop_shell_manager.h"
#include "flutter/generated_plugin_registrant.h"

#pragma comment(lib, "dwmapi.lib")

WidgetWindow::WidgetWindow(const flutter::DartProject& project, const std::string& widgetType)
    : project_(project), widget_type_(widgetType) {
  std::vector<std::string> args = project_.dart_entrypoint_arguments();
  args.push_back("--widget-type=" + widgetType);
  project_.set_dart_entrypoint_arguments(args);
}

WidgetWindow::~WidgetWindow() {}

bool WidgetWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  HWND hwnd = GetHandle();

  LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
  style &= ~(WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU);
  style |= WS_POPUP;
  SetWindowLongPtr(hwnd, GWL_STYLE, style);

  LONG_PTR exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
  exStyle |= WS_EX_TOOLWINDOW | WS_EX_LAYERED;
  SetWindowLongPtr(hwnd, GWL_EXSTYLE, exStyle);

  MARGINS margins = { -1, -1, -1, -1 };
  DwmExtendFrameIntoClientArea(hwnd, &margins);

  taskbar_created_message_ = RegisterWindowMessage(L"TaskbarCreated");

  RECT frame = GetClientArea();

  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);

  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }

  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(),
      "com.f1app.apex/desktop_widgets",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name() == "closeClockWidget" || call.method_name() == "closeWidget") {
          result->Success(flutter::EncodableValue(true));
          this->Destroy();
        } else {
          result->NotImplemented();
        }
      });

  flutter_controller_->engine()->SetNextFrameCallback([this, hwnd]() {
    this->Show();
    DesktopShellManager::AttachToDesktop(hwnd);
  });

  flutter_controller_->ForceRedraw();

  return true;
}

void WidgetWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
WidgetWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == taskbar_created_message_ && taskbar_created_message_ != 0) {
    DesktopShellManager::AttachToDesktop(hwnd);
  }

  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}