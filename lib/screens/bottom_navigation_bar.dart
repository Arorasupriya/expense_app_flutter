//region ImportPackages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/screens/expense_dashboard.dart';
import 'package:onboarding_module/screens/expense_detail_Screen.dart';
import 'package:onboarding_module/screens/settings.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import '../theme_provider/theme_provider_ld.dart';
//endregion

class BottomNavigationBarFile extends StatefulWidget {
  const BottomNavigationBarFile({super.key});

  @override
  State<StatefulWidget> createState() => BottomNavigationBarFileState();
}

class BottomNavigationBarFileState extends State<BottomNavigationBarFile> {

  //region VariableDeclare
  int selectedIndex = 0;
  List<Widget> listOfScreens = [
    const ExpenseDashboard(),
    const ExpenseDetailScreen(),
    const Settings()
  ];
  //endregion

  //region BuildMethod
  @override
  Widget build(BuildContext context) {

    bool isDark = context.watch<ThemeProvider>().isDark;
    getThemeColorAccordingLitDrk(context, isDark);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Colors.blueGrey.shade100,
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.wallet_outlined),
            label: "Dashboard",
            selectedIcon: Icon(
              Icons.wallet_rounded,
              color: ColorConstant.secondaryTextColor,
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_graph),
            label: "Graph",
            selectedIcon: Icon(
              Icons.auto_graph_rounded,
              color: ColorConstant.secondaryTextColor,
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: "Settings",
            selectedIcon: Icon(
              Icons.settings,
              color: ColorConstant.secondaryTextColor,
            ),
          ),
        ],
      ),
      body: listOfScreens[selectedIndex],
    );
  }
//endregion
}
