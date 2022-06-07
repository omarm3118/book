import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/search_components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit =
        BlocProvider.of<LayoutCubit>(context); //LayoutCubit.getCubit(context);
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return AnnotatedRegion(
      value: statusBarColor,
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (_, state) {
          if(state is ExitSearchState) {
            searchController.clear();
          }
          return SafeArea(
            child: ConditionalBuilder(
              successWidget: (_) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchBar(context, cubit, searchController),
                      const SizedBox(
                        height: 20,
                      ),
                      firstTitle(context),
                      const SizedBox(
                        height: 8,
                      ),
                      tags(context),
                      const SizedBox(
                        height: 32,
                      ),
                      secondTitle(context,cubit.books),
                      const SizedBox(
                        height: 12,
                      ),
                      suggestions(cubit.books),
                    ],
                  ),
                ),
              ),
              fallbackWidget: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchBar(
                    context,
                    cubit,
                    searchController,
                  ),
                  Flexible(
                    child: searchList(
                        books: cubit.books, query: searchController.text),
                  ),
                ],
              ),
              condition: !cubit.isSearch,
            ),
          );
        },
      ),
    );
  }
}
