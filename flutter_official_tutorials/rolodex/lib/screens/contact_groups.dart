import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact.dart';

import 'package:rolodex/data/contaxt_group.dart';
import 'package:rolodex/main.dart';
import 'package:rolodex/screens/contacts.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      //获取组件树中最近的导航组件，push方法添加新的路由到导航堆栈，然后显示builder中返回的组件
      onListSelected: (list) => Navigator.of(context).push(
        //创建ios风格的页面切换
        CupertinoPageRoute(
          title: list.title,
          builder: (context) => ContactListsPage(listId: list.id),
        ),
      ),
    );
  }
}

//联系人组组件，宽屏用于填充边栏，窄屏用于弹出选择联系人组的页面
class _ContactGroupsView extends StatelessWidget {
  final int? selectedListId;
  final Function(ContactGroup) onListSelected;

  const _ContactGroupsView({required this.onListSelected, this.selectedListId});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Lists')),
          SliverFillRemaining(
            child: ValueListenableBuilder<List<ContactGroup>>(
              valueListenable: contactGroupsModel.listsNotifier,
              builder: (context, contactlists, child) {
                const groupIcon = Icon(
                  CupertinoIcons.group,
                  weight: 900,
                  size: 32,
                );
                const pairIcon = Icon(
                  CupertinoIcons.person_2,
                  weight: 900,
                  size: 24,
                );
                return CupertinoListSection.insetGrouped(
                  header: const Text('iphone'),
                  children: [
                    for (final ContactGroup contactList in contactlists)
                      CupertinoListTile(
                        leading: contactList.id == 0 ? groupIcon : pairIcon,
                        title: Text(contactList.label),
                        trailing: _buildTrailing(contactList.contacts, context),
                        onTap: () => onListSelected(contactList),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //包含箭头和联系人数量的组件
  Widget _buildTrailing(List<Contact> contacts, BuildContext contaxt) {
    final TextStyle style = CupertinoTheme.of(
      contaxt,
    ).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(contacts.length.toString(), style: style),
        const Icon(
          CupertinoIcons.forward,
          color: CupertinoColors.systemGrey3,
          size: 18,
        ),
      ],
    );
  }
}

//宽屏时显示的边栏
class ContactGroupsSidebar extends StatelessWidget {
  const ContactGroupsSidebar({
    super.key,
    required this.selectedListId,
    required this.onListSelected,
  });

  final int selectedListId;
  final Function(int) onListSelected;

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: selectedListId,
      onListSelected: (list) => onListSelected(list.id),
    );
  }
}
