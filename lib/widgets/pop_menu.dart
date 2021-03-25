import 'package:flutter/material.dart';
import './triangle_view.dart';

OverlayEntry _overlayEntry;

class PopMenu {
  static bool isShow = false;

  static show(
      {@required BuildContext context, Function(int) onSelected, @required List<PopMenuItemModel> items, int width}) {
    if (items.length == 0) {
      return;
    }
    PopMenu.isShow = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_overlayEntry != null) {
              PopMenu.close();
            }
          },
          child: Container(
            decoration: BoxDecoration(),
            alignment: Alignment.bottomRight,

            padding: EdgeInsets.only(bottom: 60,right: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF434445),
                  ),
                  height: (items.length * 46 + 6.0),
                  width: width ?? 120,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return PopMenuItem(
                   
                        title: items[index].title,
                        index: index,
                        showBottomDivider: index != (items.length - 1),
                        onTap: (index) {
                          PopMenu.close();
                          if (onSelected != null) {
                            onSelected(index);
                          }
                        },
                      );
                    },
                  ),
                ),
           
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry);
  }

  static close() {
    PopMenu.isShow = false;
    _overlayEntry.remove();
  }
}

class PopMenuItemModel {
  final String title;
  const PopMenuItemModel({ this.title});
}

class PopMenuItem extends StatelessWidget { 
  final String title;
  final int index;
  final bool showBottomDivider;
  final Function(int) onTap;
  const PopMenuItem({
    Key key,
    
    this.title,
    this.index,
    this.showBottomDivider = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Container(
        height: 47,
        decoration: BoxDecoration(
          border: showBottomDivider
              ? Border(
                  bottom: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ))
              : Border(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
    
            Material(
                color: Colors.transparent,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
