import 'package:flutter/material.dart';
import './src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  runApp(ProviderScope(child: const MyApp()));
}

