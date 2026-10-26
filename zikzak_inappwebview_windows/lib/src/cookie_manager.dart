import 'dart:async';

import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_windows_platform.dart';
import 'live_webviews.dart';

/// The Windows implementation of [PlatformCookieManager].
///
/// `webview_windows` offers no cookie store API: the only cookie operation
/// WebView2 exposes through it is [WebviewController.clearCookies], an
/// instance method of an initialized controller. Cookies belong to the
/// process-wide WebView2 environment (its user-data folder), so clearing
/// them through any live controller clears them for every WebView of that
/// environment. [deleteAllCookies] therefore uses a live controller from
/// [LiveWebviews] when one exists, and otherwise brings up a short-lived
/// headless controller for the call — a WebView that was closed, or an app
/// that has not opened one yet in this run, still has the cookies of the
/// previous run on disk.
///
/// Reading or setting individual cookies is not possible through
/// `webview_windows`; those methods keep the platform interface's
/// `UnimplementedError` so a caller is told rather than silently served
/// nothing.
class WindowsCookieManager extends PlatformCookieManager {
  WindowsCookieManager(super.params) : super.implementation();

  @override
  Future<bool> deleteAllCookies() async {
    final live = LiveWebviews.any();
    if (live != null) {
      await live.clearCookies();
      return true;
    }
    // No WebView is open: use a transient one. The environment is
    // process-wide; when another WebView already created it the requested
    // args are ignored (see ensureWebView2Environment), which is fine here —
    // the cookies to clear are the environment's, whichever args made it.
    final defaultFolder = await defaultWebView2UserDataFolder();
    final args = resolveEnvironmentInitArgs(
      settings: params.webViewEnvironment?.settings,
      defaultUserDataFolder: () => defaultFolder,
    );
    await ensureWebView2Environment(args);
    final controller = WebviewController();
    await controller.initialize();
    try {
      await controller.clearCookies();
    } finally {
      await controller.dispose();
    }
    return true;
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    // Nothing held: the registry belongs to the controllers.
  }
}
