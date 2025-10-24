import 'package:flutter/material.dart';
// Note: Assuming 'package:ias/utils/data_model.dart' is correct for your project
import 'package:ias/utils/data_model.dart';

// Summary Card Widget (Material 3 look)
class SummaryCard extends StatelessWidget {
  final SummaryCardData data;

  const SummaryCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 4,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Use the onTap provided by the data model, or a default SnackBar if none is provided.
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing ${data.title} details')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // MainAxisAlignment.end helps push content to the bottom of the card,
            // giving the value more room if the card is constrained.
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Row for Title and Icon (Top Section)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text for Title
                  Flexible(
                    // Use Flexible/Expanded here to handle long titles gracefully
                    child: Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis for overflow
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Icon(data.icon, color: data.color, size: 28),
                ],
              ),
              // Use a Spacer to separate title/icon from the main value
              const Spacer(),

              // Main Value (Bottom Section)
              // Wrap the main value text in a Flexible to prevent overflow
              Flexible(
                child: Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    // Use softWrap and maxLines to prevent overflow, although
                    // the Flexible/Expanded parent should handle it.
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Truncate if it's too long
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
