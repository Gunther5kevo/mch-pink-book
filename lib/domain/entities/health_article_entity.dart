/// Health Article Entity (Domain Layer)
/// Represents health education content
library;

import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

class HealthArticleEntity extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String body; // Markdown content
  final String? summary;
  final String category; // breastfeeding, nutrition, danger_signs, etc
  final LanguageCode language;
  final String? authorId;
  final List<String> tags;
  final String? imageUrl;
  final String? pdfUrl;
  final String? audioUrl;
  final String? videoUrl;
  final int readCount;
  final bool isPublished;
  final DateTime? publishedAt;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HealthArticleEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
    this.summary,
    required this.category,
    required this.language,
    this.authorId,
    required this.tags,
    this.imageUrl,
    this.pdfUrl,
    this.audioUrl,
    this.videoUrl,
    required this.readCount,
    required this.isPublished,
    this.publishedAt,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if article has audio content
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Check if article has video content
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  /// Check if article has PDF attachment
  bool get hasPdf => pdfUrl != null && pdfUrl!.isNotEmpty;

  /// Check if article has image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if article has multimedia content
  bool get hasMultimedia => hasAudio || hasVideo || hasPdf;

  /// Get estimated reading time in minutes
  int get estimatedReadingTime {
    // Average reading speed: 200 words per minute
    final wordCount = body.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// Get category display name
  String get categoryDisplay {
    switch (category.toLowerCase()) {
      case 'breastfeeding':
        return language == LanguageCode.sw ? 'Kunyonyesha' : 'Breastfeeding';
      case 'nutrition':
        return language == LanguageCode.sw ? 'Lishe' : 'Nutrition';
      case 'danger_signs':
        return language == LanguageCode.sw ? 'Dalili za Hatari' : 'Danger Signs';
      case 'child_development':
        return language == LanguageCode.sw ? 'Ukuaji wa Mtoto' : 'Child Development';
      case 'pregnancy':
        return language == LanguageCode.sw ? 'Ujauzito' : 'Pregnancy';
      case 'immunization':
        return language == LanguageCode.sw ? 'Chanjo' : 'Immunization';
      default:
        return category;
    }
  }

  /// Get formatted published date
  String get formattedPublishedDate {
    if (publishedAt == null) return 'Draft';
    return '${publishedAt!.day}/${publishedAt!.month}/${publishedAt!.year}';
  }

  /// Get content type badges
  List<String> get contentBadges {
    final badges = <String>[];
    if (hasAudio) badges.add('Audio');
    if (hasVideo) badges.add('Video');
    if (hasPdf) badges.add('PDF');
    return badges;
  }

  HealthArticleEntity copyWith({
    String? id,
    String? title,
    String? slug,
    String? body,
    String? summary,
    String? category,
    LanguageCode? language,
    String? authorId,
    List<String>? tags,
    String? imageUrl,
    String? pdfUrl,
    String? audioUrl,
    String? videoUrl,
    int? readCount,
    bool? isPublished,
    DateTime? publishedAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthArticleEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      language: language ?? this.language,
      authorId: authorId ?? this.authorId,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      readCount: readCount ?? this.readCount,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        body,
        summary,
        category,
        language,
        authorId,
        tags,
        imageUrl,
        pdfUrl,
        audioUrl,
        videoUrl,
        readCount,
        isPublished,
        publishedAt,
        metadata,
        createdAt,
        updatedAt,
      ];
}