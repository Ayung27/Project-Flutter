/// Alamat pengiriman tersimpan.
class Alamat {
  final String label;
  final String detail;
  final String icon;

  const Alamat({
    required this.label,
    required this.detail,
    this.icon = 'location_on',
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'detail': detail,
        'icon': icon,
      };

  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      label: json['label'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      icon: json['icon'] as String? ?? 'location_on',
    );
  }
}
