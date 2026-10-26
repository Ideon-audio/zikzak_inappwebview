// Copyright 2024. All rights reserved.

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/cookie_manager.dart';
import 'src/in_app_webview_windows_platform.dart';

/// The Windows implementation of [InAppWebViewPlatform].
class ZikzakInAppWebViewWindows extends InAppWebViewPlatform {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith() {
    InAppWebViewPlatform.instance = ZikzakInAppWebViewWindows();
  }

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    return WindowsCookieManager(params);
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return InAppWebViewWindowsPlatform(params);
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return InAppWebViewWindowsWidget(params);
  }
}
