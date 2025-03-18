import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/movie_service.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:flutter_application_1/widgets/alert.dart';
import 'package:flutter_application_1/views/tambah_movie_view.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});
  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieService movieService = MovieService();
  List? film;
  List action = ["Update", "Delete"];

  @override
  void initState() {
    super.initState();
    getfilm();
  }

  getfilm() async {
    var data = await movieService.getMovie();
    if (data.status == true) {
      setState(() {
        film = data.data;
      });
    } else {
      print(data.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahMovieView(title: "Tambah Movie", item: null),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: film != null
          ? film!.isNotEmpty
              ? ListView.builder(
                  itemCount: film!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image(image: NetworkImage(film![index].posterPath)),
                        title: Text(film![index].title),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return action.map((r) {
                              return PopupMenuItem(
                                onTap: () async {
                                  if (r == "Update") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TambahMovieView(
                                          title: "Update Movie",
                                          item: film![index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    var results = await AlertMessage().showAlertDialog(context);
                                    if (results != null && results.containsKey('status')) {
                                      if (results['status'] == true) {
                                        var res = await movieService.hapusMovie(context, film![index].id);
                                        if (res.status == true) {
                                          AlertMessage().showAlert(context, res.message, true);
                                          getfilm();
                                        } else {
                                          AlertMessage().showAlert(context, res.message, false);
                                        }
                                      }
                                    }
                                  }
                                },
                                value: r,
                                child: Text(r),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("No movies available."),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}