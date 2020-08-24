import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

const urlToDownload =
    "https://drive.google.com/u/0/uc?id=1xWM1lugpyGQTRRA05NcnzLOjeYlm9ZkT&export=download";
const urlToView =
    "https://drive.google.com/file/d/1xWM1lugpyGQTRRA05NcnzLOjeYlm9ZkT/view";

class PlayerTrigger extends StatefulWidget {
  final PanelController pc;
  int toStart;

  PlayerTrigger(this.pc, this.toStart);

  @override
  _PlayerTriggerState createState() => _PlayerTriggerState();
}

class _PlayerTriggerState extends State<PlayerTrigger> {
  PlayerMode mode;

  AudioCache _audioCache = AudioCache();
  AudioPlayer _advancedPlayer = AudioPlayer();
  String _localFilePath;

  AudioPlayer audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;
  bool _onPlay = false;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _isStopped => _playerState == PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    // if (Platform.isIOS) {
    //   if (_audioCache.fixedPlayer != null) {
    //     _audioCache.fixedPlayer.startHeadlessService();
    //   }
    //   _advancedPlayer.startHeadlessService();
    // }
  }

  @override
  void dispose() {
    audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  Future _loadFile() async {
    final bytes = await readBytes(urlToDownload);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/azkar/morning/afasy.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        _localFilePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(120),
      child: !_isStopped
          ? Row(
              children: [
                _isPlaying
                    ? IconButton(
                        onPressed: () => _pause(),
                        iconSize: 24,
                        icon: Icon(Icons.pause),
                        color: Colors.green,
                      )
                    : IconButton(
                        onPressed: () => _play(),
                        iconSize: 24,
                        icon: Icon(Icons.play_arrow),
                        color: Colors.green,
                      ),
                IconButton(
                  onPressed: _isPlaying || _isPaused ? () => _stop() : null,
                  iconSize: 24,
                  icon: Icon(Icons.stop),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    _setLoop();
                  },
                  iconSize: 24,
                  icon: Icon(Icons.repeat),
                  color: Colors.green,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      widget.pc.close();
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 32,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                IconButton(
                  onPressed: () => _play(),
                  iconSize: 24,
                  icon: Icon(Icons.play_arrow),
                  color: Colors.green,
                ),
                Text(
                  "Sabah Zikirleri- Mişari Raşid el-Afasi",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
    );
  }

  void _initAudioPlayer() {
    audioPlayer = AudioPlayer(mode: mode);

    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : Duration(seconds: widget.toStart); // null;
    final result =
        await audioPlayer.play(urlToDownload, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after audioPlayer.play() or audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  _setLoop() {}

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
