import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/movie_model.dart';
import 'package:flutter_application_1/services/movie_service.dart';
import 'package:flutter_application_1/widgets/alert.dart';
import 'package:image_picker/image_picker.dart';

class TambahMovieView extends StatefulWidget {
  final String title;
  final MovieModel? item;
  const TambahMovieView({required this.title, required this.item, super.key});

  @override
  State<TambahMovieView> createState() => _TambahMovieViewState();
}

class _TambahMovieViewState extends State<TambahMovieView> {
  
    MovieService movie = MovieService();
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController voteAverage = TextEditingController();
  TextEditingController overView = TextEditingController();
  File? selectedImage;
  bool? isLoading = false;
   Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);


    setState(() {
      selectedImage = File(img!.path);
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: title,
                    decoration: InputDecoration(label: Text("Title")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: voteAverage,
                    decoration: InputDecoration(label: Text("Vote Average")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: overView,
                    decoration: InputDecoration(label: Text("Over View")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextButton(
                    onPressed: () {
   getImage();
                    },
                    child: Text("Select Picture")),
                selectedImage != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(selectedImage!),
                      )
                    : isLoading == true
                        ? CircularProgressIndicator()
                        : Center(child: Text("Please Get the Images")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = {
                          "title": title.text,
                          "voteaverage": voteAverage.text,
                          "overview": overView.text,
                        };
                        var result;
                        if (widget.item != null) {
                          result = await movie.insertMovie(
                              data, selectedImage, widget.item!.id!);
                        } else {
                          result = await movie.insertMovie(
                              data, selectedImage, null);
                        }


                        if (result.status == true) {
                          AlertMessage()
                              .showAlert(context, result.message, true);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/movie');
                        } else {
                          AlertMessage()
                              .showAlert(context, result.message, false);
                        }


                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}