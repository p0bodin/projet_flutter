import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/bluetooth_devices_service.dart';


// --- INVENTORY PAGE (Bluetooth Devices) ---
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool _isScanning = false;
  List<ScanResult> _discoveredDevices = [];
  List<BluetoothDevice> _connectedDevices = [];
  List<Map<String, dynamic>> _savedConnectedDevices = [];

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    await _loadSavedConnectedDevices();
    bool isBluetoothAvailable = (await FlutterBluePlus.isAvailable) ?? false;
    if (!isBluetoothAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth is not available on this device"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    await _requestBluetoothPermissions();
    _loadConnectedDevices();
  }

  Future<void> _loadSavedConnectedDevices() async {
    final devices = await BluetoothDevicesService.getConnectedDevices();
    setState(() {
      _savedConnectedDevices = devices;
    });
  }

  Future<void> _requestBluetoothPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]?.isDenied ?? true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth permissions are required"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _loadConnectedDevices() async {
    try {
      List<BluetoothDevice> connectedDevices = await FlutterBluePlus.connectedDevices;
      setState(() {
        _connectedDevices = connectedDevices;
      });
    } catch (e) {
      print("Error loading connected devices: $e");
    }
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _discoveredDevices = results.where((result) => result.device.name.isNotEmpty).toList();
        });
      });

      await Future.delayed(const Duration(seconds: 4));
      await FlutterBluePlus.stopScan();

      setState(() {
        _isScanning = false;
      });
    } catch (e) {
      print("Error scanning: $e");
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _connectDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: true);
      await BluetoothDevicesService.saveConnectedDevice(
        deviceId: device.id.id,
        deviceName: device.name.isEmpty ? "Unknown Device" : device.name,
      );
      await _loadConnectedDevices();
      await _loadSavedConnectedDevices();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${device.name} connected!"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        _discoveredDevices.removeWhere((r) => r.device == device);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to connect: $e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      await BluetoothDevicesService.removeConnectedDevice(device.id.id);
      await _loadConnectedDevices();
      await _loadSavedConnectedDevices();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${device.name} disconnected"),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Disconnection error: $e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Devices"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScanning,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E548E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              icon: _isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.bluetooth_searching),
              label: Text(
                _isScanning ? "Scanning..." : "Scan for Devices",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_savedConnectedDevices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Devices (${_savedConnectedDevices.length})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () async {
                      await BluetoothDevicesService.clearAllConnectedDevices();
                      await _loadSavedConnectedDevices();
                    },
                    child: const Text("Clear All", style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _savedConnectedDevices.map((device) {
                  return _buildSavedDeviceTile(device);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_connectedDevices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Active Connected (${_connectedDevices.length})",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _connectedDevices.map((device) {
                  return _buildDeviceTile(device, isConnected: true);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_discoveredDevices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available (${_discoveredDevices.length})",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _discoveredDevices.length,
                itemBuilder: (context, index) {
                  final scanResult = _discoveredDevices[index];
                  return _buildDeviceTile(scanResult.device, isConnected: false, rssi: scanResult.rssi);
                },
              ),
            ),
          ] else if (!_isScanning && _connectedDevices.isEmpty && _savedConnectedDevices.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bluetooth,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No devices found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap 'Scan for Devices' to search",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSavedDeviceTile(Map<String, dynamic> device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green.shade50,
      child: ListTile(
        leading: Icon(Icons.devices, color: Colors.green.shade700),
        title: Text(
          device['deviceName'] ?? 'Unknown Device',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device['deviceId'] ?? '', style: const TextStyle(fontSize: 11)),
            Text(
              "Saved: ${device['connectedAt'] ?? ''}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            await BluetoothDevicesService.removeConnectedDevice(device['deviceId']);
            await _loadSavedConnectedDevices();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${device['deviceName']} removed from saved devices"),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text("Remove", style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildDeviceTile(BluetoothDevice device, {bool isConnected = false, int rssi = 0}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.devices, color: isConnected ? Colors.green : Colors.grey),
        title: Text(device.name.isEmpty ? "Unknown Device" : device.name),
        subtitle: Text(
          "${device.id.id}${!isConnected ? ' • Signal: $rssi dBm' : ''}",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isConnected
            ? ElevatedButton(
                onPressed: () => _disconnectDevice(device),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Disconnect"),
              )
            : ElevatedButton(
                onPressed: () => _connectDevice(device),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E548E),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Connect"),
              ),
      ),
    );
  }
}

