import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../../../data/models/book_model.dart';

class ShowAllBooksScreen extends StatelessWidget {
  final List<BookModel> books;

  const ShowAllBooksScreen({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: itemsBuilder(context),
      ),
    );
  }

  itemsBuilder(context) {
    return ListView.separated(
      itemBuilder: (ctx, index) => buildItem(books[index], context),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: books.length,
    );
  }

  buildItem(BookModel book, BuildContext context) {
    return
    InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          bookDetailsRoute,
          arguments: {'book': book, 'context': context},
        );
      },
      child: ListTile(
        leading: Container(
          clipBehavior: Clip.antiAlias,
          height: 80,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Hero(
            tag: book.id.toString(),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: book.imageLink.toString(),
              errorWidget: (ctx, url, error) => const Icon(Icons.error_outline),
              placeholder: (ctx, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        title: Text(
          book.name!,
          maxLines: 1,
        ),
        subtitle: Text(
          book.authorName!,
          maxLines: 1,
        ),
      ),
    );
  }
}
