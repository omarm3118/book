class FavoriteFieldsModel {
  late String name;
   String? photo;
  late  bool isSelected;
  bool isPressed=false;

   FavoriteFieldsModel({
    required this.name,
    this.photo,
    required this.isSelected,
     this.isPressed=false,
  });
}
