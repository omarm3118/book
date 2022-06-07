import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/dashboard_components.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = BlocProvider.of<LayoutCubit>(context);

    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        if (LayoutCubit.getUser != null) {
          if (LayoutCubit.getUser!.favoriteFields.isEmpty) {
            Navigator.pushReplacementNamed(context, chooseFavoriteFieldsRoute);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            successWidget: (context) =>
                layoutCubit.layoutScreens[layoutCubit.navBarIndex],
            fallbackWidget: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            //Todo check if books null of user null
            condition: state is! GetUserLoadingState &&
                state is! GetBooksLoadingState &&
                LayoutCubit.getUser != null &&
                LayoutCubit.getCubit(context).books.isNotEmpty,
          ),
          bottomNavigationBar: navigationBar(layoutCubit,context),
        );
      },
    );
  }
}
