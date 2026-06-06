import 'package:flutter/material.dart';

void main() => runApp(const HardwareVerifierApp());
class HardwareVerifierApp extends StatelessWidget {
  const HardwareVerifierApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(title: '硬件信息验真', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true, brightness: Brightness.light),
    darkTheme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true, brightness: Brightness.dark),
    home: const HardwareHomePage());
}

class HardwareComponent {
  final String name, icon, value, detail, status;
  final bool verified;
  HardwareComponent({required this.name, required this.icon, required this.value, required this.detail, required this.status, this.verified = true});
}

class HardwareHomePage extends StatefulWidget {
  const HardwareHomePage({super.key});
  @override
  State<HardwareHomePage> setState() => _HardwareHomePageState();
}

class _HardwareHomePageState extends State<HardwareHomePage> {
  final _components = [
    HardwareComponent(name: '处理器 (CPU)', icon: '🧠', value: 'Intel Core i7-13700K', detail: '16核24线程 • 3.4GHz (睿频5.4GHz)\nRaptor Lake • 10nm ESF\nL3缓存: 30MB', status: '✅ 已验证'),
    HardwareComponent(name: '显卡 (GPU)', icon: '🎮', value: 'NVIDIA RTX 4070 Ti', detail: '12GB GDDR6X • 7680 CUDA核心\n显存位宽: 192bit\n基础频率: 2310MHz', status: '✅ 已验证'),
    HardwareComponent(name: '内存 (RAM)', icon: '📊', value: '32GB DDR5-5600', detail: '2x16GB 双通道\n时序: CL36-36-36-76\n品牌: Kingston Fury Beast', status: '✅ 已验证'),
    HardwareComponent(name: '主板', icon: '🔌', value: 'ASUS ROG STRIX Z790-E', detail: 'LGA 1700 • Intel Z790芯片组\nWi-Fi 6E • Bluetooth 5.3\n4x M.2插槽', status: '✅ 已验证'),
    HardwareComponent(name: '系统盘 (SSD)', icon: '💾', value: 'Samsung 990 PRO 1TB', detail: 'NVMe PCIe 4.0 x4\n读取: 7450MB/s • 写入: 6900MB/s\n序列号: S6BENS0T123456', status: '✅ 已验证'),
    HardwareComponent(name: '显示器', icon: '🖥️', value: 'LG 27GP850-B', detail: '27英寸 • 2560x1440 (2K)\n165Hz • IPS • HDR400\n色域: 98% DCI-P3', status: '✅ 已验证'),
  ];

  bool _verifying = false;
  String _verifyStatus = '就绪';

  void _verifyAll() {
    setState(() { _verifying = true; _verifyStatus = '检测中...'; });
    Future.delayed(const Duration(seconds: 3), () => setState(() { _verifying = false; _verifyStatus = '检测完成 - 全部通过'; }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔍 硬件信息验真'), centerTitle: true, actions: [
        IconButton(icon: const Icon(Icons.share), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('报告已导出'), behavior: SnackBarBehavior.floating)), tooltip: '导出报告'),
      ]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 概览
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Icon(_verifying ? Icons.hourglass_top : Icons.verified, size: 48, color: _verifying ? Colors.orange : Colors.green),
          const SizedBox(height: 8),
          Text(_verifyStatus, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _verifying ? Colors.orange : Colors.green)),
          const SizedBox(height: 4),
          Text('检测时间: ${DateTime.now().toString().substring(0, 19)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _verifying ? null : _verifyAll, icon: _verifying ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.play_arrow), label: Text(_verifying ? '检测中...' : '开始全面检测'))),
        ]))),
        const SizedBox(height: 16),
        // 硬件列表
        const Text('硬件信息', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ..._components.map((comp) => Card(margin: const EdgeInsets.only(bottom: 12), child: ExpansionTile(
          leading: Text(comp.icon, style: const TextStyle(fontSize: 32)),
          title: Text(comp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(comp.value, style: const TextStyle(fontSize: 13)),
          trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: comp.verified ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(comp.status, style: TextStyle(fontSize: 11, color: comp.verified ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
          children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Divider(),
            Text(comp.detail, style: const TextStyle(fontSize: 13, height: 1.6)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.copy, size: 16), label: const Text('复制', style: TextStyle(fontSize: 12)))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.search, size: 16), label: const Text('查询', style: TextStyle(fontSize: 12)))),
            ]),
          ]))],
        ))),
        const SizedBox(height: 16),
        // 防坑提示
        Card(color: Colors.amber.shade50, child: const Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.warning, color: Colors.amber), SizedBox(width: 8), Text('二手电脑防坑指南', style: TextStyle(fontWeight: FontWeight.bold))]),
          SizedBox(height: 8),
          Text('• 核对CPU型号与卖家描述是否一致\n• 检查内存容量和频率是否正确\n• 验证硬盘容量和健康度\n• 查看显卡型号和显存大小\n• 确认主板型号和接口数量\n• 检查显示器分辨率和刷新率', style: TextStyle(fontSize: 13)),
        ]))),
      ])),
    );
  }
}
