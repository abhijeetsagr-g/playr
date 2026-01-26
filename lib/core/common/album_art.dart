import 'dart:typed_data';
import 'package:flutter/material.dart';

class AlbumArt extends StatelessWidget {
  const AlbumArt({
    super.key,
    required this.size,
    required this.artwork,
    this.borderRadius = 12,
  });

  final Size size;
  final Uint8List? artwork;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.grey.shade300,
        child: artwork != null
            ? Image.memory(artwork!, fit: BoxFit.cover, gaplessPlayback: true)
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return const Center(
      child: Icon(Icons.music_note, size: 48, color: Colors.white70),
    );
  }
}
