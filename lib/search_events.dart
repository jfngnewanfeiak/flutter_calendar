import 'package:calendar_app/table_calendar_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchEventsPage extends HookConsumerWidget {
  const SearchEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventProvider = ref.watch(tableCalendarEventControllerProvider);
    final allEvents = ref.read(tableCalendarEventControllerProvider);
    // タグとイベントデータ
    final tags = ["seasonalevents", "sports", "cleanup", "childrenevents", "community", "disaster"];
    final events = [
      {"title": "Community Cleanup", "tags": ["cleanup", "community"]},
      {"title": "Local Sports Day", "tags": ["sports", "childrenevents"]},
      {"title": "Disaster Relief Training", "tags": ["disaster"]},
      {"title": "Spring Festival", "tags": ["seasonalevents", "community"]},
    ];

    // 状態管理
    final selectedTag = useState<String?>(null);
    final filteredEvents = useState<List<Map<String, dynamic>>>(events);

    // イベントフィルタリング
    void filterEvents(String tag) {
      selectedTag.value = tag;
      filteredEvents.value = events.where((event) {
        // `tags` が `null` の場合を考慮してチェックを追加
        final eventTags = event["tags"] as List<String>? ?? [];
        return eventTags.contains(tag);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント検索"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // タグ選択ボタン
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                return ElevatedButton(
                  onPressed: () {
                    filterEvents(tag);
                  },
                  child: Text(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // 選択中のタグ表示
            if (selectedTag.value != null)
              Text(
                "選択中のタグ: ${selectedTag.value}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
            // イベントリスト表示
            Expanded(
              child: filteredEvents.value.isEmpty
                  ? const Center(
                      child: Text("選択されたタグに一致するイベントはありません。"),
                    )
                  : ListView.builder(
                      itemCount: filteredEvents.value.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents.value[index];
                        return Card(
                          child: ListTile(
                            title: Text(event["title"]),
                            subtitle: Text("タグ: ${event["tags"].join(", ")}"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
