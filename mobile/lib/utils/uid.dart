String uid() =>
    '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-${(DateTime.now().microsecondsSinceEpoch % 1000000).toRadixString(36)}';

