import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/movie_service.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:flutter_application_1/widgets/alert.dart';
import 'package:flutter_application_1/views/tambah_movie_view.dart';
import 'package:flutter_application_1/models/movie_model.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});
  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieService movieService = MovieService();
  List? film;
  List<String> action = ["Update", "Delete"];

  @override
  void initState() {
    super.initState();
    getfilm();
  }

  getfilm() async {
    print("Fetching movies...");
    var data = await movieService.getMovie();
    print("Fetch complete. Status: ${data.status}");
    if (data.status == true) {
      setState(() {
        film = data.data;
        print("Movies loaded: ${film!.length}");
        print("Movies data: ${film}");
      });
    } else {
      print("Error: ${data.message}");
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
                  builder: (context) => TambahMovieView(
                    title: "Tambah Movie",
                    item: null,
                  ),
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
                        leading: film![index]['posterpath'] != null
                            ? Image.network(
                                'http://localhost/toko_online_BismaAditama/public/' + film![index]['posterpath'],
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                },
                              )
                            : Icon(Icons.movie),
                        title: Text(film![index]['title'] ?? 'No Title'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String value) async {
                            if (value == "Update") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TambahMovieView(
                                    title: "Update Movie",
                                    item: MovieModel.fromJson(film![index]), // Convert JSON to MovieModel
                                  ),
                                ),
                              );
                            } else if (value == "Delete") {
                              var results = await AlertMessage().showAlertDialog(context);
                              if (results != null && results.containsKey('status')) {
                                if (results['status'] == true) {
                                  var res = await movieService.hapusMovie(context, film![index]['id']);
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
                          itemBuilder: (BuildContext context) {
                            return action.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
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