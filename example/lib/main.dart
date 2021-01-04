import 'package:flutter/material.dart';
import 'package:flutter_audio_crash/flutter_audio_crash.dart';
import 'package:flutter_audio_crash/isolate.dart';

import 'package:flutter_smarsu_package/flutter_smarsu_package.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  /// pos 为当前时间戳(ms), size为audio总时长(ms)
  String func = 
"""
double main(double pos, double size) {
  if (pos < 0.3 * size) {
    return 0.5;
  }
  else if (pos < 0.7 * size) {
    return 1;
  }
  else {
    return 0.5;
  }
}
""";

  @override
  void initState() {
    super.initState();
    run();
  }

  run() async {
    String cat = await writeAssetToFile('assets/cat.mp4');
    String seeyou = await writeAssetToFile('assets/seeyou.mp4');
    String tian = await writeAssetToFile('assets/tian.m4a');
    // String min16 = await writeAssetToFile('assets/16Min.mp4');
    String output1 = await getApplicationDocumentsPath(filename: 'cat_convert');
    String output2 = await getApplicationDocumentsPath(filename: 'seeyou_convert');
    String output3 = await getApplicationDocumentsPath(filename: 'cat_volume');
    String output4 = await getApplicationDocumentsPath(filename: 'seeyou_volume');
    String output5 = await getApplicationDocumentsPath(filename: 'cat_cut');
    String output6 = await getApplicationDocumentsPath(filename: 'seeyou_cut');
    String output7 = await getApplicationDocumentsPath(filename: 'tian_convert');
    String output8 = await getApplicationDocumentsPath(filename: 'tian_volume');
    String output9 = await getApplicationDocumentsPath(filename: 'tian_cut');
    String output10 = await getApplicationDocumentsPath(filename: 'cat_gradient');
    String output11 = await getApplicationDocumentsPath(filename: 'seeyou_gradient');
    String output12 = await getApplicationDocumentsPath(filename: 'tian_gradient');
    while (true) {
      await AudioConvert.toM4AAsync(cat, output: output1);
      await AudioConvert.toM4AAsync(seeyou, output: output2);
      await AudioConvert.toM4AAsync(tian, output: output7);

      await AudioConvert.toVolumeAsync(cat, output: output3);
      await AudioConvert.toVolumeAsync(seeyou, output: output4);
      await AudioConvert.toVolumeAsync(tian, output: output8);

      await AudioConvert.toDurationAsync(cat);
      await AudioConvert.toDurationAsync(seeyou);
      await AudioConvert.toDurationAsync(tian);

      await AudioConvert.toCutAsync(cat, 1000, 2000, output: output5);
      await AudioConvert.toCutAsync(seeyou, 1000, 2000, output: output6);
      await AudioConvert.toCutAsync(tian, 1000, 2000, output: output9);

      await AudioConvert.sentenceSimilarityAsync("我是范峰源", "我是岱宗");

      await AudioConvert.editPassAsync("我是范峰源", "我是岱宗");

      // await AudioConvert.toThumbnailAsync(min16, [0, 300], outputs: [output10, output11]);
      print('$func');
      await AudioConvert.toGradientAsync(cat, func, output: output10);
      await AudioConvert.toGradientAsync(seeyou, func, output: output11);
      await AudioConvert.toGradientAsync(tian, func, output: output12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
