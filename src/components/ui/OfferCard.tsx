import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
  ImageBackground,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { GlassCard } from './GlassCard';
import { Offer } from '../../types';
import { colors, spacing, borderRadius, textStyles } from '../../theme';

const { width } = Dimensions.get('window');

interface OfferCardProps {
  offer: Offer;
  onPress: () => void;
}

export const OfferCard: React.FC<OfferCardProps> = ({ offer, onPress }) => {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return colors.success;
      case 'deactivated': return colors.error;
      default: return colors.textMuted;
    }
  };

  const formatDate = (dateStr: string) => {
    if (dateStr.length === 8) {
      const day = dateStr.substring(0, 2);
      const month = dateStr.substring(2, 4);
      const year = dateStr.substring(4, 8);
      return `${day}/${month}/${year}`;
    }
    return dateStr;
  };

  const isActive = () => {
    const now = new Date();
    const start = new Date(
      parseInt(offer.startDate.substring(4, 8)),
      parseInt(offer.startDate.substring(2, 4)) - 1,
      parseInt(offer.startDate.substring(0, 2))
    );
    const end = new Date(
      parseInt(offer.endDate.substring(4, 8)),
      parseInt(offer.endDate.substring(2, 4)) - 1,
      parseInt(offer.endDate.substring(0, 2))
    );
    return now >= start && now <= end;
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.9}>
      <GlassCard style={styles.card} neonBorder>
        <View style={styles.imageContainer}>
          {offer.image ? (
            <ImageBackground
              source={{ uri: offer.image }}
              style={styles.image}
              imageStyle={styles.imageStyle}
            >
              <LinearGradient
                colors={['transparent', 'rgba(0,0,0,0.8)']}
                style={styles.imageOverlay}
              />
            </ImageBackground>
          ) : (
            <LinearGradient
              colors={[colors.secondary, colors.neonGreen]}
              style={styles.placeholderImage}
            >
              <Text style={styles.placeholderIcon}>🎁</Text>
            </LinearGradient>
          )}
          
          {/* Status Badge */}
          <View style={[styles.statusBadge, { backgroundColor: getStatusColor(offer.status) }]}>
            <Text style={styles.statusText}>
              {isActive() ? 'LIVE' : offer.status.toUpperCase()}
            </Text>
          </View>
        </View>

        <View style={styles.content}>
          <Text style={styles.title} numberOfLines={2}>
            {offer.name}
          </Text>
          
          {offer.description && (
            <Text style={styles.description} numberOfLines={2}>
              {offer.description}
            </Text>
          )}
          
          <View style={styles.details}>
            <View style={styles.detailRow}>
              <Text style={styles.detailIcon}>📅</Text>
              <Text style={styles.detailText}>
                {formatDate(offer.startDate)} - {formatDate(offer.endDate)}
              </Text>
            </View>
            
            {(offer.discountType && offer.amount) && (
              <View style={styles.detailRow}>
                <Text style={styles.detailIcon}>💰</Text>
                <Text style={styles.discountText}>
                  {offer.discountType === '%' ? `${offer.amount}% OFF` : `${offer.amount} OFF`}
                </Text>
              </View>
            )}
          </View>

          {offer.bookingsCount !== undefined && (
            <View style={styles.bookingsContainer}>
              <LinearGradient
                colors={[colors.neonGreen, colors.secondary]}
                style={styles.bookingsGradient}
              >
                <Text style={styles.bookingsText}>
                  {offer.bookingsCount} bookings
                </Text>
              </LinearGradient>
            </View>
          )}
        </View>
      </GlassCard>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginVertical: spacing.sm,
    width: width - spacing.md * 2,
  },
  imageContainer: {
    height: 160,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
    marginBottom: spacing.md,
    position: 'relative',
  },
  image: {
    flex: 1,
  },
  imageStyle: {
    borderRadius: borderRadius.lg,
  },
  imageOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: '50%',
  },
  placeholderImage: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: borderRadius.lg,
  },
  placeholderIcon: {
    fontSize: 48,
  },
  statusBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.md,
  },
  statusText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '700',
    fontSize: 10,
  },
  content: {
    paddingHorizontal: spacing.sm,
  },
  title: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.xs,
  },
  description: {
    ...textStyles.body,
    color: colors.textSecondary,
    marginBottom: spacing.md,
    fontSize: 14,
  },
  details: {
    marginBottom: spacing.md,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.xs,
  },
  detailIcon: {
    fontSize: 14,
    marginRight: spacing.xs,
  },
  detailText: {
    ...textStyles.caption,
    color: colors.textSecondary,
  },
  discountText: {
    ...textStyles.caption,
    color: colors.neonGreen,
    fontWeight: '700',
  },
  bookingsContainer: {
    alignSelf: 'flex-start',
  },
  bookingsGradient: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.lg,
  },
  bookingsText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '600',
  },
});