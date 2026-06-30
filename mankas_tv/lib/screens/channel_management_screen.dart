import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/admin_service.dart';
import '../services/snackbar_service.dart';
import '../utils/app_strings.dart';
import 'channel_edit_screen.dart';

class ChannelManagementScreen extends StatefulWidget {
  const ChannelManagementScreen({super.key});

  @override
  State<ChannelManagementScreen> createState() => _ChannelManagementScreenState();
}

class _ChannelManagementScreenState extends State<ChannelManagementScreen> {
  final AdminService _admin = AdminService();
  List<Channel> _channels = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    setState(() => _isLoading = true);
    try {
      _channels = await _admin.getAllChannels();
    } catch (e) {
      if (mounted) {
        AppSnackBarService.instance.error('Erreur: $e');
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  List<Channel> get _filteredChannels {
    if (_searchQuery.isEmpty) return _channels;
    return _channels.where((c) =>
      c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (c.category?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
      (c.country?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  Future<void> _deleteChannel(Channel channel) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la chaîne'),
        content: Text('Supprimer "${channel.name}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _admin.deleteChannel(channel.id);
      AppSnackBarService.instance.success('"${channel.name}" supprimée');
      _loadChannels();
    } catch (e) {
      AppSnackBarService.instance.error('Erreur: $e');
    }
  }

  Future<void> _editChannel(Channel? channel) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelEditScreen(channel: channel),
      ),
    );
    if (result == true) _loadChannels();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.of(context).channels} (${_channels.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChannels,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editChannel(null),
        tooltip: AppStrings.of(context).addChannel,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.of(context).searchHint,
                prefixIcon: const Icon(Icons.search, size: 22),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredChannels.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.of(context).noChannels,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _filteredChannels.length,
                        itemBuilder: (context, index) {
                          final channel = _filteredChannels[index];
                          return ListTile(
                            leading: channel.logo != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(channel.logo!),
                                    onBackgroundImageError: (_, __) {},
                                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  )
                                : CircleAvatar(
                                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                    child: Icon(Icons.tv, color: theme.colorScheme.onSurfaceVariant),
                                  ),
                            title: Text(channel.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                              [channel.category, channel.country, channel.language]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _editChannel(channel),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 20, color: theme.colorScheme.error),
                                  onPressed: () => _deleteChannel(channel),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
