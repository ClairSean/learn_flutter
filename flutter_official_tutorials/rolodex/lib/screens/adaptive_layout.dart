import 'package:flutter/cupertino.dart';
import 'contact_groups.dart';
import 'contacts.dart';

//宽屏判定
const largeScreenMinWidth = 800;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<StatefulWidget> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  //用于宽屏模式下跟踪选中的联系人列表
  int selectedListId = 0;
  void _onContactListSelected(int listId) {
    setState(() {
      selectedListId = listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //提供父组件宽高限制信息
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;
        //自适应选择渲染组件
        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        } else {
          return const ContactGroupsPage();
        }
      },
    );
  }

  //宽屏下的布局
  Widget _buildLargeScreenLayout() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      //安全区确保手机系统组件不与app组件重合
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 320,
              child: ContactGroupsSidebar(
                selectedListId: selectedListId,
                onListSelected: _onContactListSelected,
              ),
            ),
            //分割线
            Container(width: 1, color: CupertinoColors.separator),
            Expanded(child: ContactListDetail(listId: selectedListId)),
          ],
        ),
      ),
    );
  }
}
