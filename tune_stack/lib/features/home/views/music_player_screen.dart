import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // You'll need to add this package
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/helpers/toast_helper.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({
    required this.musicUrl,
    required this.title,
    required this.artist,
    required this.coverImageUrl,
    super.key,
  });
  final String musicUrl;
  final String title;
  final String artist;
  final String coverImageUrl;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();

    // Set up audio player events
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });

    _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // Try to load and play the music
    try {
      await _audioPlayer.setUrl(widget.musicUrl);
      await _audioPlayer.play();
    } catch (e) {
      LogHelper.logError('Error playing audio: $e');
      AppToastHelper.showError('Failed to load audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'Now Playing',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConst.k16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConst.k12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
                image: DecorationImage(
                  image: widget.coverImageUrl.isNotEmpty
                      ? NetworkImage(widget.coverImageUrl)
                      : const AssetImage('assets/images/default_album_art.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: AppConst.k24),

            // Song title
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppConst.k8),

            // Artist name
            Text(
              widget.artist,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppConst.k32),

            // Seek bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConst.k16),
              child: Column(
                children: [
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      _audioPlayer.seek(newPosition);
                    },
                    activeColor: AppColors.primary,
                    inactiveColor: Colors.grey.shade300,
                  ),

                  // Duration indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConst.k16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position)),
                        Text(_formatDuration(_duration)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConst.k32),

            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 48,
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
