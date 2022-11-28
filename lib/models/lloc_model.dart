class Lloc {
  String id;
  final String nombre;
  final String categoria;
  final String desc;
  final String fechaPubl;
  final String autor;
  final String correo;
  final String urlImagen;
  final String ubicacion;
  final int likes;

  Lloc(
      {this.id = "",
      required this.nombre,
      required this.categoria,
      required this.desc,
      required this.fechaPubl,
      required this.autor,
      required this.correo,
      required this.urlImagen,
      required this.ubicacion,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'desc': desc,
        'fechaPubl': fechaPubl,
        'autor': autor,
        'correo': correo,
        'urlImagen': urlImagen,
        'ubicacion': ubicacion,
        'likes': likes
      };

  static Lloc fromJson(Map<String, dynamic> json) => Lloc(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      desc: json['desc'],
      fechaPubl: json['fechaPubl'],
      autor: json['autor'],
      correo: json['correo'],
      urlImagen: json['urlImagen'],
      ubicacion: json['ubicacion'],
      likes: json['likes']);
}

class Usuario {
  String uid;
  final String nombre;
  final String correo;
  final String fotoPerfil;
  final String fechaCreacion;
  final List siguiendo;
  final List seguidores;

  Usuario(
      {this.uid = "",
      required this.nombre,
      required this.correo,
      required this.fotoPerfil,
      required this.fechaCreacion,
      required this.siguiendo,
      required this.seguidores});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nombre': nombre,
        'correo': correo,
        'fotoPerfil': fotoPerfil,
        'fechaCreacion': fechaCreacion,
        'siguiendo': siguiendo,
        'seguidores': seguidores
      };

  static Usuario fromJson(Map<String, dynamic> json) => Usuario(
      uid: json['uid'],
      nombre: json['nombre'],
      correo: json['correo'],
      fotoPerfil: json['fotoPerfil'],
      fechaCreacion: json['fechaCreacion'],
      siguiendo: json['siguiendo'],
      seguidores: json['seguidores']);
}

class Reportar {
  String id;
  final String reporta;
  final String reportado;
  final String fechaReport;
  final String lugar;

  Reportar({
    this.id = "",
    required this.reporta,
    required this.reportado,
    required this.fechaReport,
    required this.lugar,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reporta': reporta,
        'reportado': reportado,
        'fechaReport': fechaReport,
        'lugar': lugar
      };

  static Reportar fromJson(Map<String, dynamic> json) => Reportar(
        id: json['id'],
        reporta: json['reporta'],
        reportado: json['reportado'],
        fechaReport: json['fechaReport'],
        lugar: json['lugar'],
      );
}
