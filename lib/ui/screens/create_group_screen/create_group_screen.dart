import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/models/user_model.dart';

import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:book/ui/widgets/default_button.dart';
import 'package:book/ui/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  CreateGroupScreen({Key? key, required this.user}) : super(key: key);
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GroupsCubit, GroupsState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          title(context),
                          const SizedBox(
                            height: 50,
                          ),
                          imagePicker(context, cubit),
                          const SizedBox(
                            height: 37,
                          ),
                          nameAndBioFields(),
                          const Spacer(),
                          createButton(cubit),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Text title(BuildContext context) {
    return Text(
      "إنشاء مجموعة جديدة",
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Stack imagePicker(BuildContext context, GroupsCubit cubit) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        CircleAvatar(
            radius: 52,
            backgroundColor: MyColors.defaultPurple.withOpacity(0.6),//Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: cubit.groupImage.path == ''
                  ? null
                  : FileImage(cubit.groupImage),
              backgroundColor: const Color(0xffD8D8D8),
            )),
        Container(
          height: 104,
          width: 104,
          //   child: CircularProgressIndicator(),
        ),
        IconButton(
          icon: CircleAvatar(
            backgroundColor: cubit.groupImage.path == ''
                ? MyColors.defaultPurple.withOpacity(0.6)
                : Colors.red.withOpacity(0.6),
            child: Icon(
              cubit.groupImage.path == ''
                  ? Icons.add
                  : Icons.remove_circle_outline,
              size: 18.0,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            cubit.groupImage.path == ''
                ? cubit.imagePicker()
                : cubit.clearGroupImage();
          },
        ),
      ],
    );
  }

  Form nameAndBioFields() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          DefaultTextFormField(
            validator: (String? value) {
              return value!.isEmpty ? 'يجب أن تحتوي المجموعة على اسم' : null;
            },
            textEditingController: groupNameController,
            label: 'اسم المجموعة',
            preIcon: null,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 20,
          ),
          DefaultTextFormField(
            validator: (String? value) {
              return value!.isEmpty ? 'يجب أن تحتوي المجموعة على أهداف' : null;
            },
            textEditingController: bioController,
            label: 'أهداف المجموعة',
            preIcon: null,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  BlocBuilder createButton(GroupsCubit cubit) {
    return BlocBuilder<GroupsCubit, GroupsState>(builder: (context, state) {
      return ConditionalBuilder(
        successWidget: (_) => DefaultButton(
            label: 'إنشاء المجموعة',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.createGroup(
                  user: user,
                  groupName: groupNameController.text,
                  groupBio: bioController.text,
                );
              }
            }),
        fallbackWidget: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        condition: state is! CreateGroupLoadingState,
      );
    });
  }
}
