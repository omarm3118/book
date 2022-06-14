import 'package:book/constants/strings.dart';
import 'package:book/data/models/poll_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:book/ui/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PollsScreen extends StatefulWidget {
  PollsScreen({Key? key, required this.groupId}) : super(key: key);

  final String groupId;

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _a1Controller = TextEditingController();
  final TextEditingController _a2Controller = TextEditingController();
  final TextEditingController _a3Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsCubit, GroupsState>(
      listener: (context, state) {
        if (state is CreatePollSuccessState) Navigator.pop(context);
      },
      builder: (context, state) {
        GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('أنشئ تصويتًا'),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultTextFormField(
                      validator: (String? value) {
                        return value!.isEmpty ? 'أكتب السؤال...' : null;
                      },
                      textEditingController: _questionController,
                      label: 'اكتب السؤال',
                      preIcon: Icon(
                        Icons.question_mark_outlined,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    DefaultTextFormField(
                      validator: (String? value) {
                        return value!.isEmpty ? 'أكتب الإقتراح...' : null;
                      },
                      textEditingController: _a1Controller,
                      label: 'الإقتراح الأول',
                      preIcon: Icon(
                        Icons.question_answer_outlined,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      validator: (String? value) {
                        return value!.isEmpty ? 'أكتب الإقتراح...' : null;
                      },
                      textEditingController: _a2Controller,
                      label: 'الإقتراح الثاني',
                      preIcon: Icon(
                        Icons.question_answer_outlined,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      validator: (String? value) {
                        return value!.isEmpty ? 'أكتب الإقتراح...' : null;
                      },
                      textEditingController: _a3Controller,
                      label: 'الإقتراح الثالث',
                      preIcon: Icon(
                        Icons.question_answer_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: ConditionalBuilder(
            successWidget: (_) => FloatingActionButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  cubit.createPoll(
                    creatorId: LayoutCubit.getUser!.uId,
                    groupId: widget.groupId,
                    question: _questionController.text,
                    options: [
                      Option(id: 1, title: _a1Controller.text, votes: 0),
                      Option(id: 2, title: _a2Controller.text, votes: 0),
                      Option(id: 3, title: _a3Controller.text, votes: 0),
                    ],
                  );
                }
              },
              child: Icon(
                Icons.send_outlined,
              ),
            ),
            fallbackWidget: (_) => FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {},
              child: CircularProgressIndicator(),
            ),
            condition: state is! CreatePollLoadingState,
          ),
        );
      },
    );
  }

}
