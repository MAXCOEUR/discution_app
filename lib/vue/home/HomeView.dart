import 'dart:typed_data';

import 'package:discution_app/Controller/HomeController.dart';
import 'package:discution_app/Model/UserModel.dart';
import 'package:discution_app/outil/Constant.dart';
import 'package:discution_app/outil/LoginSingleton.dart';
import 'package:discution_app/outil/SocketSingleton.dart';
import 'package:discution_app/vue/home/ConversationListeView.dart';
import 'package:discution_app/vue/widget/CustomAppBar.dart';
import 'package:discution_app/vue/home/RechercheListeView.dart';
import 'package:discution_app/vue/home/amis/AmisView.dart';
import 'package:discution_app/vue/widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeView extends StatefulWidget {
  Function updateMain;

  HomeView({super.key, required this.updateMain}) {
    SocketSingleton.instance.reconnect();
  }

  final LoginModel lm = LoginModelProvider.getInstance(() {}).loginModel!;



  final String title = "Conversations";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // 0 pour convTest, 1 pour mesTest
  late HomeController homeController;

  late final ConversationListeView convView ;
  late final RechercheListeView rechercheView ;
  late final AmisView amisView;

  @override
  void initState() {
    homeController = HomeController(update);
    convView = ConversationListeView();
    rechercheView = RechercheListeView();
    amisView = AmisView();
  }

  void update() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedWidget = convView;
    if (_selectedIndex == 0) {
      selectedWidget = convView;
    } else if (_selectedIndex == 1) {
      selectedWidget = amisView;
    } else if (_selectedIndex == 2) {
      selectedWidget = rechercheView;
    }

    return Scaffold(
      appBar: CustomAppBar(
        arrowReturn: false,
      ),
      drawer: CustomDrawer(updateMain: widget.updateMain),
      body: selectedWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message),
                if (homeController.nbrMessageNonLu != null &&
                    homeController.nbrMessageNonLu! > 0)
                  Container(
                    padding: EdgeInsets.all(SizeMarginPading.h3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      homeController.nbrMessageNonLu.toString(),
                      style:
                          TextStyle(color: Colors.white, fontSize: SizeFont.p2),
                    ),
                  ),
              ],
            ),
            label: 'Conversation',
          ),
          BottomNavigationBarItem(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.supervised_user_circle),
                if (homeController.nbrDemande != null &&
                    homeController.nbrDemande! > 0)
                  Container(
                    padding: EdgeInsets.all(SizeMarginPading.h3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      homeController.nbrDemande.toString(),
                      style:
                          TextStyle(color: Colors.white, fontSize: SizeFont.p2),
                    ),
                  ),
              ],
            ),
            label: 'Amis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    SocketSingleton.instance.disconnect();
    super.dispose();
  }
}
