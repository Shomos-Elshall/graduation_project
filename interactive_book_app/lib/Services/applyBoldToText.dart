String applyBoldToText(String fullText, String selectedPart) {
  if (selectedPart.isEmpty) return fullText;
  // استبدال النص المختار بنسخة محاطة بـ <b> </b>
  return fullText.replaceFirst(selectedPart, '<b>$selectedPart</b>');
}