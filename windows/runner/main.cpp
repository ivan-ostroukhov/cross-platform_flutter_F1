#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <iostream>
#include <memory>
#include <vector>

#include "flutter_window.h"
#include "widget_window.h"
#include "utils.h"

static std::vector<std::unique_ptr<WidgetWindow>> g_widget_windows;

void RegisterDesktopWidgetChannel(flutter::FlutterEngine* engine) {
  if (!engine) return;

  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      engine->messenger(),
      "com.f1app.apex/desktop_widgets",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        std::cout << "[C++ Channel] Method called: " << call.method_name() << std::endl;
        OutputDebugStringA(("[C++ Channel] Method called: " + call.method_name() + "\n").c_str());

        if (call.method_name() == "createClockWidget") {
          flutter::DartProject project(L"data");
          auto widgetWindow = std::make_unique<WidgetWindow>(project, "clock");

          Win32Window::Point origin(60, 60);
          Win32Window::Size size(240, 180);
          if (widgetWindow->Create(L"Apex Clock Widget", origin, size)) {
            widgetWindow->SetQuitOnClose(false);
            g_widget_windows.push_back(std::move(widgetWindow));
            std::cout << "[C++ Channel] WidgetWindow created successfully!" << std::endl;
            OutputDebugStringA("[C++ Channel] WidgetWindow created successfully!\n");
            result->Success(flutter::EncodableValue(true));
          } else {
            std::cout << "[C++ Channel] WidgetWindow creation failed!" << std::endl;
            OutputDebugStringA("[C++ Channel] WidgetWindow creation failed!\n");
            result->Error("CREATE_FAILED", "Failed to create clock widget window");
          }
        } else {
          result->NotImplemented();
        }
      });
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);

  RECT workArea;
  SystemParametersInfo(SPI_GETWORKAREA, 0, &workArea, 0);

  int workWidth = workArea.right - workArea.left;
  int workHeight = workArea.bottom - workArea.top;

  int windowWidth = 460;
  int windowHeight = 760;

  int originX = workArea.left + (workWidth - windowWidth) / 2;
  int originY = workArea.top + (workHeight - windowHeight) / 2 - 30;

  if (originX < workArea.left) originX = workArea.left + 10;
  if (originY < workArea.top + 10) originY = workArea.top + 10;

  Win32Window::Point origin(originX, originY);
  Win32Window::Size size(windowWidth, windowHeight);
  if (!window.Create(L"Apex", origin, size)) {
    return EXIT_FAILURE;
  }

  RegisterDesktopWidgetChannel(window.GetEngine());
  window.SetQuitOnClose(false);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}