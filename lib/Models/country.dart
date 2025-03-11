class Country {
  final String name;
  final String code;
  final String flag;
  final String dialCode;

  Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.dialCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String dialCode = '';
    if (json['idd'] != null && 
        json['idd']['root'] != null && 
        json['idd']['suffixes'] != null && 
        json['idd']['suffixes'].isNotEmpty) {
      dialCode = '${json['idd']['root']}${json['idd']['suffixes'][0]}';
    }

    return Country(
      name: json['name']['common'],
      code: json['cca2'],
      flag: json['flag'],
      dialCode: dialCode,
    );
  }
}