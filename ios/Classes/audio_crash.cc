#include <cstdint>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int audio_convert(const char *input, const char *output);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _audio_convert(const char *input, const char *output) {
  return audio_convert(input, output);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int audio_volume(const char *input, const char *output, double volume);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _audio_volume(const char *input, const char *output, double volume) {
  return audio_volume(input, output, volume);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int64_t media_duration(const char *input);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int64_t _media_duration(const char *input) {
  return media_duration(input);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int audio_cut(const char *input, const char *output, double start_ms, double end_ms);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _audio_cut(const char *input, const char *output, double start_ms, double end_ms) {
  return audio_cut(input, output, start_ms, end_ms);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
float sentence_bleu(int16_t *reference, int reference_size, int16_t *hypothesis, int hypothesis_size);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
float _sentence_bleu(int16_t *reference, int reference_size, int16_t *hypothesis, int hypothesis_size) {
  return sentence_bleu(reference, reference_size, hypothesis, hypothesis_size);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int to_thumbnail(const char *input_path, const char **output_paths, double *tms, int tms_len, int width, int height, double threshold);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _to_thumbnail(const char *input_path, const char **output_paths, double *tms, int tms_len, int width, int height, double threshold) {
  return to_thumbnail(input_path, output_paths, tms, tms_len, width, height, threshold);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int the_edit_pass(int *reference, int reference_size, int *hypothesis, int hypothesis_size, int *edit_pass_result);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _the_edit_pass(int *reference, int reference_size, int *hypothesis, int hypothesis_size, int *edit_pass_result) {
  return the_edit_pass(reference, reference_size, hypothesis, hypothesis_size, edit_pass_result);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int audio_gradient(const char *input, const char *output, const char *func);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int _audio_gradient(const char *input, const char *output, const char *func) {
  return audio_gradient(input, output, func);
}
