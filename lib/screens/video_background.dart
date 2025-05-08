import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  const VideoBackground({super.key});

  @override
  VideoBackgroundState createState() => VideoBackgroundState(); // Используем публичный класс
}

class VideoBackgroundState extends State<VideoBackground> { // Убрали _ из имени
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Инициализация видео
    _controller = VideoPlayerController.asset('assets/videos/clouds.mp4')
      ..initialize().then((_) {
        // Убедимся, что виджет перерисовывается после инициализации
        setState(() {});
        // Зацикливаем видео
        _controller.setLooping(true);
        // Запускаем воспроизведение
        _controller.play();
      });
  }

  @override
  void dispose() {
    // Освобождаем ресурсы при удалении виджета
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      // Показываем заглушку, пока видео загружается
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover, // Растягиваем видео на весь экран
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}