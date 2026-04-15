class Verb {
  final int? id;
  final String baseForm;
  final String pastSimple;
  final String pastParticiple;
  final String? meaning;
  final String? example;
  final String? notes;
  final bool isFavorite;
  final bool isIrregular;
  final DateTime createdAt;

  Verb({
    this.id,
    required this.baseForm,
    required this.pastSimple,
    required this.pastParticiple,
    this.meaning,
    this.example,
    this.notes,
    this.isFavorite = false,
    this.isIrregular = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'base_form': baseForm.trim().toLowerCase(),
      'past_simple': pastSimple.trim().toLowerCase(),
      'past_participle': pastParticiple.trim().toLowerCase(),
      'meaning': meaning?.trim(),
      'example': example?.trim(),
      'notes': notes?.trim(),
      'is_favorite': isFavorite ? 1 : 0,
      'is_irregular': isIrregular ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Verb.fromMap(Map<String, dynamic> map) {
    return Verb(
      id: map['id'],
      baseForm: map['base_form'],
      pastSimple: map['past_simple'],
      pastParticiple: map['past_participle'],
      meaning: map['meaning'],
      example: map['example'],
      notes: map['notes'],
      isFavorite: map['is_favorite'] == 1,
      isIrregular: map['is_irregular'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Verb copyWith({
    int? id,
    String? baseForm,
    String? pastSimple,
    String? pastParticiple,
    String? meaning,
    String? example,
    String? notes,
    bool? isFavorite,
    bool? isIrregular,
    DateTime? createdAt,
  }) {
    return Verb(
      id: id ?? this.id,
      baseForm: baseForm ?? this.baseForm,
      pastSimple: pastSimple ?? this.pastSimple,
      pastParticiple: pastParticiple ?? this.pastParticiple,
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      isIrregular: isIrregular ?? this.isIrregular,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
