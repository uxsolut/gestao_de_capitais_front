// lib/models/robot_models.dart

class RobotData {
  String status;
  SystemMetrics systemMetrics;
  Performance performance;
  List<Trade> recentTrades;

  RobotData({
    required this.status,
    required this.systemMetrics,
    required this.performance,
    required this.recentTrades,
  });
}

class SystemMetrics {
  String connectionStatus;
  int latency;
  double cpuUsage;
  double memoryUsage;
  String lastUpdate;

  SystemMetrics({
    required this.connectionStatus,
    required this.latency,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.lastUpdate,
  });
}

class Performance {
  double totalReturn;
  double monthlyReturn;
  double winRate;
  double currentBalance;
  int totalTrades;

  Performance({
    required this.totalReturn,
    required this.monthlyReturn,
    required this.winRate,
    required this.currentBalance,
    required this.totalTrades,
  });
}

class Trade {
  String symbol;
  String action;
  int quantity;
  double price;
  String time;

  Trade({
    required this.symbol,
    required this.action,
    required this.quantity,
    required this.price,
    required this.time,
  });
}

class LogEntry {
  String time;
  String type;
  String message;

  LogEntry({
    required this.time,
    required this.type,
    required this.message,
  });
}
