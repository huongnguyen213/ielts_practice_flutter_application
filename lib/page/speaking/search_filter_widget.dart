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
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Enter test name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                value: _showFavoritesOnly,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (bool? newValue) {
                  setState(() {
                    _showFavoritesOnly = newValue ?? false;
                  });
                  widget.onFavoriteToggle(_showFavoritesOnly);
                },
                items: const <DropdownMenuItem<bool>>[
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
          ),
        ),
      ],
    );
  }
}
