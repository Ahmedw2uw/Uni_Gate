String formatPrice(double p) => '\$${p.toStringAsFixed(2)}';

String truncate(String s, [int len = 30]) =>
    s.length <= len ? s : s.substring(0, len) + '...';
