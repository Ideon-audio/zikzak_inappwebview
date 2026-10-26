import 'package:webview_windows/webview_windows.dart';

/// The [WebviewController]s currently alive in this process.
///
/// `webview_windows` exposes cookie and cache operations only as instance
/// methods of an initialized [WebviewController], while the platform
/// interface's [PlatformCookieManager] is a process-wide singleton with no
/// WebView in hand. Cookies live in the WebView2 user-data folder shared by
/// every controller of the same environment, so clearing them through ANY
/// live controller clears them for all. This registry is how the cookie
/// manager finds one: [InAppWebViewWindowsController] registers its
/// controller on construction and removes it on dispose.
class LiveWebviews {
  LiveWebviews._();

  static final Set<WebviewController> _controllers = <WebviewController>{};

  static void register(WebviewController controller) {
    _controllers.add(controller);
  }

  static void unregister(WebviewController controller) {
    _controllers.remove(controller);
  }

  /// A live, initialized controller, or `null` when none exists.
  static WebviewController? any() {
    for (final c in _controllers) {
      if (c.value.isInitialized) return c;
    }
    return null;
  }

  /// Number of registered controllers (tests).
  static int get count => _controllers.length;
}
