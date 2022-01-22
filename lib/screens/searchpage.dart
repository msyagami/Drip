// import 'dart:core';

// import 'package:drip/datasource/searchresults/albumsdataclass.dart';
// import 'package:drip/datasource/searchresults/artistsdataclass.dart';
// import 'package:drip/datasource/searchresults/communityplaylistdataclass.dart';
// import 'package:drip/datasource/searchresults/searchresultstwo.dart';
// import 'package:drip/datasource/searchresults/songsdataclass.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class SearchPage extends StatefulWidget {
//   //final String incomingquery;
//   const SearchPage({
//     Key? key,
//     //required this.incomingquery,
//   }) : super(key: key);

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchcontroller = TextEditingController();

//   String query = '';
//   bool status = false;
//   late Map MapOfSearchResults = {};
//   late List<Artists> artists = [];
//   late List<Albums> albums = [];
//   late List<Songs> songs = [];
//   late List<CommunityPlaylist> communityplaylists = [];
//   late List listOfSearchResults = [];
//   // late Topresults _topresults;
//   // late List<Songs> _searchpageresults;

//   bool fetched = false;

//   @override
//   void initState() {
//     super.initState();
//     // SearchMusic().getArtists('new');
//     //_searchcontroller.text = query;
//   }

//   @override
//   void dispose() {
//     _searchcontroller.dispose();
//     super.dispose();
//   }

//   //List<Searchresults> searchview = _searchpageresults;
//   //SearchApi().fetchd

//   @override
//   Widget build(BuildContext context) {
//     //super.build(context);
//     // final bool rotated =
//     //     MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
//     // double boxSize = !rotated
//     //     ? MediaQuery.of(context).size.width / 2
//     //     : MediaQuery.of(context).size.height / 2.5;
//     // if (boxSize > 250) boxSize = 250;
//     if (!status) {
//       status = true;
//       SearchMusic.getArtists(query == '' ? 'Trending' : query).then((value) {
//         setState(() {
//           MapOfSearchResults = value;
//           listOfSearchResults =
//               MapOfSearchResults.values.toList(growable: false);
//           artists = listOfSearchResults[0];
//           songs = listOfSearchResults[1];
//           communityplaylists = listOfSearchResults[2];
//           albums = listOfSearchResults[3];
//           // _topresults = listOfSearchResults[4];
//           // artists = listOfSearchResults['artistsearch'];
//           // songs = listOfSearchResults['songsearch'];
//           // communityplaylists = listOfSearchResults['communityplaylistsearch'];
//           // albums = listOfSearchResults['albumsearch'];
//           // _topresults = listOfSearchResults['topresults'];
//           fetched = true;
//         });
//       });
//     }
//     return Container(
//       color: Colors.black,
//       child: Expanded(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(10, 0, 20, 50),
//                 width: 400,
//                 child: CupertinoSearchTextField(
//                   controller: _searchcontroller,

//                   // onChanged: (value) {
//                   //   url =
//                   //       'http://127.0.0.1:5000/search?query=$value&filter=songs&limit=20';
//                   // },
//                   style: TextStyle(color: Colors.white),
//                   onSubmitted: (_value) async {
//                     setState(() {
//                       fetched = false;
//                       query = _value;
//                       status = false;
//                       listOfSearchResults = [];
//                     });
//                   },

//                   //backgroundColor: Colors.red.shade700.withOpacity(0.3),
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           color: Colors.white,
//                           style: BorderStyle.solid,
//                           width: 1.5),
//                       color: Colors.red.shade900.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             Container(
//                 child: (!fetched)
//                     ? Container(
//                         width: 200,
//                         height: 200,
//                         child: CircularProgressIndicator())
//                     : Expanded(
//                         child: SingleChildScrollView(
//                           clipBehavior: Clip.hardEdge,
//                           primary: false,
//                           physics: const BouncingScrollPhysics(
//                               parent: AlwaysScrollableScrollPhysics()),
//                           padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
//                           child: Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                   'Results for $query',
//                                   style: TextStyle(
//                                     fontSize: 40.0,
//                                   ),
//                                 ),
//                               ),
//                               ListView.builder(
//                                   itemCount: listOfSearchResults.length,
//                                   physics: BouncingScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     return Column(
//                                       children: [
//                                         if (listOfSearchResults[index])
//                                         Container(

//                                         )
//                                       ],
//                                     )
//                                   })
//                             ],
//                           ),
//                         ),
//                       ))
//           ],
//         ),
//       ),
//     );
//   }
// }
