import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool showSearchBar;
  final Widget content;
  final ValueChanged<String>? onTextChanged;

  const SearchBar({
    super.key,
    required this.showSearchBar,
    required this.content,
    this.onTextChanged,
  });

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  //late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // _focusNode = FocusNode();
  }

  @override
  void dispose() {
    //_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.showSearchBar)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: TextField(
                  onChanged: widget.onTextChanged,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          widget.content,
        ],
      ),
    );
  }
}
