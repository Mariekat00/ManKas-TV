import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../services/notification_service.dart';
import '../utils/app_strings.dart';
import 'package:share_plus/share_plus.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with WidgetsBindingObserver {
  static const _pipChannel = MethodChannel('com.mankas.mankas_tv/pip');

  late final Player _player;
  late final VideoController _controller;
  bool _isInitialized = false;
  String? _error;
  StreamSubscription? _errorSub;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = Player(
      configuration: PlayerConfiguration(bufferSize: 150 * 1024 * 1024),
    );
    _controller = VideoController(_player);
    _errorSub = _player.stream.error.listen((e) {
      if (mounted) setState(() => _error = 'Playback error: $e');
    });
    _initPlayer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _showNotification();
    } else if (state == AppLifecycleState.resumed) {
      NotificationService().cancelAll();
    }
  }

  Future<void> _showNotification() async {
    final channel = context.read<TvProvider>().selectedChannel;
    if (channel == null) return;
    await NotificationService().showMediaNotification(
      id: channel.id.hashCode,
      title: channel.name,
      artist: channel.category,
    );
  }

  bool _retryingForceSeekable = false;

  Future<void> _initPlayer({String? newUrl}) async {
    final channel = context.read<TvProvider>().selectedChannel;
    if (channel == null) return;

    setState(() {
      _error = null;
      _isInitialized = false;
    });

    try {
      String url = newUrl ?? channel.streamUrl;

      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        setState(() {
          _error = 'YouTube streams open in the browser. URL: $url';
        });
        return;
      }

      if (url.contains('twitch.tv')) {
        setState(() {
          _error = 'Twitch streams open in the browser. URL: $url';
        });
        return;
      }

      Map<String, String>? headers;
      if (url.contains('streamfree.app')) {
        headers = {
          'Referer': 'https://streamfree.app/',
          'Origin': 'https://streamfree.app',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36',
        };
      }
      await _player.open(Media(url, httpHeaders: headers ?? {}));
      setState(() => _isInitialized = true);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('force-seekable') && !_retryingForceSeekable) {
        _retryingForceSeekable = true;
        await Future.delayed(const Duration(milliseconds: 500));
        await _initPlayer(newUrl: newUrl);
        _retryingForceSeekable = false;
        return;
      }
      setState(() => _error = 'Failed to load stream: $e');
    }
  }

  Future<void> _enterPip() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      try {
        await _pipChannel.invokeMethod('enterPictureInPicture');
      } catch (_) {}
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService().cancelAll();
    _errorSub?.cancel();
    _player.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channel = context.select<TvProvider, Channel?>((p) => p.selectedChannel);

    return Scaffold(
          backgroundColor: Colors.black,
          body: _isFullscreen
              ? _buildPlayer()
              : Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        if (channel != null) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              channel.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            [channel.category, channel.country, channel.language]
                                .where((e) => e != null && e.isNotEmpty)
                                .join(' / '),
                            style: TextStyle(
                              color: Colors.white.withAlpha(128),
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (channel != null)
                          IconButton(
                            icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                            onPressed: _enterPip,
                          ),
                        if (channel != null)
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              Share.share(
                                'Regarde "${channel.name}" sur ManKas TV !\n${channel.streamUrl}',
                              );
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                            color: Colors.white,
                          ),
                          onPressed: _toggleFullscreen,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _buildPlayer(),
                ),
              ],
            ),
        );
  }

  Widget _buildPlayer() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _initPlayer(),
                child: Text(AppStrings.of(context).retry),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  final provider = context.read<TvProvider>();
                  final channels = provider.channels;
                  final current = provider.selectedChannel;
                  if (current != null) {
                    final idx = channels.indexOf(current);
                    if (idx >= 0 && idx < channels.length - 1) {
                      provider.setSelectedChannel(channels[idx + 1]);
                      _initPlayer();
                    }
                  }
                },
                icon: const Icon(Icons.skip_next, color: Colors.white54),
                label: Text(AppStrings.of(context).nextChannel, style: const TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white54),
            const SizedBox(height: 16),
            Text('Loading stream...', style: const TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_isFullscreen) {
          _toggleFullscreen();
        }
      },
      child: Video(
        controller: _controller,
        controls: MaterialVideoControls,
      ),
    );
  }
}
