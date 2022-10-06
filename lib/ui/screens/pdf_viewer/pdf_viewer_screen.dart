import 'package:book/constants/colors.dart';
import 'package:book/data/models/book_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../constants/strings.dart';
import '../../../data/repositories/firebase_firestore_repository.dart';
import '../../../data/repositories/firebase_storage_repository.dart';

class PDFViewerScreen extends StatefulWidget {
  PDFViewerScreen({
    Key? key,
    required this.url,
    required this.bookName,
    required this.bookId,
    required this.myBook,
  }) : super(key: key);
  final String url;
  final String bookName;
  final String bookId;
  final BookModel myBook;

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  initState() {
    super.initState();

    LayoutCubit.getCubit(context).loadPdf(
      url: widget.url,
      bookName: widget.bookName,
      userId: LayoutCubit.getUser!.uId,
      bookId: widget.bookId,
    );
  }

  PDFViewController? controller;

  int pages = 0;

  int indexPage = 0;
  SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  );

  int numberOfPagesReadToday = 0;

  @override
  Widget build(BuildContext context) {
    final text = ' ${indexPage} من ${pages - 1} ';

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: statusBarColor,
        leading: BackButton(
          onPressed: () {
            LayoutCubit.getCubit(context).pdfFile = null;
            print('hello');
            Navigator.pop(context);
          },
        ),
        actions: pages >= 2
            ? [
                Center(
                  child: Text(text, textDirection: TextDirection.rtl),
                ),
                IconButton(
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    controller!.setPage(page);
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    controller!.setPage(page);
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 32,
                  ),
                ),
              ]
            : null,
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is AddBookMarkSuccessState)
            showingToast(
                msg: '✔', state: ToastState.checked, isGravityTop: true);
        },
        builder: (context, state) {
          LayoutCubit cubit = LayoutCubit.getCubit(context);
          return ConditionalBuilder(
            successWidget: (context) {
              return Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 130,
                    child: Center(
                      child: PDFView(
                        filePath: cubit.pdfFile!.path,
                        //  swipeHorizontal: true,
                        pageFling: false,
                        pageSnap: false,
                        //    nightMode: true,
                        defaultPage: widget.myBook.firstPage,
                        onRender: (pages) {
                          this.pages = pages!;
                          setState(() {});
                        },
                        onViewCreated: (controller) {
                          this.controller = controller;
                        },
                        onPageChanged: (indexPage, _) {
                          this.indexPage = indexPage!;
                          setState(() {});
                        },
                        onError: (error) {
                          showingToast(
                              msg: error.toString(), state: ToastState.error);
                        },
                      ),
                    ),
                  ),
                  if (state is AddBookMarkLoadingState)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.defaultPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 38),
                      ),
                      onPressed: () async {
                        if (pages > 2) {
                          if (indexPage >= widget.myBook.firstPage) {
                            numberOfPagesReadToday =
                                indexPage - widget.myBook.firstPage;
                          } else {
                            numberOfPagesReadToday = 0;
                          }

                          dialogToUpdateTodayReadPages(
                            context: context,
                            numberRead: numberOfPagesReadToday,
                            numberOfPreviousRead:
                                (LayoutCubit.getUser!.numberOfPagesToday!),
                            secondNumber:
                                (LayoutCubit.getUser!.numberOfPagesRead),
                            trackName: 'numberOfPagesToday',
                          );

                          await cubit.addBookMark(
                            bookId: widget.bookId,
                            pageNumber: indexPage,
                            allPageNumber: pages,
                            bookName: widget.bookName,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.bookmark_border,
                      ),
                    ),
                  ),
                ],
              );
            },
            fallbackWidget: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            condition: state is! GetRateLoadingState &&
                cubit.pdfFile != null &&
                cubit.pdfFile!.path.isNotEmpty,
          );
        },
      ),
    );
  }
}

Future dialogToUpdateTodayReadPages({
  required BuildContext context,
  required int numberRead,
  required int numberOfPreviousRead,
  int? secondNumber,
  required String trackName,
}) {
  if (secondNumber != null && secondNumber < 0) {
    secondNumber = 0;
  }
  return showDialog(
    context: context,
    builder: (_) {
      return BlocProvider(
        create: (ctx) => LayoutCubit(
          firebaseFirestoreRepository: FirebaseFirestoreRepository(),
          firebaseStorageRepository: FirebaseStorageRepository(),
        ),
        child: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {
            if (state is UpdateTrackSuccessState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 130,
                          width: 250,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Image.asset(
                            'assets/images/fo.png',
                            cacheWidth: 750,
                            cacheHeight: 390,
                            width: 750,
                            height: 390,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: Card(
                          elevation: 0,
                          surfaceTintColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('عدد الصفحات التي قرأتها'),

                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          defaultRadius,
                                        ),
                                      ),
                                      minimumSize: const Size(50, 50),
                                      maximumSize: const Size(50, 50),
                                    ),
                                    onPressed: () {
                                      if (numberRead != 0) {
                                        numberRead--;
                                        BlocProvider.of<LayoutCubit>(context)
                                            .changeNumber();
                                      }
                                    },
                                    child: const Text(
                                      '-',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  Text(numberRead.toString()),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          defaultRadius,
                                        ),
                                      ),
                                      minimumSize: const Size(50, 50),
                                      maximumSize: const Size(50, 50),
                                    ),
                                    onPressed: () {
                                      numberRead++;

                                      BlocProvider.of<LayoutCubit>(context)
                                          .changeNumber();
                                    },
                                    child: const Icon(Icons.add),
                                  )
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 320,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          await BlocProvider.of<LayoutCubit>(
                                                  context)
                                              .updateUserTrack(
                                            userId: LayoutCubit.getUser!.uId,
                                            trackName: trackName,
                                            tracValue: (numberOfPreviousRead +
                                                numberRead),
                                            secondTrackName: trackName ==
                                                    'numberOfPagesToday'
                                                ? 'numberOfPagesRead'
                                                : null,
                                            secondTrackValue: trackName ==
                                                    'numberOfPagesToday'
                                                ? (secondNumber! + numberRead)
                                                : null,
                                          );
                                        },
                                        child: const Text(
                                          'تأكيد الإنجاز',
                                        ),
                                      ),
                                    ),
                                    if (state is UpdateTrackLoadingState)
                                      const RefreshProgressIndicator()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
