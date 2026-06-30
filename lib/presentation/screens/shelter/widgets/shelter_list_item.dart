import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/season.dart';
import '../../../../domain/entities/shelter.dart';

class ShelterListItem extends StatelessWidget {
  const ShelterListItem({
    super.key,
    required this.shelter,
    required this.season,
  });

  final Shelter shelter;
  final Season season;

  Color get _accentColor =>
      season.isHeat ? const Color(0xFFE64A19) : const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    shelter.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _DistanceBadge(
                  distanceKm: shelter.distanceKm,
                  color: _accentColor,
                ),
              ],
            ),
            if (shelter.address != null) ...[
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: shelter.address!,
                color: AppColors.textSecondary,
              ),
            ],
            if (shelter.operatingHours != null) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.access_time_outlined,
                text: shelter.operatingHours!,
                color: AppColors.textSecondary,
              ),
            ],
            if (shelter.phone != null && shelter.phone!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _PhoneRow(phone: shelter.phone!, accentColor: _accentColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.distanceKm, required this.color});

  final double distanceKm;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = distanceKm < 1
        ? '${(distanceKm * 1000).round()}m'
        : '${distanceKm.toStringAsFixed(1)}km';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ),
      ],
    );
  }
}

class _PhoneRow extends StatelessWidget {
  const _PhoneRow({required this.phone, required this.accentColor});

  final String phone;
  final Color accentColor;

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _call,
      child: Row(
        children: [
          Icon(Icons.phone_outlined, size: 14, color: accentColor),
          const SizedBox(width: 4),
          Text(
            phone,
            style: TextStyle(
              fontSize: 13,
              color: accentColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
