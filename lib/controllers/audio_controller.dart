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
    _audioPlayer.durationStream.listen((d) => duration.value = d ?? Duration.zero);  
    _audioPlayer.playerStateStream.listen((state) {  
      isPlaying.value = state.playing;  
    });  
  }  

  Future<void> playAyah(int ayahId) async {  
    try {  
      currentAyah.value = ayahId.toString();  
      String audioUrl = await _quranComService.fetchAyahAudio(ayahId);  
      await _audioPlayer.setUrl(audioUrl);  
      await _audioPlayer.play();  
    } catch (e) {  
      print('Error playing ayah: $e');  
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