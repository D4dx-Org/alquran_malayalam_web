// ignore_for_file: non_constant_identifier_names

import 'package:alquran_web/services/quran_com_services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final QuranComService _quranComService = QuranComService();

  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;
  RxBool isPlaying = false.obs;
  RxString currentAya = ''.obs;
  RxBool isVisible = false.obs;
  RxDouble playbackSpeed = 1.0.obs;

  RxList<String> surahAudioUrls = <String>[].obs;
  RxInt currentAudioIndex = 0.obs;
  RxBool isPlayingSurah = false.obs;
  RxInt currentSurahNumber = 0.obs;
  RxBool shouldPlayNextAya = true.obs; // Add this line
  RxInt currentRecitationId = 7.obs; // Add this line for dynamic recitation ID

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
          playNextAyaInSurah();
        } else {
          playNextAya();
        }
      }
    });
  }

  Future<void> playAya(String verseKey) async {
    try {
      isPlayingSurah.value = false;
      showPlayer();
      currentAya.value = verseKey;
      String? audioUrl = await _quranComService.fetchAyaAudio(verseKey,
          recitationId: currentRecitationId.value); // Pass recitationId
      if (audioUrl != null) {
        if (!audioUrl.startsWith('http')) {
          audioUrl = 'https://audio.qurancdn.com/$audioUrl';
        }
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

  Future<void> playNextAya() async {
    if (shouldPlayNextAya.value) {
      List<String> parts = currentAya.value.split(':');
      if (parts.length == 2) {
        int surahNumber = int.parse(parts[0]);
        int AyaNumber = int.parse(parts[1]);
        String nextAyaKey = '$surahNumber:${AyaNumber + 1}';
        await playAya(nextAyaKey);
      }
    }
  }

  Future<void> playPreviousAya() async {
    List<String> parts = currentAya.value.split(':');
    if (parts.length == 2) {
      int surahNumber = int.parse(parts[0]);
      int AyaNumber = int.parse(parts[1]);
      if (AyaNumber > 1) {
        String previousAyaKey = '$surahNumber:${AyaNumber - 1}';
        await playAya(previousAyaKey);
      }
    }
  }

  Future<void> fetchSurahAudio(int surahNumber) async {
    try {
      currentSurahNumber.value = surahNumber;
      surahAudioUrls.value = await _quranComService.fetchSurahAudio(surahNumber,
          recitationId: currentRecitationId.value); // Pass recitationId
      currentAudioIndex.value = 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch surah audio: $e');
    }
  }

  Future<void> playSurah(int surahNumber) async {
    // Step 1: Play Bismillah audio first
    String? bismillahAudioUrl = await _quranComService.fetchBismiAudio(
        recitationId: currentRecitationId.value); // Fetch Bismillah audio

    if (bismillahAudioUrl != null) {
      isPlayingSurah.value = true;
      showPlayer();
      await _audioPlayer.setUrl(bismillahAudioUrl);
      await _audioPlayer.play(); // Play Bismillah audio

      // Step 2: Wait for Bismillah audio to finish
      await _audioPlayer.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed);

      // Step 3: Now fetch and play the surah audio
      await fetchSurahAudio(surahNumber);
      if (surahAudioUrls.isNotEmpty) {
        await playNextAyaInSurah(); // Start playing the surah
      }
    } else {
      Get.snackbar('Audio Unavailable', 'No audio found for Bismillah.');
    }
  }

  Future<void> playNextAyaInSurah() async {
    if (shouldPlayNextAya.value &&
        currentAudioIndex.value < surahAudioUrls.length) {
      String audioUrl = surahAudioUrls[currentAudioIndex.value];
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      currentAya.value =
          '${currentSurahNumber.value}:${currentAudioIndex.value + 1}';
      currentAudioIndex.value++;
    } else {
      // If the current surah has finished playing, play the next surah
      await playNextSurah();
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
      // If single Aya was playing, play the first Aya of the new surah
      await playAya('$newSurahNumber:1');
    } else {
      // If nothing was playing, don't start playback
      currentAya.value = '$newSurahNumber:1';
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
    currentAya.value = '';
    isPlayingSurah.value = false;
    isPlaying.value = false; // Add this line
    currentAudioIndex.value = 0;
  }

  void stopSurahPlayback() {
    isPlayingSurah.value = false;
    currentAudioIndex.value = 0;
    if (isPlaying.value) {
      _audioPlayer.stop();
    }
  }

  void playPreviousAyaInSurah() {
    if (currentAudioIndex.value > 1) {
      currentAudioIndex.value -= 2;
      playNextAyaInSurah();
    }
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    _audioPlayer.setSpeed(speed);
  }

  Future<void> playSpecificAya(int surahNumber, int AyaNumber) async {
    String verseKey = '$surahNumber:$AyaNumber';
    await playAya(verseKey);
  }

  void changeRecitation(int newRecitationId) {
    currentRecitationId.value = newRecitationId; // Update the recitation ID
  }

  Future<void> playNextSurah() async {
    int nextSurahNumber = currentSurahNumber.value + 1;
    // Check if the next surah number is valid (1 to 114)
    if (nextSurahNumber <= 114) {
      await playSurah(nextSurahNumber);
    } else {
      Get.snackbar('End of Quran', 'You have reached the end of the Quran.');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
