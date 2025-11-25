import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBarWidget extends StatefulWidget {
  final List<dynamic> items;
  final Function(Map<String, dynamic>) onItemSelected;

  const SearchBarWidget({super.key, required this.items, required this.onItemSelected});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool focusNode = false;
  List<dynamic> _filteredItems = [];
  bool _isListVisible = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus != _isListVisible) {
      if (_focusNode.hasFocus) {
        focusNode = true;
        debugPrint(
            '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
        debugPrint('\t\tfoucsNode = $focusNode');
        debugPrint(
            '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
      }
      if (mounted) {
        setState(() {
          _isListVisible = _focusNode.hasFocus;
        });
      }
    }
  }

  void _onTextChanged(String text) {
    if (mounted) {
      setState(() {
        _filteredItems = widget.items.where((item) {
          return item['name'].toLowerCase().contains(text.toLowerCase()) ||
              item['status'].toLowerCase().contains(text.toLowerCase());
        }).toList();
      });
    }
  }

  void _onItemTapped(Map<String, dynamic> item) {
    widget.onItemSelected(item);
    _controller.clear();
    _focusNode.unfocus();
    focusNode = false;
    debugPrint(
        '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
    debugPrint('\t\tfoucsNode = $focusNode');
    debugPrint(
        '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
    if (mounted) {
      setState(() {
        _filteredItems = widget.items;
        _isListVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _onTextChanged,
        ),
        Visibility(
          visible: _isListVisible,
          child: Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const FaIcon(FontAwesomeIcons.locationDot),
                    title: Text(_filteredItems[index]['name']),
                    onTap: () => _onItemTapped(_filteredItems[index]),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
