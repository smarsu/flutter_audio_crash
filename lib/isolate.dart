import 'dart:io';
import 'dart:isolate';

import 'package:flutter_audio_crash/flutter_audio_crash.dart';
import 'package:path_provider/path_provider.dart';

Future<String> rootof({String path}) async {
  var dir = (await getApplicationDocumentsDirectory()).path;
  return '$dir/smarsu/flutter_audio_crash/$path';
}

class AudioConvert {
  /* Public */
  static Future<void> initialized = _init();

  static Future<String> toM4AAsync(String input, {String output, String extend='mp4'}) async {
    await initialized;

    if (output == null) {
      output = await rootof(path: '${DateTime.now().microsecondsSinceEpoch}.$extend');
    }

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'toM4a', input, output, extend]);
    return await receivePort.first;
  }

  static Future<String> toVolumeAsync(String input, {String output, double volume=-10, String extend='mp4'}) async {
    await initialized;

    if (output == null) {
      output = await rootof(path: '${DateTime.now().microsecondsSinceEpoch}.$extend');
    }

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'toVolume', input, output, volume, extend]);
    return await receivePort.first;
  }

  // threshold [0 - double.infinity]: 越低 图片定位越准
  static Future<List<String>> toThumbnailAsync(String input, List<double> timesInMs, {List<String> outputs, int width=0, int height=0, double threshold=double.infinity}) async {
    await initialized;

    if (outputs == null) {
      outputs = [];
      for (var time in timesInMs) {
        String output = await rootof(path: '${DateTime.now().microsecondsSinceEpoch}_$time.jpg');
        outputs.add(output);
      }
    }

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'toThumbnail', input, timesInMs, outputs, width, height, threshold]);
    return await receivePort.first;
  }

  static Future<String> toCutAsync(String input, double startMs, double endMs, {String output, String extend='mp4'}) async {
    await initialized;

    if (output == null) {
      output = await rootof(path: '${DateTime.now().microsecondsSinceEpoch}.$extend');
    }

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'toCut', input, startMs, endMs, output, extend]);
    return await receivePort.first;
  }

  static Future<int> toDurationAsync(String input) async {
    await initialized;

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'toDuration', input]);
    return await receivePort.first;
  }

  static Future<double> sentenceSimilarityAsync(String sentence1, String sentence2) async {
    await initialized;

    ReceivePort receivePort = ReceivePort();
    _sendPort.send([receivePort.sendPort, 'sentenceSimilarity', sentence1, sentence2]);
    return await receivePort.first;
  }

  /* Private */
  static SendPort _sendPort;
  static Future<void> _init() async {
    String dir = await rootof(path: '');
    Directory directory = Directory(dir);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create(recursive: true);

    final receivePort = ReceivePort();
    await Isolate.spawn(_entryFunction, receivePort.sendPort);
    _sendPort = await receivePort.first;

    print('AudioConvert Init Success!');
  }
 
  static void _entryFunction(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (var msg in receivePort) {
      SendPort callbackPort = msg[0];
      String mod = msg[1];

      if (mod == 'toM4a') {
        String result = toM4A(msg[2], msg[3]);
        callbackPort.send(result);
      }
      else if (mod == 'toVolume') {
        String result = toVolume(msg[2], msg[3], volume: msg[4]);
        callbackPort.send(result);
      }
      else if (mod == 'toCut') {
        String result = toCut(msg[2], msg[3], msg[4], msg[5]);
        callbackPort.send(result);
      }
      else if (mod == 'toThumbnail') {
        List<String> result = toThumbnail(msg[2], msg[3], msg[4], width: msg[5], height: msg[6], threshold: msg[7]);
        callbackPort.send(result);
      }
      else if (mod == 'toDuration') {
        int result = toDuration(msg[2]);
        callbackPort.send(result);
      }
      else if (mod == 'sentenceSimilarity') {
        double result = sentenceSimilarity(msg[2], msg[3]);
        callbackPort.send(result);
      }
    }
  }
}
