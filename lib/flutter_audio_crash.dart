import 'dart:ffi';

import 'dart:io';

import 'package:flutter_c_ptr/flutter_c_ptr.dart';

final DynamicLibrary lib = Platform.isAndroid
    ? DynamicLibrary.open("libaudio_crash.so")
    : DynamicLibrary.open("libaudio_crash.dylib");

final int Function(int, int) audioConvertFfi = 
    lib
        .lookup<NativeFunction<Int32 Function(Int64, Int64)>>("audio_convert")
        .asFunction();

final int Function(int, int, double) audioVolumeFfi = 
    lib
        .lookup<NativeFunction<Int32 Function(Int64, Int64, Double)>>("audio_volume")
        .asFunction();

final int Function(int) mediaDurationFfi = 
    lib
        .lookup<NativeFunction<Int64 Function(Int64)>>("media_duration")
        .asFunction();

final int Function(int, int, double, double) audioCutFfi = 
    lib
        .lookup<NativeFunction<Int32 Function(Int64, Int64, Double, Double)>>("audio_cut")
        .asFunction();

final double Function(int, int, int, int) sentenceBleuFfi = 
    lib
        .lookup<NativeFunction<Float Function(Int64, Int32, Int64, Int32)>>("sentence_bleu")
        .asFunction();

final int Function(int, int, int, int, int, int, double) videoThumbnailFfi = 
    lib
        .lookup<NativeFunction<Int32 Function(Int64, Int64, Int64, Int32, Int32, Int32, Double)>>("to_thumbnail")
        .asFunction();

final int Function(int, int, int, int, int) editPassFfi = 
    lib
        .lookup<NativeFunction<Int32 Function(Int64, Int32, Int64, Int32, Int64)>>("the_edit_pass")
        .asFunction();

String toM4A(String input, String output) {
  Int8P inputFfi = Int8P.fromString(input);
  Int8P outputFfi = Int8P.fromString(output);
  int ok = audioConvertFfi(inputFfi.address, outputFfi.address);
  inputFfi?.dispose();
  outputFfi?.dispose();
  print("In AudioConvert ok ... $ok");

  if (ok == 0) {
    return output;
  }
  else {
    return input;
  }
}

String toVolume(String input, String output, {double volume=-10}) {
  // volume: [-0, -91]
  Int8P inputFfi = Int8P.fromString(input);
  Int8P outputFfi = Int8P.fromString(output);
  int ok = audioVolumeFfi(inputFfi.address, outputFfi.address, volume);
  inputFfi?.dispose();
  outputFfi?.dispose();
  print("In AudioVolume ok ... $ok");
  
  if (ok == 0) {
    return output;
  }
  else {
    return input;
  }
}

int toDuration(String input) {
  Int8P inputFfi = Int8P.fromString(input);
  int duration = mediaDurationFfi(inputFfi.address);
  inputFfi?.dispose();
  print("In MediaDuration duration ... $duration");
  return duration > 0 ? duration : 0;
}

String toCut(String input, double startMs, double endMs, String output) {
  Int8P inputFfi = Int8P.fromString(input);
  Int8P outputFfi = Int8P.fromString(output);
  int ok = audioCutFfi(inputFfi.address, outputFfi.address, startMs, endMs);
  inputFfi?.dispose();
  outputFfi?.dispose();
  print("In AudioCut ok ... $ok");

  if (ok == 0) {
    return output;
  }
  else {
    return input;
  }
}

double sentenceSimilarity(String sentence1, String sentence2) {
  Map<String, int> idMap = {};
  int id = 0;
  for (int idx = 0; idx < sentence1.length; ++idx) {
    String char = sentence1[idx];
    if (!idMap.containsKey(char)) {
      // Not Found
      idMap[char] = ++id;
    }
  }

  for (int idx = 0; idx < sentence2.length; ++idx) {
    String char = sentence2[idx];
    if (!idMap.containsKey(char)) {
      // Not Found
      idMap[char] = ++id;
    }
  }

  List<int> ids1 = [];
  for (int idx = 0; idx < sentence1.length; ++idx) {
    ids1.add(idMap[sentence1[idx]]);
  }

  List<int> ids2 = [];
  for (int idx = 0; idx < sentence2.length; ++idx) {
    ids2.add(idMap[sentence2[idx]]);
  }

  Int16P p1 = Int16P.fromList(ids1);
  Int16P p2 = Int16P.fromList(ids2);
  double score = sentenceBleuFfi(p1.address, p1.length, p2.address, p2.length);
  p1.dispose();
  p2.dispose();

  print("In SentenceSimilarity score ... $score");
  return score;
}

List<String> toThumbnail(String input, List<double> timesInMs, List<String> outputs, {int width=0, int height=0, double threshold=double.infinity}) {
  List<Int8P> outputPtrs = [];
  List<int> outputAddress = [];

  for (int idx = 0; idx < outputs.length; ++idx) {
    String output = outputs[idx];
    Int8P outputPtr = Int8P.fromString(output);
    outputPtrs.add(outputPtr);
    outputAddress.add(outputPtr.address);
  }
  Int8P inputPtr = Int8P.fromString(input);
  Int64P outputAddressPtr = Int64P.fromList(outputAddress);
  DoubleP timesInMsPtr = DoubleP.fromList(timesInMs);

  int ok = videoThumbnailFfi(inputPtr.address, outputAddressPtr.address, timesInMsPtr.address, timesInMs.length, width, height, threshold);

  for (var outputPtr in outputPtrs) {
    outputPtr.dispose();
  }
  inputPtr.dispose();
  outputAddressPtr.dispose();
  timesInMsPtr.dispose();

  print('In toThumbnail, ok ... $ok');
  return outputs;
}

List<int> editPass(String groudTruth, String predict) {
  Map<String, int> idMap = {};
  int id = 0;
  for (int idx = 0; idx < groudTruth.length; ++idx) {
    String char = groudTruth[idx];
    if (!idMap.containsKey(char)) {
      // Not Found
      idMap[char] = ++id;
    }
  }

  for (int idx = 0; idx < predict.length; ++idx) {
    String char = predict[idx];
    if (!idMap.containsKey(char)) {
      // Not Found
      idMap[char] = ++id;
    }
  }

  List<int> ids1 = [];
  for (int idx = 0; idx < groudTruth.length; ++idx) {
    ids1.add(idMap[groudTruth[idx]]);
  }

  List<int> ids2 = [];
  for (int idx = 0; idx < predict.length; ++idx) {
    ids2.add(idMap[predict[idx]]);
  }

  Int32P p1 = Int32P.fromList(ids1);
  Int32P p2 = Int32P.fromList(ids2);
  Int32P res = Int32P();

  res.resize(3 * (groudTruth.length + predict.length));
  int size = editPassFfi(p1.address, p1.length, p2.address, p2.length, res.address);
  List<int> resList = res.list;
  List<int> pass = List<int>(size);
  pass.setAll(0, resList.sublist(0, size));

  p1.dispose();
  p2.dispose();
  res.dispose();

  print("In EditPass size ... $size");
  return pass;
}
