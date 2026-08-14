import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(const UltrashotApp());
}

class UltrashotApp extends StatelessWidget {
  const UltrashotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultrashot FX Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        primaryColor: const Color(0xFFA855F7),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double glitchValue = 0.0;
  double neonGlowValue = 0.0;
  double cinematicFlareValue = 0.0;
  String activePreset = 'Normal';

  void applyPreset(String presetName) {
    setState(() {
      activePreset = presetName;
      if (presetName == 'CyberGlitch') {
        glitchValue = 35.0;
        neonGlowValue = 15.0;
        cinematicFlareValue = 5.0;
      } else if (presetName == 'NeonAura') {
        glitchValue = 5.0;
        neonGlowValue = 85.0;
        cinematicFlareValue = 20.0;
      } else if (presetName == 'RetroLeak') {
        glitchValue = 0.0;
        neonGlowValue = 20.0;
        cinematicFlareValue = 80.0;
      } else {
        glitchValue = 0.0;
        neonGlowValue = 0.0;
        cinematicFlareValue = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ULTRASHOT FX PRO', 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFFA855F7))),
        centerTitle: true,
        backgroundColor: const Color(0xFF121215),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF27272A)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFF1E1E24),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_rounded, size: 64, color: Color(0xFFA855F7)),
                            SizedBox(height: 12),
                            Text("Tap 'Import Media' to Load Photo / Video",
                              style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    if (neonGlowValue > 0 || glitchValue > 0)
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: neonGlowValue / 10,
                            sigmaY: neonGlowValue / 10,
                          ),
                          child: Container(
                            color: Colors.purple.withOpacity(neonGlowValue / 300),
                          ),
                        ),
                      ),
                    if (cinematicFlareValue > 0)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFA855F7).withOpacity(cinematicFlareValue / 150),
                                Colors.transparent,
                                const Color(0xFFEC4899).withOpacity(cinematicFlareValue / 150),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF121215),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PRESETS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPresetBtn("Normal"),
                      _buildPresetBtn("CyberGlitch"),
                      _buildPresetBtn("NeonAura"),
                      _buildPresetBtn("RetroLeak"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSlider("Cyber Glitch Shift", glitchValue, (v) => setState(() => glitchValue = v)),
                _buildSlider("Neon Pulse Glow", neonGlowValue, (v) => setState(() => neonGlowValue = v)),
                _buildSlider("Anamorphic Flare", cinematicFlareValue, (v) => setState(() => cinematicFlareValue = v)),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA855F7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
                    label: const Text("IMPORT MEDIA", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(String name) {
    bool isActive = activePreset == name;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(name, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        selected: isActive,
        selectedColor: const Color(0xFFA855F7),
        backgroundColor: const Color(0xFF1E1E24),
        onSelected: (_) => applyPreset(name),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Slider(
          value: value,
          min: 0,
          max: 100,
          activeColor: const Color(0xFFA855F7),
          inactiveColor: const Color(0xFF27272A),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
