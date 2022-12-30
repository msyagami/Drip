import 'package:drip/datasources/searchresults/artistsdataclass.dart';
import 'package:drip/pages/artistspage.dart';
import 'package:drip/providers/providers.dart';

import 'package:extended_image/extended_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistsSearch extends StatelessWidget {
  late List<Artists> artists = [];

  ArtistsSearch({
    Key? key,
    required this.artists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          height: 250,
          // width: 800,
          child: ListView.builder(
            itemCount: artists.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            itemBuilder: (context, index) {
              return ArtistCard(
                  artists: Artists(
                      artist: artists[index].artist,
                      subscribers: '',
                      browseId: artists[index].browseId,
                      category: artists[index].category,
                      radioId: artists[index].radioId,
                      resultType: artists[index].resultType,
                      shuffleId: artists[index].shuffleId,
                      thumbnails: artists[index].thumbnails));
            },
          ),
        ),
      ],
    );
  }
}

class ArtistCard extends StatelessWidget {
  const ArtistCard({Key? key, required this.artists}) : super(key: key);

  final Artists artists;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;

    //return

    return Hero(
        tag: artists.shuffleId.toString(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent),
          width: 200,
          child: Column(
            children: [
              mat.InkWell(
                onTap: () {
                  //   Navigator.of(context).pushNamed('artistsPage',
                  //       arguments: artists.browseId.toString());
                  // }
                  // ,

                  Navigator.push(
                      context,
                      mat.MaterialPageRoute(
                          builder: (context) => ArtistsPage(
                              channelId: artists.browseId.toString())));
                },
                child: mat.Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: const CircleBorder(),
                  child: ExtendedImage.network(
                    artists.thumbnails?.last.url.toString() ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOAQ7BhOGwDxmTw_6aRu2zlOiQ-WdTdF2XUxKBEAz_Q1MrOReLWZ-W4FaCUBkt5xod2cA&usqp=CAU',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                    cache: false,
                    shape: BoxShape.circle,
                  ),

                  // CachedNetworkImage(
                  //   imageBuilder: (context, imageProvider) => CircleAvatar(
                  //     backgroundColor: mat.Colors.transparent,
                  //     foregroundColor: Colors.transparent,
                  //     radius:84,
                  //     backgroundImage: imageProvider,
                  //   ),
                  //   fit: BoxFit.cover,
                  //   errorWidget: (context, url, error) => const Image(
                  //     fit: BoxFit.cover,
                  //     image: AssetImage('assets/artist.jpg'),
                  //   ),
                  //   imageUrl: artists.thumbnails?.last.url.toString() ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOAQ7BhOGwDxmTw_6aRu2zlOiQ-WdTdF2XUxKBEAz_Q1MrOReLWZ-W4FaCUBkt5xod2cA&usqp=CAU',
                  //   placeholder: (context, url) => const Image(
                  //       fit: BoxFit.fill,
                  //       image: AssetImage('assets/artist.jpg')),
                  // ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                artists.artist.toString(),
                textAlign: TextAlign.left,
                softWrap: false,
                style: typography.body?.apply(fontSizeFactor: 1.2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ));
  }
}

class ArtistsSearchResults extends ConsumerStatefulWidget {
  final String artistQuery;

  const ArtistsSearchResults({Key? key, required this.artistQuery})
      : super(key: key);

  @override
  ConsumerState<ArtistsSearchResults> createState() =>
      _ArtistsSearchResultsState();
}

class _ArtistsSearchResultsState extends ConsumerState<ArtistsSearchResults> {
  final scrollController = ScrollController();
  bool isScrollable = true;
 // int itemcount = 20;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        content: GridView.custom(
      // semanticChildCount: 10,
      shrinkWrap: true,

      physics: BouncingScrollPhysics(),
      controller: scrollController,

      childrenDelegate: SliverChildBuilderDelegate(
        //temporary fix,
         // childCount: itemcount,
              (
        context,
        index,
      ) {
        const pageLimit = 20;

        final page = index ~/ pageLimit + 1;
        final itemIndexInPage = index % pageLimit;

        final results = ref.watch(artistsListResultsProvider(page));




        return results.when(
            error: (err, stack) => Text('error $err'),
            loading: () => const Center(child: mat.CircularProgressIndicator()),
            data: (results) {
             // itemcount = results.length*page;

              print(results.length*page);
              if (itemIndexInPage >= results.length) {
                scrollController.animateTo(100, duration: Duration(milliseconds: 600), curve:Curves.ease );

                return null;
              }

              final result = results[itemIndexInPage];
              return ArtistCard(artists: result);
            });
      }),

      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1 / 1.5,
      ),
    ));
  }
}

// class ArtistsSearchResults extends ConsumerStatefulWidget {
//   final String artistQuery;
//
//   const ArtistsSearchResults({Key? key, required this.artistQuery})
//       : super(key: key);
//
//   @override
//   _ArtistsSearchResultsState createState() => _ArtistsSearchResultsState();
// }
//
// class _ArtistsSearchResultsState extends ConsumerState<ArtistsSearchResults> {
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return ScaffoldPage(
//         bottomBar: const SizedBox(
//           height: 150,
//         ),
//         content: ListView.builder(
//           controller: _scrollController,
//           itemCount: artists.length,
//           itemBuilder: (context, index) =>
//               ArtistCard(artists: artists[index]),));
//   }
// }

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: const Offset(0, 0), radius: 80);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}
