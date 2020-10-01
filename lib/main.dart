import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Books> bookdetails = [];
  Future<List<Books>> _bookDetails() async {
    var data =
        await http.get('https://my.api.mockaroo.com/books.json/key=5bdb3b40');
    var jsonData = json.decode(data.body);
    for (var bookval in jsonData) {
      Books books = Books(
          bookname: bookval['bookname'],
          bookauthor: bookval['bookauthor'],
          bookcover: bookval['bookcover'],
          bookrating: bookval['bookrating'],
          bookviews: bookval['bookviews']);
      bookdetails.add(books);
    }
    return bookdetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _bookDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: Color(0xfffe7e7e7),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getBookDetails(
                          snapshot.data[index].bookname,
                          snapshot.data[index].bookauthor,
                          snapshot.data[index].bookcover,
                          snapshot.data[index].bookrating,
                          snapshot.data[index].bookviews,
                        );
                      },
                    ),
                  );
                } else {
                  return (Text('Donas'));
                }
                // switch (snapshot.connectionState) {
                //   case ConnectionState.waiting:

                //   break;
                //   case ConnectionState.active:

                //   break;
                //   case ConnectionState.none:

                //   break;
                //   case ConnectionState.done:

                //   break;
                //   default:
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Books {
  final String bookname;
  final String bookauthor;
  final String bookcover;
  final int bookrating;
  final int bookviews;

  Books(
      {this.bookauthor,
      this.bookcover,
      this.bookname,
      this.bookrating,
      this.bookviews});
}

Widget getBookDetails(
  String bookname,
  String bookauthor,
  String bookcover,
  int bookrating,
  int bookviews,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Stack(
      children: [
        Container(
          width: 315,
          height: 288,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.0),
            image: DecorationImage(
              image: NetworkImage(bookcover),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 164.0,
          top: 70.0,
          child: Material(
            color: Colors.white10,
            elevation: 10.0,
            borderRadius: BorderRadius.circular(17.0),
            shadowColor: Color(0x802196f3),
            child: Container(
              width: 230.0,
              height: 188.0,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              bookname,
                              style: dominos,
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              bookauthor,
                              style: dominos,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  '$bookviews views',
                                  style: dominos,
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.view_headline_rounded),
                                onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

TextStyle dominos = TextStyle(
  color: Color(0xff07328e),
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);
