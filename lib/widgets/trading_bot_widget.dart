import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/robot_models.dart';

class TradingBotWidget extends StatefulWidget {
  const TradingBotWidget({Key? key}) : super(key: key);

  @override
  State<TradingBotWidget> createState() => _TradingBotWidgetState();
}

class _TradingBotWidgetState extends State<TradingBotWidget>
    with TickerProviderStateMixin {
  String _status = 'stopped';
  bool _showConfirmDialog = false;
  Timer? _updateTimer;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  
  List<LogEntry> _logs = [
    LogEntry(time: '10:30:15', type: 'info', message: 'Sistema inicializado com sucesso'),
    LogEntry(time: '10:30:16', type: 'info', message: 'Conectando com a corretora...'),
    LogEntry(time: '10:30:17', type: 'success', message: 'Conexão estabelecida'),
    LogEntry(time: '10:30:18', type: 'info', message: 'Aguardando comando para iniciar'),
  ];
  
  RobotData _data = RobotData(
    status: 'stopped',
    systemMetrics: SystemMetrics(
      connectionStatus: 'CONECTADO',
      latency: 45,
      cpuUsage: 23.8,
      memoryUsage: 67.2,
      lastUpdate: '10:30:18',
    ),
    performance: Performance(
      totalReturn: 15.7,
      monthlyReturn: 2.3,
      winRate: 68.5,
      currentBalance: 125750.80,
      totalTrades: 1247,
    ),
    recentTrades: [
      Trade(symbol: 'MGLU3', action: 'VENDA', quantity: 67, price: 70.84, time: '3:36:10 AM'),
      Trade(symbol: 'BBAS3', action: 'COMPRA', quantity: 100, price: 45.67, time: '14:32:15'),
      Trade(symbol: 'WEGE3', action: 'VENDA', quantity: 50, price: 52.3, time: '14:28:42'),
      Trade(symbol: 'MGLU3', action: 'COMPRA', quantity: 200, price: 12.85, time: '14:25:18'),
    ],
  );

  @override
  void initState() {
    super.initState();
    
    // Animação de pulso para status
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Animação de brilho para containers
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startRobot() {
    setState(() {
      _status = 'running';
      _data.status = 'running';
    });
    
    _addLog(LogEntry(
      time: _getCurrentTime(),
      type: 'success',
      message: '🚀 Robô iniciado - Sistema operacional',
    ));
    
    // Iniciar atualizações em tempo real
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateData();
    });
  }

  void _stopRobot() {
    setState(() {
      _showConfirmDialog = true;
    });
  }

  void _confirmStop() {
    setState(() {
      _status = 'stopped';
      _data.status = 'stopped';
      _showConfirmDialog = false;
    });
    
    _updateTimer?.cancel();
    
    _addLog(LogEntry(
      time: _getCurrentTime(),
      type: 'warning',
      message: '⏹️ Robô parado - Sistema offline',
    ));
  }

  void _updateData() {
    setState(() {
      // Atualizar métricas do sistema
      _data.systemMetrics.latency = 30 + Random().nextInt(50);
      _data.systemMetrics.cpuUsage = 15 + Random().nextDouble() * 30;
      _data.systemMetrics.memoryUsage = 60 + Random().nextDouble() * 20;
      _data.systemMetrics.lastUpdate = _getCurrentTime();
      
      // Ocasionalmente adicionar logs
      if (Random().nextDouble() < 0.4) {
        final messages = [
          'Analisando oportunidades de mercado...',
          'Verificando indicadores técnicos',
          'Monitorando volatilidade',
          'Executando estratégia de trading',
          'Atualizando posições',
          'Calculando risk management',
        ];
        
        _addLog(LogEntry(
          time: _getCurrentTime(),
          type: Random().nextDouble() > 0.8 ? 'warning' : 'info',
          message: messages[Random().nextInt(messages.length)],
        ));
      }
      
      // Ocasionalmente adicionar nova operação
      if (Random().nextDouble() < 0.3) {
        final symbols = ['VALE3', 'PETR4', 'ITUB4', 'BBDC4', 'ABEV3'];
        final actions = ['COMPRA', 'VENDA'];
        
        final newTrade = Trade(
          symbol: symbols[Random().nextInt(symbols.length)],
          action: actions[Random().nextInt(actions.length)],
          quantity: 50 + Random().nextInt(200),
          price: 10 + Random().nextDouble() * 100,
          time: _getCurrentTime(),
        );
        
        _data.recentTrades.insert(0, newTrade);
        if (_data.recentTrades.length > 5) {
          _data.recentTrades.removeLast();
        }
        
        _addLog(LogEntry(
          time: _getCurrentTime(),
          type: 'success',
          message: '${newTrade.action} ${newTrade.quantity} ${newTrade.symbol} @ R\$ ${newTrade.price.toStringAsFixed(2)}',
        ));
      }
    });
  }

  void _addLog(LogEntry log) {
    setState(() {
      _logs.insert(0, log);
      if (_logs.length > 20) {
        _logs.removeLast();
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'running':
        return Colors.green;
      case 'stopped':
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (_status) {
      case 'running':
        return 'OPERACIONAL';
      case 'stopped':
        return 'OFFLINE';
      default:
        return 'STANDBY';
    }
  }

  Color _getLogTypeColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green.shade400;
      case 'warning':
        return Colors.amber.shade400;
      case 'error':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // slate-950
      body: Column(
        children: [
          // Header fixo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A).withOpacity(0.95),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF27272A).withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const Icon(
                    Icons.storage,
                    color: Color(0xFF60A5FA), // blue-400
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Trading Bot',
                    style: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          shape: BoxShape.circle,
                          boxShadow: _status == 'running'
                              ? [
                                  BoxShadow(
                                    color: _getStatusColor().withOpacity(_pulseAnimation.value),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : _status == 'stopped'
                                  ? [
                                      BoxShadow(
                                        color: _getStatusColor().withOpacity(_pulseAnimation.value),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(),
                    style: const TextStyle(
                      color: Color(0xFFA1A1AA),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.settings,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Central de Controle
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _status == 'running'
                                ? Color(0xFF10B981).withOpacity(_glowAnimation.value)
                                : _status == 'stopped'
                                    ? Color(0xFFEF4444).withOpacity(_glowAnimation.value)
                                    : const Color(0xFF27272A).withOpacity(0.4),
                            width: 1,
                          ),
                          boxShadow: _status == 'running'
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(_glowAnimation.value * 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : _status == 'stopped'
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFEF4444).withOpacity(_glowAnimation.value * 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Central de Controle',
                              style: TextStyle(
                                color: Color(0xFFF5F5F5),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Gerencie as operações do robô de trading',
                              style: TextStyle(
                                color: Color(0xFFA1A1AA),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _status == 'running' ? null : _startRobot,
                                  icon: const Icon(Icons.play_arrow, size: 20),
                                  label: const Text(
                                    'INICIAR',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                ElevatedButton.icon(
                                  onPressed: _status == 'stopped' ? null : _stopRobot,
                                  icon: const Icon(Icons.stop, size: 20),
                                  label: const Text(
                                    'PARAR',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Layout responsivo
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1024) {
                        // Desktop layout
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Monitor de Log (2/3 da largura)
                            Expanded(
                              flex: 2,
                              child: _buildLogMonitor(),
                            ),
                            const SizedBox(width: 32),
                            // Métricas (1/3 da largura)
                            Expanded(
                              flex: 1,
                              child: _buildMetricsColumn(),
                            ),
                          ],
                        );
                      } else {
                        // Mobile layout
                        return Column(
                          children: [
                            _buildLogMonitor(),
                            const SizedBox(height: 24),
                            _buildMetricsColumn(),
                          ],
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Operações Recentes
                  _buildRecentTrades(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogMonitor() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF27272A).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monitor,
                color: Color(0xFF60A5FA),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Monitor de Sistema',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF60A5FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF60A5FA).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_logs.length} eventos',
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 384,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          log.time,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          log.message,
                          style: TextStyle(
                            color: _getLogTypeColor(log.type),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsColumn() {
    return Column(
      children: [
        _buildSystemMetrics(),
        const SizedBox(height: 24),
        _buildPerformanceMetrics(),
        const SizedBox(height: 24),
        _buildCapitalMetrics(),
      ],
    );
  }

  Widget _buildSystemMetrics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF27272A).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.timeline,
                color: Color(0xFF60A5FA),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Sistema',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            icon: Icons.wifi,
            iconColor: const Color(0xFF10B981),
            label: 'Conexão',
            value: _data.systemMetrics.connectionStatus,
            valueColor: const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            icon: Icons.access_time,
            iconColor: const Color(0xFF60A5FA),
            label: 'Latência',
            value: '${_data.systemMetrics.latency}ms',
            valueColor: const Color(0xFF60A5FA),
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            icon: Icons.flash_on,
            iconColor: const Color(0xFFF59E0B),
            label: 'CPU',
            value: '${_data.systemMetrics.cpuUsage.toStringAsFixed(1)}%',
            valueColor: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF27272A).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Color(0xFF10B981),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Performance',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Retorno Total',
                style: TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+${_data.performance.totalReturn}%',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Retorno Mensal',
                style: TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+${_data.performance.monthlyReturn}%',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Taxa de Acerto',
                style: TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_data.performance.winRate}%',
                style: const TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapitalMetrics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF27272A).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.attach_money,
                color: Color(0xFF60A5FA),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Capital',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo Atual',
                style: TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'R\$ ${_data.performance.currentBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total de Operações',
                style: TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_data.performance.totalTrades}',
                style: const TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F).withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF27272A).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFA1A1AA),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrades() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: const Color(0xFF111111).withOpacity(0.8),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF27272A).withOpacity(0.4),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.bar_chart,
              color: Color(0xFF60A5FA),
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'Operações Recentes',
              style: TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          children: _data.recentTrades.map((trade) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                // ❗ Unificado em um único Border
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF27272A).withOpacity(0.3),
                    width: 1,
                  ),
                  right: BorderSide(
                    color: const Color(0xFF27272A).withOpacity(0.3),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: const Color(0xFF27272A).withOpacity(0.3),
                    width: 1,
                  ),
                  left: BorderSide(
                    color: const Color(0xFF60A5FA).withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trade.action == 'COMPRA'
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: trade.action == 'COMPRA'
                            ? const Color(0xFF10B981).withOpacity(0.3)
                            : const Color(0xFFF59E0B).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      trade.action,
                      style: TextStyle(
                        color: trade.action == 'COMPRA'
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    trade.symbol,
                    style: const TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${trade.quantity} ações',
                    style: const TextStyle(
                      color: Color(0xFFA1A1AA),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${trade.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        trade.time,
                        style: const TextStyle(
                          color: Color(0xFFA1A1AA),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

}

// Dialog de confirmação
class ConfirmStopDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmStopDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF111111).withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFF27272A).withOpacity(0.5),
          width: 1,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning,
              color: Color(0xFFEF4444),
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Confirmar Parada',
            style: TextStyle(
              color: Color(0xFFF5F5F5),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tem certeza que deseja parar o robô de trading?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA1A1AA),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check_circle, size: 16),
                  label: const Text('Sim, Parar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  child: const Text('Cancelar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F1F1F),
                    foregroundColor: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

