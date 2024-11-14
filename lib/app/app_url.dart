class AppUrl {
  static String ipAddress = "192.168.100.166";
  static String port = "5000";
  static String ipWithport = "$ipAddress:$port";
  static String baseURL = "http://$ipAddress:$port";
  static String webSocket = "$ipAddress:$port/admin/workgroup/read";
  static String login = "$baseURL/admin/login";
}
