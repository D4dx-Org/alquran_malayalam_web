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
  RxBool isVisible = false.obs;
  RxDouble playbackSpeed = 1.0.obs;

  RxList<String> surahAudioUrls = <String>[].obs;
  RxInt currentAudioIndex = 0.obs;
  RxBool isPlayingSurah = false.obs;
  RxInt currentSurahNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.positionStream.listen((p) => position.value = p);
    _audioPlayer.durationStream
        .listen((d) => duration.value = d ?? Duration.zero);
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        if (isPlayingSurah.value) {
          playNextAyahInSurah();
        } else {
          playNextAyah();
        }
      }
    });
  }

  Future<void> playAyah(String verseKey) async {
    try {
      isPlayingSurah.value = false;
      showPlayer();
      currentAyah.value = verseKey;
      String? audioUrl = await _quranComService.fetchAyahAudio(verseKey);
      if (audioUrl != null) {
        if (!audioUrl.startsWith('http')) {
          audioUrl = 'https://audio.qurancdn.com/$audioUrl';
        }
        await _audioPlayer.stop(); // Stop any current playback
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
      } else {
        Get.snackbar('Audio Unavailable', 'No audio found for this verse.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: $e');
      hidePlayer(); // Hide the player if an error occurs
    }
  }

  Future<void> playNextAyah() async {
    List<String> parts = currentAyah.value.split(':');
    if (parts.length == 2) {
      int surahNumber = int.parse(parts[0]);
      int ayahNumber = int.parse(parts[1]);
      String nextAyahKey = '$surahNumber:${ayahNumber + 1}';
      await playAyah(nextAyahKey);
    }
  }

  Future<void> playPreviousAyah() async {
    List<String> parts = currentAyah.value.split(':');
    if (parts.length == 2) {
      int surahNumber = int.parse(parts[0]);
      int ayahNumber = int.parse(parts[1]);
      if (ayahNumber > 1) {
        String previousAyahKey = '$surahNumber:${ayahNumber - 1}';
        await playAyah(previousAyahKey);
      }
    }
  }

  Future<void> fetchSurahAudio(int surahNumber) async {
    try {
      currentSurahNumber.value = surahNumber;
      surahAudioUrls.value =
          await _quranComService.fetchSurahAudio(surahNumber);
      currentAudioIndex.value = 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch surah audio: $e');
    }
  }

  Future<void> playSurah(int surahNumber) async {
    await fetchSurahAudio(surahNumber);
    if (surahAudioUrls.isNotEmpty) {
      isPlayingSurah.value = true;
      showPlayer();
      await playNextAyahInSurah();
    }
  }

  Future<void> playNextAyahInSurah() async {
    if (currentAudioIndex.value < surahAudioUrls.length) {
      String audioUrl = surahAudioUrls[currentAudioIndex.value];
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      currentAyah.value =
          '${currentSurahNumber.value}:${currentAudioIndex.value + 1}';
      currentAudioIndex.value++;
    } else {
      stopSurahPlayback();
    }
  }

  Future<void> changeSurah(int newSurahNumber) async {
    bool wasPlaying = isPlaying.value;
    bool wasSurahPlaying = isPlayingSurah.value;

    if (isPlaying.value || isPlayingSurah.value) {
      await _audioPlayer.stop();
    }

    await fetchSurahAudio(newSurahNumber);

    if (wasSurahPlaying && wasPlaying) {
      // If a surah was playing and audio was active, resume playing the new surah
      await playSurah(newSurahNumber);
    } else if (wasPlaying) {
      // If single ayah was playing, play the first ayah of the new surah
      await playAyah('$newSurahNumber:1');
    } else {
      // If nothing was playing, don't start playback
      currentAyah.value = '$newSurahNumber:1';
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

  void toggleVisibility() {
    isVisible.toggle();
  }

  void showPlayer() {
    isVisible.value = true;
  }

  Future<void> hidePlayer() async {
    isVisible.value = false;
    await _audioPlayer.stop();
    position.value = Duration.zero;
    duration.value = Duration.zero;
    currentAyah.value = '';
    isPlayingSurah.value = false;
    currentAudioIndex.value = 0;
  }

  void stopSurahPlayback() {
    isPlayingSurah.value = false;
    currentAudioIndex.value = 0;
    if (isPlaying.value) {
      _audioPlayer.stop();
    }
  }

  void playPreviousAyahInSurah() {
    if (currentAudioIndex.value > 1) {
      currentAudioIndex.value -= 2;
      playNextAyahInSurah();
    }
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    _audioPlayer.setSpeed(speed);
  }

  Future<void> playSpecificAyah(int surahNumber, int ayahNumber) async {
    String verseKey = '$surahNumber:$ayahNumber';
    await playAyah(verseKey);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
