class Reason {
  final int number;
  final String text;
  final bool special;

  const Reason({
    required this.number,
    required this.text,
    this.special = false,
  });

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      number: json['number'] as int,
      text: json['text'] as String,
      special: json['special'] as bool? ?? false,
    );
  }
}

class ReasonsData {
  final String title;
  final String subtitle;
  final List<Reason> reasons;

  const ReasonsData({
    required this.title,
    required this.subtitle,
    required this.reasons,
  });

  factory ReasonsData.fromJson(Map<String, dynamic> json) {
    final list = (json['reasons'] as List<dynamic>)
        .map((e) => Reason.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return ReasonsData(
      title: json['title'] as String? ?? '100 Reasons',
      subtitle: json['subtitle'] as String? ?? '',
      reasons: list,
    );
  }
}
