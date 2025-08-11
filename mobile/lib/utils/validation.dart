class Validators {
  static String? nonEmpty(String? v, {String label = 'Field'}) => (v == null || v.trim().isEmpty) ? 'Enter $label' : null;
  static String? strongPassword(String? v) {
    final s = v?.trim() ?? '';
    if (s.length < 6) return 'Use at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(s)) return 'Include at least 1 uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(s)) return 'Include at least 1 number';
    return null;
  }
}

