enum VoiceAction { read, next, previous, navigate, chat, unknown }

class VoiceCommandResult {
  final VoiceAction action;
  final String? target;
  final bool readAfterNavigate;
  final String? answer;

  VoiceCommandResult({
    required this.action,
    this.target,
    this.readAfterNavigate = false,
    this.answer,
  });
}