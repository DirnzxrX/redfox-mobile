import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsGroup('Account', [
            _buildSettingsItem(Icons.lock_outline, 'Change Password'),
            _buildSettingsItem(Icons.notifications_active_outlined, 'Notifications'),
            _buildSettingsItem(Icons.language, 'Language', trailing: 'English'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup('Privacy', [
            _buildSettingsItem(Icons.security, 'Two-Factor Authentication'),
            _buildSettingsItem(Icons.visibility_off_outlined, 'Data Visibility'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup('App', [
            _buildSettingsItem(Icons.dark_mode_outlined, 'Theme', trailing: 'Dark'),
            _buildSettingsItem(Icons.info_outline, 'App Version', trailing: '2.5.0'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: const TextStyle(color: AppColors.primaryAccent, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(title, style: const TextStyle(color: AppColors.textMain, fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) Text(trailing, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
      onTap: () {},
    );
  }
}