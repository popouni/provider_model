import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_model/add_book/add_book_page.dart';
import 'package:provider_model/domain/book.dart';
import 'package:provider_model/presentation/book_list/book_list_model.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Consumer<BookListModel>(builder: (context, model, child) {
          final books = model.books;
          final listTitles = books
              .map(
                (book) => ListTile(
                  title: Text(book.title),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      // todo 画面遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBookPage(
                            book: book,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.fetchBooks();
                    },
                  ),
                  onLongPress: () async {
                    // todo:
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('${book.title}削除しましすか？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                //todo: 削除のAPIを叩く
                                await deleteBook(context, model, book);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
              .toList();
          return ListView(
            children: listTitles,
          );
        }),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // todo
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              model.fetchBooks();
            },
          );
        }),
      ),
    );
  }

  Future deleteBook(
    BuildContext context,
    BookListModel model,
    Book book,
  ) async {
    try {
      await model.deleteBook(book);
      await model.fetchBooks();
    } catch (e) {
      await _showDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext content) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
