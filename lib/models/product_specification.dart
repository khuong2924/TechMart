import 'package:flutter/foundation.dart';

class ProductSpecification {
  // Common specifications across most products
  final String? processor;
  final String? ram;
  final String? storage;
  final String? display;
  
  // Category-specific specifications
  // Mobile devices
  final String? camera;
  final String? frontCamera;
  final String? battery;
  
  // Computers
  final String? graphics;
  final String? operatingSystem;
  
  // Audio devices
  final String? connectionType;
  final String? batteryLife;
  final String? weight;
  
  // Wearables
  final String? size;
  final String? sensors;

  // Additional specifications as a map for flexibility
  final Map<String, String> additionalSpecs;

  const ProductSpecification({
    this.processor,
    this.ram,
    this.storage,
    this.display,
    this.camera,
    this.frontCamera,
    this.battery,
    this.graphics,
    this.operatingSystem,
    this.connectionType,
    this.batteryLife,
    this.weight,
    this.size,
    this.sensors,
    this.additionalSpecs = const {},
  });

  // Convert from map for backward compatibility
  factory ProductSpecification.fromMap(Map<String, String> map) {
    return ProductSpecification(
      processor: map['Chip'] ?? map['Bộ xử lý'],
      ram: map['RAM'],
      storage: map['Bộ nhớ trong'] ?? map['Ổ cứng'],
      display: map['Màn hình'],
      camera: map['Camera sau'],
      frontCamera: map['Camera trước'],
      battery: map['Pin'],
      graphics: map['Đồ họa'],
      operatingSystem: map['Hệ điều hành'],
      connectionType: map['Kết nối'],
      batteryLife: map['Thời lượng pin'],
      weight: map['Trọng lượng'],
      size: map['Kích thước'],
      sensors: map['Cảm biến'],
      additionalSpecs: Map.from(map)..removeWhere((key, _) => 
          [
            'Chip', 'Bộ xử lý', 'RAM', 'Bộ nhớ trong', 'Ổ cứng', 
            'Màn hình', 'Camera sau', 'Camera trước', 'Pin', 'Đồ họa',
            'Hệ điều hành', 'Kết nối', 'Thời lượng pin', 'Trọng lượng',
            'Kích thước', 'Cảm biến'
          ].contains(key)
      ),
    );
  }

  // Convert to map for serialization and backward compatibility
  Map<String, String> toMap() {
    final map = <String, String>{};
    
    // Add common specs
    if (processor != null) map[processor!.contains('Apple') ? 'Chip' : 'Bộ xử lý'] = processor!;
    if (ram != null) map['RAM'] = ram!;
    if (storage != null) map[storage!.contains('GB') && !storage!.contains('SSD') ? 'Bộ nhớ trong' : 'Ổ cứng'] = storage!;
    if (display != null) map['Màn hình'] = display!;
    if (camera != null) map['Camera sau'] = camera!;
    if (frontCamera != null) map['Camera trước'] = frontCamera!;
    if (battery != null) map['Pin'] = battery!;
    if (graphics != null) map['Đồ họa'] = graphics!;
    if (operatingSystem != null) map['Hệ điều hành'] = operatingSystem!;
    if (connectionType != null) map['Kết nối'] = connectionType!;
    if (batteryLife != null) map['Thời lượng pin'] = batteryLife!;
    if (weight != null) map['Trọng lượng'] = weight!;
    if (size != null) map['Kích thước'] = size!;
    if (sensors != null) map['Cảm biến'] = sensors!;
    
    // Add additional specs
    map.addAll(additionalSpecs);
    
    return map;
  }

  // Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'display': display,
      'camera': camera,
      'frontCamera': frontCamera,
      'battery': battery,
      'graphics': graphics,
      'operatingSystem': operatingSystem,
      'connectionType': connectionType,
      'batteryLife': batteryLife,
      'weight': weight,
      'size': size,
      'sensors': sensors,
      'additionalSpecs': additionalSpecs,
    };
  }

  // Convert from JSON for deserialization
  factory ProductSpecification.fromJson(Map<String, dynamic> json) {
    return ProductSpecification(
      processor: json['processor'],
      ram: json['ram'],
      storage: json['storage'],
      display: json['display'],
      camera: json['camera'],
      frontCamera: json['frontCamera'],
      battery: json['battery'],
      graphics: json['graphics'],
      operatingSystem: json['operatingSystem'],
      connectionType: json['connectionType'],
      batteryLife: json['batteryLife'],
      weight: json['weight'],
      size: json['size'],
      sensors: json['sensors'],
      additionalSpecs: Map<String, String>.from(json['additionalSpecs'] ?? {}),
    );
  }

  // Helper to determine if specifications are empty
  bool get isEmpty {
    return processor == null && ram == null && storage == null && 
           display == null && camera == null && frontCamera == null && 
           battery == null && graphics == null && operatingSystem == null && 
           connectionType == null && batteryLife == null && weight == null && 
           size == null && sensors == null && additionalSpecs.isEmpty;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}