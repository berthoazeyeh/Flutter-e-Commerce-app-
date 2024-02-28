class CategorieProduit {
  final String iud;
  final String code;
  final String nom;
  final String imageUrl; // Chemin de l'image de la catégorie

  CategorieProduit({
    required this.code,
    required this.nom,
    required this.iud,
    required this.imageUrl,
  });

  factory CategorieProduit.fromJson(Map<String, dynamic> json) {
    return CategorieProduit(
      iud: json['iud'],
      code: json['code'],
      nom: json['nom'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iud': iud,
      'code': code,
      'nom': nom,
      'imageUrl': imageUrl,
    };
  }
}
