import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Function(bool) onFavoriteToggle;

  SearchFilterWidget({
    required this.onSearch,
    required this.onFavoriteToggle,
  });

  @override
  _SearchFilterWidgetState createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Enter test name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<bool>(
            value: _showFavoritesOnly,
            icon: Icon(Icons.arrow_drop_down),
            underline: SizedBox(),
            onChanged: (bool? newValue) {
              setState(() {
                _showFavoritesOnly = newValue ?? false;
              });
              widget.onFavoriteToggle(_showFavoritesOnly);
            },
            items: <DropdownMenuItem<bool>>[
              DropdownMenuItem<bool>(
                value: false,
                child: Text('All'),
              ),
              DropdownMenuItem<bool>(
                value: true,
                child: Text('Favorites'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
