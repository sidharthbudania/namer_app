import 'dart:html';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  var favorites = <WordPair>[];


  void removeFavorite(int index) {
    if (index >= 0 && index < favorites.length) {
      favorites.removeAt(index);
      notifyListeners();
    }
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SizedBox(
        width: 50, 
        height: 50, 
        child: FloatingActionButton(
          child: Icon(Icons.account_circle_outlined),
          backgroundColor: Color.fromARGB(255, 213, 219, 223),
          onPressed: () {
           
            setState(() {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoPage()));
            });
  
          },
        ),
      ),
    );
  }
}



class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color:theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,style: style,semanticsLabel: pair.asPascalCase,),
      ),
    );
  }
}
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length.toString()} favorites:'),
        ),
        for (var index = 0; index < appState.favorites.length; index++)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(appState.favorites[index].asString.toLowerCase()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                context.read<MyAppState>().removeFavorite(index);
                },
            ),
          ),
      ],
    );
  }
}


class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  final double coverHeight=280;
  final double profileHeight=144;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ),
      
      appBar: AppBar(
        centerTitle: true,
        title: Text("Info Page"),
      ),
    
    );
  }

  Widget buildTop(){
    var bottom =profileHeight/2;
    var top =coverHeight-profileHeight/2;
     return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
          ),
          Positioned(
          top:top,
          child: buildProfileImage(),
          ),
        ],
      
      );

  }

  Widget buildCoverImage()=> Container(

    color: Colors.grey,
    child: Image.network(

      'https://imgs.search.brave.com/8LScqRWZEjJKOcYZtNc5PBzB7RZ3MEzfz5cnAE2qk-Q/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTMx/MTE4NDQyNC9waG90/by9hYnN0cmFjdC1u/ZXR3b3JrLWFuZC1k/YXRhLmpwZz9zPTYx/Mng2MTImdz0wJms9/MjAmYz1zS19OcGxO/aHdVYUFMd21Lc3du/VlNaOUV3MXhxbnZo/SXRRYUpwSWFiU1Bn/PQ',
     width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),

  );

 Widget buildProfileImage()=> CircleAvatar(
    radius: profileHeight/1.8,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage(
      'https://imgs.search.brave.com/ViA_gH-fez1-LqZGEbc7DgqOILKjmjTH5yR30q8PF8o/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzIwL2E4/LzVhLzIwYTg1YTUw/MDgwNzM3ZTZmMzkz/NjhiMDRlZWFmZjgz/LmpwZw',
      ),
  );


}

Widget buildContent() => Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person), 
              SizedBox(width: 8), 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sidharth Budania',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4), 
                  Text(
                    'sidharthb22@iitk.ac.in',
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: true,
                      applyHeightToLastDescent: false,
                    ),
                    textWidthBasis: TextWidthBasis.longestLine,
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.perm_identity), 
              SizedBox(width: 8),
              Text(
                'Roll no: 221057',
                style: TextStyle(fontSize: 18, height: 2),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_city), 
              SizedBox(width: 8), 
              Text(
                'City: Kanpur',
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: true,
                  applyHeightToLastDescent: false,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
                style: TextStyle(fontSize: 18, height: 1.4),
              ),
            ],
          ),
        ],
      ),
    );
