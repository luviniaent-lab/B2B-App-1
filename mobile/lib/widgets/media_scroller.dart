import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaScroller extends StatefulWidget {
  final List<String>? media; // base64 or file refs
  final String? image; // network URL fallback
  const MediaScroller({super.key, this.media, this.image});

  @override
  State<MediaScroller> createState() => _MediaScrollerState();
}

class _MediaScrollerState extends State<MediaScroller> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = widget.media ?? const [];
    if (items.isEmpty) {
      if (widget.image != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(widget.image!, fit: BoxFit.cover),
          ),
        );
      }
      final scheme = Theme.of(context).colorScheme;
      return Container(
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 48, color: Colors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final m = items[i];
              if (m.startsWith('data:video')) {
                return AspectRatio(aspectRatio: 16/9, child: _VideoPlayerInline(src: m));
              }
              // Assume image base64
              try {
                final base64Data = m.split(',').last;
                final bytes = base64Decode(base64Data);
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.memory(bytes, fit: BoxFit.cover),
                );
              } catch (_) {
                return Container(color: Colors.black12);
              }
            },
          ),
          if (items.length > 1) ...[
            // Left arrow
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: _currentIndex > 0 ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } : null,
                  ),
                ),
              ),
            ),
            // Right arrow
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: _currentIndex < items.length - 1 ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } : null,
                  ),
                ),
              ),
            ),
            // Page indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(items.length, (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                )),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _VideoPlayerInline extends StatefulWidget {
  final String src; // base64 data url
  const _VideoPlayerInline({required this.src});
  @override
  State<_VideoPlayerInline> createState() => _VideoPlayerInlineState();
}

class _VideoPlayerInlineState extends State<_VideoPlayerInline> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    // This is a placeholder; in real code, use file path instead of base64 for videos
    _controller = VideoPlayerController.networkUrl(Uri.parse(''));
  }
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black12, child: const Center(child: Icon(Icons.play_arrow)));
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

