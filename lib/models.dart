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

  Lloc(
      {this.id = "",
      required this.nombre,
      required this.categoria,
      required this.desc,
      required this.fechaPubl,
      required this.autor,
      required this.correo,
      required this.urlImagen,
      required this.ubicacion});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'desc': desc,
        'fechaPubl': fechaPubl,
        'autor': autor,
        'correo': correo,
        'urlImagen': urlImagen,
        'ubicacion': ubicacion
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
      ubicacion: json['ubicacion']);
}
