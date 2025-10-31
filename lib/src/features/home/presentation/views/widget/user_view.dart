import 'package:flutter/material.dart';
import 'package:my_travaly/src/features/login/presentation/models/login_model.dart';

class UserView extends StatelessWidget {
  const UserView({super.key, required this.user});
  final LoginUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = user?.displayName.trim() ?? '';
    final initials = displayName.isNotEmpty
        ? displayName.split(' ').map((word) => word[0]).take(2).join()
        : '?';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: theme.colorScheme.primary,
        backgroundImage: user?.photoUrl != null
            ? NetworkImage(user!.photoUrl!)
            : null,
        child: user?.photoUrl == null
            ? Text(
                initials.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : null,
      ),
      title: Text(
        displayName.isNotEmpty ? displayName : 'traveler',
        style: theme.textTheme.titleLarge,
      ),
      subtitle: Text(user?.email ?? 'Sign in to explore curated stays.'),
    );
  }
}
