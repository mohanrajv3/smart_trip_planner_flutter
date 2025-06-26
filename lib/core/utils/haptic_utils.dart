import 'package:flutter_vibrate/flutter_vibrate.dart';

class HapticUtils {
  static Future<void> lightImpact() async {
    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }

  static Future<void> mediumImpact() async {
    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  static Future<void> selection() async {
    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }
}
