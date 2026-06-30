import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/shelter.dart';

Future<void> showNavigateDialog(
  BuildContext context, {
  required Shelter shelter,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('길 안내'),
      content: Text(
        '${shelter.name}까지\n네이버맵으로 안내할까요?',
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('안내 시작'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    await _launchNaverMaps(shelter);
  }
}

Future<void> _launchNaverMaps(Shelter shelter) async {
  final name = Uri.encodeComponent(shelter.name);
  final appUrl = Uri.parse(
    'nmap://route/walk'
    '?dlat=${shelter.latitude}'
    '&dlng=${shelter.longitude}'
    '&dname=$name'
    '&appname=com.example.climaguard',
  );
  // 네이버맵 앱 미설치 시 웹 폴백
  final webUrl = Uri.parse(
    'https://map.naver.com/v5/directions/-/-/-/walk'
    '?c=14,0,0,0,dh',
  );

  if (await canLaunchUrl(appUrl)) {
    await launchUrl(appUrl, mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(webUrl, mode: LaunchMode.externalApplication);
  }
}
