// This file is a part of media_kit
// (https://github.com/alexmercerind/media_kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#include "utils.h"

void Utils::EnterNativeFullscreen(HWND window) {
  if (fullscreen_) {
    return;
  }
  fullscreen_ = true;

  // The primary idea here is to revolve around |WS_OVERLAPPEDWINDOW| &
  // detect/set fullscreen based on it. In the window procedure, this is
  // separately handled. If there is no |WS_OVERLAPPEDWINDOW| style on the
  // window i.e. in fullscreen, then no area is left for |WM_NCHITTEST|,
  // accordingly client area is also expanded to fill whole monitor using
  // |WM_NCCALCSIZE|.

  auto style = ::GetWindowLongPtr(window, GWL_STYLE);
  if (style & WS_OVERLAPPEDWINDOW) {
    auto monitor = MONITORINFO{};
    auto placement = WINDOWPLACEMENT{};
    monitor.cbSize = sizeof(MONITORINFO);
    placement.length = sizeof(WINDOWPLACEMENT);
    ::GetWindowPlacement(window, &placement);
    rect_before_fullscreen_ = RECT{
        placement.rcNormalPosition.left,
        placement.rcNormalPosition.top,
        placement.rcNormalPosition.right,
        placement.rcNormalPosition.bottom,
    };
    ::GetMonitorInfo(::MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST),
                     &monitor);
    ::SetWindowLongPtr(window, GWL_STYLE, style & ~WS_OVERLAPPEDWINDOW);
    ::SetWindowPos(window, HWND_TOP, monitor.rcMonitor.left,
                   monitor.rcMonitor.top, monitor.rcMonitor.right,
                   monitor.rcMonitor.bottom,
                   SWP_NOOWNERZORDER | SWP_FRAMECHANGED);
  }
}

void Utils::ExitNativeFullscreen(HWND window) {
  if (!fullscreen_) {
    return;
  }
  fullscreen_ = false;

  auto style = ::GetWindowLongPtr(window, GWL_STYLE);
  if (!(style & WS_OVERLAPPEDWINDOW)) {
    ::SetWindowLongPtr(window, GWL_STYLE, style | WS_OVERLAPPEDWINDOW);
    if (::IsZoomed(window)) {
      // Refresh the parent window.
      ::SetWindowPos(window, nullptr, 0, 0, 0, 0,
                     SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER |
                         SWP_FRAMECHANGED);
      auto rect = RECT{};
      ::GetClientRect(window, &rect);
      auto flutter_view =
          ::FindWindowEx(window, nullptr, kFlutterViewWindowClassName, nullptr);
      ::SetWindowPos(flutter_view, nullptr, rect.left, rect.top,
                     rect.right - rect.left, rect.bottom - rect.top,
                     SWP_NOACTIVATE | SWP_NOZORDER);
    } else {
      ::SetWindowPos(
          window, nullptr, rect_before_fullscreen_.left,
          rect_before_fullscreen_.top,
          rect_before_fullscreen_.right - rect_before_fullscreen_.left,
          rect_before_fullscreen_.bottom - rect_before_fullscreen_.top,
          SWP_NOACTIVATE | SWP_NOZORDER);
    }
  }
}

bool Utils::fullscreen_ = false;

RECT Utils::rect_before_fullscreen_ = RECT{};
