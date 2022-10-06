import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/culture_courses/controller/culture_courses_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/culture_courses_components.dart';

class CultureCoursesScreen extends StatelessWidget {
  const CultureCoursesScreen({Key? key, required this.bookScreenContext})
      : super(key: key);
  final BuildContext bookScreenContext;

  @override
  Widget build(BuildContext context) {
    CultureCoursesCubit cubit = BlocProvider.of(context);
    onInit(cubit);
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return Scaffold(
      body: AnnotatedRegion(
        value: statusBarColor,
        child: Padding(
          padding: const EdgeInsets.only(
            right: defaultPadding,
            left: defaultPadding,
            top: 85,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                title(context),
                const SizedBox(
                  height: 10,
                ),
                //Todo convert Icon when press
                Expanded(
                  child: BlocBuilder<CultureCoursesCubit, CultureCoursesState>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        successWidget: (_) => itemsBuilder(
                          cubit.courses,
                          bookScreenContext,
                        ),
                        fallbackWidget: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        condition: state is! GetCoursesLoadingState &&
                            cubit.courses.isNotEmpty,
                      );
                    },
                  ),
                ),


                // const Spacer(),
                // nextButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onInit(CultureCoursesCubit cubit) async {
    await cubit.getCourses();
  }
}
