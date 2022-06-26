import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/dummy_data.dart';
import 'package:flutter_complete_guide/screen/filter_screen.dart';
import 'package:flutter_complete_guide/screen/meal_detail_screen.dart';
import './screen/tabs_screen.dart';
import './screen/category_meals_screen.dart';
import './screen/categories_screen.dart';
import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availabeMeals = DUMMY_MEALS;

  List<Meal> _favoritedMeals = [];
  void _setfilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availabeMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoritedMeals.indexWhere((meal) => mealId == meal.id);
    if (existingIndex >= 0) {
      setState(() {
        _favoritedMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoritedMeals
            .add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favoritedMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontSize: 24,
            )),
      ),
      // home: CatergoriesScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => TabsScreen(_favoritedMeals),
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(_availabeMeals),
        MealDetailScreen.routeName: (context) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FilterScreen.routeName: (context) =>
            FilterScreen(_filters, _setfilters),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(
          builder: ((context) => CatergoriesScreen()),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => CatergoriesScreen());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeliMeals'),
      ),
      body: Center(
        child: Text('Navigation Time!'),
      ),
    );
  }
}
