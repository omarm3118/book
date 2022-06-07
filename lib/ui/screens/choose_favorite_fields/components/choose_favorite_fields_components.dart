import 'package:book/ui/screens/choose_favorite_fields/controller/choose_favorite_fields_cubit.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../widgets/default_button.dart';
import '../model/favorite_fields_model.dart';

Text title(BuildContext context) {
  return Text(
    "اختر المجالات المفضلة",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

Text subTitle(BuildContext context) {
  return Text(
    'خصص التطبيق حسب المجالات المهتم بها',
    style: Theme.of(context).textTheme.labelLarge,
  );
}

ListView itemsBuilder(items) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        itemField(context, items[index]),
    separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 18),
    itemCount: items.length,
  );
}

BlocBuilder itemField(BuildContext context, FavoriteFieldsModel item) {
  return BlocBuilder<ChooseFavoriteFieldsCubit, ChooseFavoriteFieldsState>(
    builder: (context, state) {
      return Row(
        children: [
          Container(
            width: 68.0,
            height: 68.0,
            decoration: BoxDecoration(
              color: const Color(0xffd1cde9),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(
            width: 14.5,
          ),
          Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          //Todo circle or rounded rectangle
          Stack(
            alignment: Alignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  onPrimary:
                      item.isSelected ? Colors.white : MyColors.defaultPurple,
                  primary:
                      !item.isSelected ? Colors.white : MyColors.defaultPurple,
                  surfaceTintColor: Colors.white,
                ),
                onPressed: () {
                  BlocProvider.of<ChooseFavoriteFieldsCubit>(context)
                      .addFavoriteFieldToFirestore(
                    userId:
                        RegisterCubit.getUser?.uId ?? LayoutCubit.getUser!.uId,
                    data: item,
                  );
                },
                child: item.isSelected
                    ? const Icon(Icons.check)
                    : const Icon(
                        Icons.add,
                      ),
              ),
              if (item.isPressed)
                const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
            ],
          ),

          const SizedBox(
            width: 2,
          )
        ],
      );
    },
  );
}

nextButton(context) =>
    BlocBuilder<ChooseFavoriteFieldsCubit, ChooseFavoriteFieldsState>(
      builder: (context, state) {
        return DefaultButton(
            label: 'التالي',
            onPressed: LayoutCubit.getUser!.favoriteFields.isEmpty
                ? null
                : () {
                    Navigator.pushReplacementNamed(
                      context,
                      homeRoute,
                    );
                  });
      },
    );
