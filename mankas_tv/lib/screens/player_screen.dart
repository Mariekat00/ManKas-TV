import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';
import '../services/notification_service.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with WidgetsBindingObserver {
  late final Player _player;
  late final VideoController _controller;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = Player();
    _controller = VideoController(_player);
    _player.stream.error.listen((e) {
      if (mounted) setState(() => _error = 'Erreur de lecture : $e');
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
          _error = 'Les flux YouTube s\'ouvrent dans le navigateur. URL : $url';
        });
        return;
      }

      if (url.contains('twitch.tv')) {
        setState(() {
          _error = 'Les flux Twitch s\'ouvrent dans le navigateur. URL : $url';
        });
        return;
      }

      await _player.open(Media(url));
      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _error = 'Échec du chargement du flux : $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService().cancelAll();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TvProvider>(
      builder: (context, provider, _) {
        final channel = provider.selectedChannel;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
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
      },
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _initPlayer(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white54),
            SizedBox(height: 16),
            Text('Chargement du flux...', style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return Video(
      controller: _controller,
      controls: MaterialVideoControls,
    );
  }
}
