import 'package:book/data/models/group_model.dart';
import 'package:book/data/models/poll_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polls/flutter_polls.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/conditional_builder.dart';
import '../../home/controller/layout_cubit.dart';
import '../../my_groups/controller/groups_cubit.dart';

class FeedPollComponents extends StatelessWidget {
  FeedPollComponents({
    Key? key,
    required this.cubit,
    required this.group,
  }) : super(key: key);
  final UserModel? user = LayoutCubit.getUser;
  final List<UserModel>? users = LayoutCubit.allUsers;
  final GroupsCubit cubit;
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsCubit, GroupsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          successWidget: (_) => ConditionalBuilder(
            successWidget: (_) => ListView.separated(
              itemBuilder: (context, index) => _pollItemBuilder(
                context,
                cubit.polls[index],
                cubit,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
              itemCount: cubit.polls.length,
            ),
            fallbackWidget: (_) => const Center(child: Text('لا تصويتات بعد')),
            condition: cubit.polls.isNotEmpty,
          ),
          fallbackWidget: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          condition: state is! GetPollsLoadingState &&
              state is! GetMessagesLoadingState,
        );
      },
    );
  }

  _pollItemBuilder(context, PollModel poll, GroupsCubit cubit) {
    UserModel userWhoMakeThePoll =
        users!.firstWhere((element) => element.uId == poll.creatorId);
    var whoVote = [];
    var optionsId = [];
    bool currentUserVote = false;
    int? option;
    int? firstVote;
    int? secondVote;
    int? thirdVote;
    if (poll.whoVoted != null && poll.whoVoted!.isNotEmpty) {
      print(poll.whoVoted);
      poll.whoVoted!.forEach(
        (element) {
          whoVote.add(element['voterId'].toString());
          optionsId.add(element['optionId']);
        },
      );
      currentUserVote = whoVote.contains(user!.uId);
      option = optionsId[whoVote.indexOf(user!.uId)];
      firstVote=optionsId.where((element) => element==1,).length;
      secondVote=optionsId.where((element) => element==2).length;
     thirdVote =optionsId.where((element) => element==3).length;
     print('firstVote $firstVote');
     print('firstVote $secondVote');
     print('firstVote $thirdVote');
     poll.options[0].votes=firstVote;
     poll.options[1].votes=secondVote;
     poll.options[2].votes=thirdVote;
    }
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo(context, userWhoMakeThePoll, poll.dateTime, poll),
            const SizedBox(
              height: 19,
            ),
            FlutterPolls(
              hasVoted: currentUserVote,
              userVotedOptionId: currentUserVote ? option : null,
              createdBy: userWhoMakeThePoll.email,
              leadingVotedProgessColor: MyColors.defaultPurple.withOpacity(0.8),
              pollId: poll.id,
              pollOptions: [
                ...poll.options
                    .map(
                      (e) => PollOption(
                        title: Text(e.title),
                        votes: e.votes,
                        id: e.id,
                      ),
                    )
                    .toList(),
              ],
              pollTitle: Text(
                poll.question,
              ),
              pollOptionsSplashColor: Colors.white,
              votedProgressColor: Colors.black.withOpacity(0.3),
              onVoted: (PollOption pollOption, int newTotalVotes) {
                cubit.updatePoll(
                  groupId: group.id!,
                  pollId: poll.id!,
                  optionId: pollOption.id!,
                  voterId: user!.uId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile userInfo(context, UserModel user, postDate, PollModel poll) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          userDetailsRoute,
          arguments: {
            'user': user,
            'heroId': poll.id,
          },
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.withOpacity(0.5),
        backgroundImage: CachedNetworkImageProvider(
          user.image,
        ),
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
      ),
      subtitle: Text(
        postDate,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              height: 1.2,
              fontSize: 12,
              color: const Color(0xff808080),
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
