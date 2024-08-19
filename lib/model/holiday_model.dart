class Holiday {
  final String name;
  final String date;
  final String day;
  final String type;

  Holiday({
    required this.name,
    required this.date,
    required this.day,
    required this.type,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'],
      date: json['date'],
      day: json['day'],
      type: json['type'],
    );
  }
}
