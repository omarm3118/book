import 'package:bloc/bloc.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:meta/meta.dart';

import '../model/favorite_fields_model.dart';

part 'choose_favorite_fields_state.dart';

class ChooseFavoriteFieldsCubit extends Cubit<ChooseFavoriteFieldsState> {
  final FirebaseFirestoreRepository firebaseFirestoreRepository;

  ChooseFavoriteFieldsCubit({required this.firebaseFirestoreRepository})
      : super(ChooseFavoriteFieldsInitial());

  final List<FavoriteFieldsModel> items = [
    FavoriteFieldsModel(name: 'أدب بوليسي', isSelected: false),
    FavoriteFieldsModel(name: 'تاريخ إسلامي', isSelected: false),
    FavoriteFieldsModel(name: 'تزكية وعقيدة', isSelected: false),
    FavoriteFieldsModel(name: 'السيرة الذاتية', isSelected: false),
  ];

  Future addFavoriteFieldToFirestore(
      {required String userId, required FavoriteFieldsModel data}) async {
    emit(AddFieldLoadingState());
    data.isPressed = true;
    try {
      data.isSelected
          ? await firebaseFirestoreRepository.removeFavoriteField(
              userId: userId,
              data: data.name,
            )
          : await firebaseFirestoreRepository.addFavoriteField(
              userId: userId, data: data.name);
      data.isPressed = false;
      data.isSelected = !data.isSelected;
      emit(AddFieldSuccessState());
    } catch (e) {
      data.isSelected = !data.isSelected;
      data.isPressed = false;
      emit(AddFieldErrorState());
    }
  }
}
