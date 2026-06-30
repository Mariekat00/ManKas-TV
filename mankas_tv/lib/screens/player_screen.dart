import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../services/cast_service.dart';
import '../services/notification_service.dart';
import '../utils/app_strings.dart';
import '../widgets/animated_icons.dart';
import '../features/states/stream_error_page.dart';

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
  bool _showControls = true;
  Timer? _hideControlsTimer;
  StreamSubscription? _castSub;

  StreamSubscription? _completedSub;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = Player(
      configuration: PlayerConfiguration(bufferSize: 150 * 1024 * 1024),
    );
    _controller = VideoController(_player);

    _player.stream.playing.listen((playing) {
      if (mounted) {
        _isPlaying = playing;
        if (playing && _error != null) {
          setState(() => _error = null);
        }
      }
    });

    _errorSub = _player.stream.error.listen((e) {
      if (!mounted) return;
      if (_isPlaying) return;
      final isCompleted = _player.state.completed;
      if (isCompleted) return;
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isPlaying && !_player.state.completed) {
          setState(() => _error = '${AppStrings.of(context).playbackError} $e');
        }
      });
    });

    _castSub = CastService.instance.stateStream.listen((state) {
      if (mounted) setState(() {});
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
    if (channel == null) {
      if (mounted) {
        setState(() => _error = AppStrings.of(context).noChannelSelected);
      }
      return;
    }

    setState(() {
      _error = null;
      _isInitialized = false;
      _isPlaying = false;
    });

    try {
      String url = newUrl ?? channel.streamUrl;

      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        setState(() {
          _error = '${AppStrings.of(context).youtubeStreamMsg}\nURL: $url';
        });
        return;
      }

      if (url.contains('twitch.tv')) {
        setState(() {
          _error = '${AppStrings.of(context).twitchStreamMsg}\nURL: $url';
        });
        return;
      }

      Map<String, String>? headers;
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
      setState(() => _error = '${AppStrings.of(context).streamError}: $e');
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
      _startHideControlsTimer();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _hideControlsTimer?.cancel();
      setState(() => _showControls = true);
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isFullscreen) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onVideoTap() {
    if (_isFullscreen) {
      setState(() => _showControls = !_showControls);
      if (_showControls) {
        _startHideControlsTimer();
      }
    }
  }

  void _castCurrentChannel() {
    final channel = context.read<TvProvider>().selectedChannel;
    if (channel == null) return;

    final cast = CastService.instance;
    if (!cast.isConnected) {
      cast.startDiscovery();
      _showCastDiscoveryDialog(channel);
      return;
    }

    cast.castMedia(
      url: channel.streamUrl,
      title: channel.name,
      subtitle: [channel.category, channel.country, channel.language]
          .where((e) => e != null && e.isNotEmpty)
          .join(' · '),
      imageUrl: channel.logo,
    );
  }

  void _showCastDiscoveryDialog(Channel channel) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.cast, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppStrings.of(context).castDevices,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.of(context).castSearching,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppStrings.of(context).cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService().cancelAll();
    _errorSub?.cancel();
    _completedSub?.cancel();
    _castSub?.cancel();
    _hideControlsTimer?.cancel();
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
    final theme = Theme.of(context);

    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: _buildVideo(),
            ),
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: _buildTopBar(channel, theme, immersive: true),
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(theme),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildTopBar(channel, theme),
          ),
          Expanded(
            child: _buildVideo(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(Channel? channel, ThemeData theme, {bool immersive = false}) {
    final isCasting = CastService.instance.isConnected;
    return Container(
      color: immersive ? Colors.black54 : Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () {
              if (_isFullscreen) {
                _toggleFullscreen();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          if (channel != null) ...[
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                channel.name,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
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
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
          if (channel != null)
            IconButton(
              icon: Icon(Icons.picture_in_picture_alt, color: theme.colorScheme.onSurface),
              onPressed: _enterPip,
              tooltip: 'PiP',
            ),
          IconButton(
            icon: Icon(
              isCasting ? Icons.cast_connected : Icons.cast,
              color: isCasting ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
            onPressed: _castCurrentChannel,
            tooltip: AppStrings.of(context).cast,
          ),
          IconButton(
            icon: Icon(
              _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: _toggleFullscreen,
            tooltip: _isFullscreen ? 'Exit fullscreen' : 'Fullscreen',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(Icons.play_circle_fill, color: theme.colorScheme.onSurface, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.35,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.volume_up, color: theme.colorScheme.onSurface, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_error != null) {
      return StreamErrorPage(
        onRetry: () => _initPlayer(),
        onBack: () {
          if (_isFullscreen) {
            _toggleFullscreen();
          } else {
            Navigator.pop(context);
          }
        },
      );
    }

    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpinningIcon(icon: Icons.refresh, size: 40, color: Colors.white54),
            const SizedBox(height: 16),
            Text(AppStrings.of(context).loading, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _onVideoTap,
      child: ColoredBox(
        color: Colors.black,
        child: Video(
          controller: _controller,
          controls: NoVideoControls,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
