import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/theme/app_colors.dart';
import 'package:interactive_book_app/models/module_video_ref.dart';
import 'package:interactive_book_app/modules/video/videosurvices/playerprovider.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';
import 'package:interactive_book_app/modules/video/widgets/dropdown.dart';
import 'package:interactive_book_app/modules/video/widgets/iconbotton.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

class InlineModuleVideo extends StatefulWidget {
  final ModuleVideoRef ref;

  const InlineModuleVideo({super.key, required this.ref});

  @override
  State<InlineModuleVideo> createState() => _InlineModuleVideoState();
}

class _InlineModuleVideoState extends State<InlineModuleVideo> {
  late final VideoProvider _videoProvider;
  late final VideoPlayerProvider _playerProvider;

  Offset? _tapPosition;
  String _selected = "transcript";
  String? _selectedaudio;
  bool _playerReady = false;
  bool _videoLoaded = false;

  @override
  void initState() {
    super.initState();
    _videoProvider = VideoProvider();
    _playerProvider = VideoPlayerProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadVideoData();
    });
  }

  Future<void> _loadVideoData() async {
    await _videoProvider.fetchFromRef(widget.ref);
  }

  Future<void> _fetch() async {
    if (_videoProvider.url != null) {
      await _playerProvider.initialize(_videoProvider.url!);
      if (!mounted) return;
      setState(() => _playerReady = true);
    }
  }

  Future<void> _onPlayVideo() async {
    setState(() => _videoLoaded = true);
    await _fetch();
  }

  @override
  void dispose() {
    if (_playerReady) {
      _playerProvider.player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _videoProvider),
        ChangeNotifierProvider.value(value: _playerProvider),
      ],
      child: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (!_videoLoaded) {
            return _buildThumbnail(context, videoProvider);
          }
          if (videoProvider.isLoading || !_playerReady) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayer(context, videoProvider),
              _buildBottom(context, videoProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, VideoProvider videoProvider) {
    return GestureDetector(
      onTap: _onPlayVideo,
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.play_circle_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, VideoProvider videoProvider) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, playerProvider, child) {
        return AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Video(controller: playerProvider.controller),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المجموعة الأولى: التحكم في الصوت والتقديم/الترجيع
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VideoControlButton(
                          icon: playerProvider.isMuted
                              ? Icons.volume_off
                              : Icons.volume_up,
                          onPressed: playerProvider.toggleMute,
                        ),
                        VideoControlButton(
                          icon: Icons.replay_10,
                          onPressed: playerProvider.seekBackward,
                        ),
                        VideoControlButton(
                          icon: Icons.forward_10,
                          onPressed: playerProvider.seekForward,
                        ),
                      ],
                    ),
                    // المجموعة الثانية: الصوت الخارجي والترجمة والكلمات المفتاحية
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTapDown: (details) =>
                                _tapPosition = details.globalPosition,
                            onTap: () => _showAudioMenu(
                              context,
                              videoProvider,
                              playerProvider,
                            ),
                            child: Icon(
                              Icons.headphones,
                              color: AppColors.lightColor,
                              size: 22,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTapDown: (details) =>
                                _tapPosition = details.globalPosition,
                            onTap: () => _showSubtitleMenu(
                              context,
                              videoProvider,
                              playerProvider,
                            ),
                            child: Icon(
                              Icons.subtitles,
                              color: AppColors.lightColor,
                              size: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.key,
                            color: AppColors.lightColor,
                            size: 22,
                          ),
                          onPressed: () =>
                              _showKeywordsDialog(context, videoProvider),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottom(BuildContext context, VideoProvider videoProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                  hint: 'data language',
                  value: videoProvider.selectedLanguage,
                  items: videoProvider.languageCodes,
                  onChanged: (value) {
                    if (value != null) videoProvider.changeLanguage(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                  hint: 'data format',
                  value: _selected,
                  items: const ["summary25", "summary50", "transcript"],
                  onChanged: (value) {
                    if (value == null) return;
                    videoProvider.selected(value);
                    setState(() => _selected = value);
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Text(
            videoProvider.selectedvalue ??
                videoProvider.defultseletedvalue() ??
                '',
            style: TextStyle(
              color: AppColors.darkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAudioMenu(
    BuildContext context,
    VideoProvider videoProvider,
    VideoPlayerProvider playerProvider,
  ) async {
    if (_tapPosition == null) return;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<String>(
      color: AppColors.lightColor,
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(_tapPosition!, _tapPosition!),
        Offset.zero & overlay.size,
      ),
      items: videoProvider.audiolanguageCodes
          .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
          .toList(),
    );
    if (result != null) {
      setState(() => _selectedaudio = result);
      for (int i = 0; i < videoProvider.audioList!.length; i++) {
        if (_selectedaudio == videoProvider.audioList![i].langCode) {
          await playerProvider.player.setAudioTrack(
            AudioTrack.uri(videoProvider.audioList![i].url!),
          );
          await playerProvider.player.seek(playerProvider.position);
          break;
        }
      }
    }
  }

  Future<void> _showSubtitleMenu(
    BuildContext context,
    VideoProvider videoProvider,
    VideoPlayerProvider playerProvider,
  ) async {
    if (_tapPosition == null) return;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<String>(
      color: AppColors.lightColor,
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(_tapPosition!, _tapPosition!),
        Offset.zero & overlay.size,
      ),
      items: videoProvider.subtitlelangcode!
          .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
          .toList(),
    );
    if (result != null) {
      for (var vtt in videoProvider.vttList!) {
        if (result == vtt.langCode) {
          playerProvider.player.setSubtitleTrack(SubtitleTrack.uri(vtt.url!));
          break;
        }
      }
    }
  }

  Future<void> _showKeywordsDialog(
    BuildContext context,
    VideoProvider videoProvider,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.lightColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: (videoProvider.keywords ?? [])
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            e,
                            style: TextStyle(
                              color: AppColors.darkColor,
                              fontSize: 20,
                            ),
                          ),
                          const Divider(height: 3),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}