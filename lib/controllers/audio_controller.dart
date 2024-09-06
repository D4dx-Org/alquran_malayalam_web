import 'package:alquran_web/services/quran_com_services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final QuranComService _quranComService = QuranComService();

  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;
  RxBool isPlaying = false.obs;
  RxString currentAyah = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.positionStream.listen((p) => position.value = p);
    _audioPlayer.durationStream
        .listen((d) => duration.value = d ?? Duration.zero);
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> playAyah(String verseKey) async {
    try {
      currentAyah.value = verseKey;
      String? audioUrl = await _quranComService.fetchAyahAudio(verseKey);
      if (audioUrl != null) {
        // Check if the audioUrl is a relative path
        if (!audioUrl.startsWith('http')) {
          // Prepend the base URL if necessary
          audioUrl = 'https://audio.qurancdn.com/' + audioUrl;
        }
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
      } else {
        print('No audio URL available for verse $verseKey');
        // You might want to show a snackbar or some UI feedback here
        Get.snackbar('Audio Unavailable', 'No audio found for this verse.');
      }
    } catch (e) {
      print('Error playing ayah: $e');
      // Show an error message to the user
      Get.snackbar('Error', 'Failed to play audio: $e');
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
