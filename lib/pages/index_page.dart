import 'package:alquran_web/widgets/horizontal_cardview.dart';  
import 'package:alquran_web/widgets/index_appbar.dart';  
import 'package:alquran_web/widgets/index_floating_tabbar.dart';  
import 'package:alquran_web/widgets/search_widget.dart';  
import 'package:flutter/material.dart';  

class IndexPage extends StatefulWidget {  
  const IndexPage({super.key});  

  @override  
  State<IndexPage> createState() => _IndexPageState();  
}  

class _IndexPageState extends State<IndexPage>  
    with SingleTickerProviderStateMixin {  
  late TabController _tabController;  
  late ScrollController _scrollController;  

  @override  
  void initState() {  
    super.initState();  
    _tabController = TabController(length: 3, vsync: this);  
    _scrollController = ScrollController();  
  }  

  @override  
  void dispose() {  
    _tabController.dispose();  
    _scrollController.dispose();  
    super.dispose();  
  }  

  @override  
  Widget build(BuildContext context) {  
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;  

    return Scaffold(  
      appBar: const IndexAppbar(),  
      body: SingleChildScrollView(  
        child: Center(  
          child: Column(  
            children: [  
              const SizedBox(height: 20),  
              SearchWidget(  
                width: MediaQuery.of(context).size.width,  
                onChanged: (value) {  
                  // Handle search text changes  
                  print('Search query: $value');  
                },  
                onClear: () {  
                  // Handle clear button press  
                  print('Search cleared');  
                },  
              ),  
              const SizedBox(height: 25),  
              const HorizontalCardWidget(),  
              const SizedBox(height: 25),  
              IndexFloatingTabbar(  
                controller: _tabController,  
                isDarkMode: isDarkMode,  
                scrollController: _scrollController,  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}