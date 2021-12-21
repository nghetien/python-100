import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PlaySound extends StatefulWidget {
  final String urlSound;

  const PlaySound({
    Key? key,
    required this.urlSound,
  }) : super(key: key);

  @override
  _PlaySoundState createState() => _PlaySoundState();
}

class _PlaySoundState extends State<PlaySound> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool isPlaying = false;
  final List<IconData> _icons = [Icons.play_circle_fill, Icons.pause_circle_filled];

  @override
  void initState() {
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    _audioPlayer.setUrl(widget.urlSound);
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _btnPlay() {
    return IconButton(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      alignment: Alignment.center,
      onPressed: () {
        if(isPlaying){
          _audioPlayer.pause();
        }else{
          _audioPlayer.play(widget.urlSound);
        }
        setState(() {
          isPlaying = !isPlaying;
        });
      },
      icon: isPlaying ? Icon(_icons[1], size: 50, color: $primaryColor,) : Icon(_icons[0], size: 50, color: $primaryColor,),
    );
  }

  _changeToSecond(int value){
    final Duration newDuration = Duration(seconds: value);
    _audioPlayer.seek(newDuration);
  }

  _slide(){
    return Slider(
      activeColor: $primaryColor,
      inactiveColor: $green200,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value){
        setState(() {
          _changeToSecond(value.toInt());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(_duration.toString().split(".")[0]),
              Text(_position.toString().split(".")[0]),
            ],
          ),
        ),
        _slide(),
        _btnPlay(),
      ],
    );
  }
}
