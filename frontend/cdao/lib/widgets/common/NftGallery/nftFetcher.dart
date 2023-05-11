// import '../../../models/nftsModel.dart';

// class _NFTFetcher {
//   final _count = 103;
//   final _itemsPerPage = 5;
//   int _currentPage = 0;

//   // This async function simulates fetching results from Internet, etc.
//   Future<List<NftsModel>> fetch() async {
//     final list = <NftsModel>[];
//     final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
//     // Uncomment the following line to see in real time now items are loaded lazily.
//     // print('Now on page $_currentPage');
//     await Future.delayed(Duration(seconds: 1), () {
//       for (int i = 0; i < n; i++) {
//         list.add(WordPair.random());
//       }
//     });
//     _currentPage++;
//     return list;
//   }
// }