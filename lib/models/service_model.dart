import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class ServiceAddon {
  final String id;
  final String title;
  final String description;
  final double price;
  final int estimatedMinutes;

  const ServiceAddon({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.estimatedMinutes,
  });
}

class ServiceItem {
  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String durationText;
  final IconData icon;
  final List<String> inclusions;
  final List<ServiceAddon> availableAddons;
  final bool isPopular;

  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.durationText,
    required this.icon,
    required this.inclusions,
    required this.availableAddons,
    this.isPopular = false,
  });

  double get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).roundToDouble();
  }
}
