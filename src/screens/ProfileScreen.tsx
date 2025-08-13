import React, { useState } from 'react';
import {
  View,
  Text,
  ScrollView,
  StyleSheet,
  SafeAreaView,
  StatusBar,
  TouchableOpacity,
  Modal,
} from 'react-native';
import { AnimatedBackground } from '../components/ui/AnimatedBackground';
import { GlassCard } from '../components/ui/GlassCard';
import { NeonButton } from '../components/ui/NeonButton';
import { ProfileInfo } from '../types';
import { colors, spacing, textStyles, borderRadius } from '../theme';

// Mock data
const mockProfile: ProfileInfo = {
  name: 'Your Name',
  email: 'you@example.com',
  phone: '+91 90000 00000',
  aadhaar: 'XXXX-XXXX-XXXX',
  businessId: 'BIZ-123456',
  address: 'Address line, City, State',
  companyVerified: true,
};

export const ProfileScreen: React.FC = () => {
  const [profile] = useState<ProfileInfo>(mockProfile);
  const [showAnalytics, setShowAnalytics] = useState(false);

  const ProfileRow: React.FC<{
    label: string;
    value: string;
    verified?: boolean;
    editable?: boolean;
    onEdit?: () => void;
  }> = ({ label, value, verified, editable, onEdit }) => (
    <View style={styles.profileRow}>
      <Text style={styles.profileLabel}>{label}</Text>
      <View style={styles.profileValueContainer}>
        <Text style={styles.profileValue}>{value}</Text>
        {verified && (
          <View style={styles.verifiedBadge}>
            <Text style={styles.verifiedText}>✓</Text>
          </View>
        )}
        {editable && (
          <TouchableOpacity onPress={onEdit} style={styles.editButton}>
            <Text style={styles.editButtonText}>Edit</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );

  return (
    <AnimatedBackground>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor={colors.background} />
        
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Profile</Text>
          <Text style={styles.subtitle}>Manage your account 👤</Text>
        </View>

        <ScrollView showsVerticalScrollIndicator={false}>
          {/* Profile Card */}
          <GlassCard style={styles.profileCard}>
            <View style={styles.avatarContainer}>
              <View style={styles.avatar}>
                <Text style={styles.avatarText}>
                  {profile.name.charAt(0).toUpperCase()}
                </Text>
              </View>
              <Text style={styles.profileName}>{profile.name}</Text>
            </View>

            <View style={styles.profileDetails}>
              <ProfileRow
                label="Email"
                value={profile.email}
                editable
                onEdit={() => console.log('Edit email')}
              />
              <ProfileRow
                label="Phone"
                value={profile.phone}
                editable
                onEdit={() => console.log('Edit phone')}
              />
              <ProfileRow
                label="Aadhaar"
                value={profile.aadhaar}
                verified={false}
              />
              <ProfileRow
                label="Business ID"
                value={profile.businessId}
                verified={profile.companyVerified}
              />
              <ProfileRow
                label="Address"
                value={profile.address}
                editable
                onEdit={() => console.log('Edit address')}
              />
            </View>
          </GlassCard>

          {/* Quick Actions */}
          <GlassCard style={styles.actionsCard}>
            <Text style={styles.actionsTitle}>Quick Actions</Text>
            
            <NeonButton
              title="📊 Analytics Overview"
              onPress={() => setShowAnalytics(true)}
              variant="primary"
              style={styles.actionButton}
            />
            
            <NeonButton
              title="👥 Manage Agents"
              onPress={() => console.log('Navigate to agents')}
              variant="secondary"
              style={styles.actionButton}
            />
            
            <NeonButton
              title="⭐ Ratings & Reviews"
              onPress={() => console.log('Navigate to ratings')}
              variant="ghost"
              style={styles.actionButton}
            />
          </GlassCard>

          {/* Analytics Modal */}
          <Modal
            visible={showAnalytics}
            animationType="slide"
            presentationStyle="pageSheet"
            onRequestClose={() => setShowAnalytics(false)}
          >
            <SafeAreaView style={styles.modalContainer}>
              <View style={styles.modalHeader}>
                <TouchableOpacity onPress={() => setShowAnalytics(false)}>
                  <Text style={styles.cancelButton}>Close</Text>
                </TouchableOpacity>
                <Text style={styles.modalTitle}>Analytics</Text>
                <View style={styles.placeholder} />
              </View>
              
              <ScrollView style={styles.analyticsContent}>
                <GlassCard style={styles.analyticsCard}>
                  <Text style={styles.analyticsTitle}>Performance Overview</Text>
                  
                  <View style={styles.metricsGrid}>
                    <View style={styles.metric}>
                      <Text style={styles.metricValue}>1,284</Text>
                      <Text style={styles.metricLabel}>Total Bookings</Text>
                    </View>
                    <View style={styles.metric}>
                      <Text style={styles.metricValue}>₹2.4L</Text>
                      <Text style={styles.metricLabel}>Revenue</Text>
                    </View>
                    <View style={styles.metric}>
                      <Text style={styles.metricValue}>4.8</Text>
                      <Text style={styles.metricLabel}>Avg Rating</Text>
                    </View>
                    <View style={styles.metric}>
                      <Text style={styles.metricValue}>89%</Text>
                      <Text style={styles.metricLabel}>Occupancy</Text>
                    </View>
                  </View>
                </GlassCard>
              </ScrollView>
            </SafeAreaView>
          </Modal>
        </ScrollView>
      </SafeAreaView>
    </AnimatedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.xl,
    paddingBottom: spacing.lg,
  },
  title: {
    ...textStyles.h1,
    color: colors.textPrimary,
    textAlign: 'center',
    marginBottom: spacing.xs,
  },
  subtitle: {
    ...textStyles.body,
    color: colors.textSecondary,
    textAlign: 'center',
  },
  profileCard: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
  },
  avatarContainer: {
    alignItems: 'center',
    marginBottom: spacing.xl,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  avatarText: {
    ...textStyles.h2,
    color: colors.textPrimary,
  },
  profileName: {
    ...textStyles.h3,
    color: colors.textPrimary,
  },
  profileDetails: {
    gap: spacing.lg,
  },
  profileRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  profileLabel: {
    ...textStyles.body,
    color: colors.textSecondary,
    flex: 1,
  },
  profileValueContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 2,
  },
  profileValue: {
    ...textStyles.body,
    color: colors.textPrimary,
    flex: 1,
  },
  verifiedBadge: {
    backgroundColor: colors.success,
    paddingHorizontal: spacing.xs,
    paddingVertical: 2,
    borderRadius: borderRadius.sm,
    marginLeft: spacing.sm,
  },
  verifiedText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontSize: 10,
    fontWeight: '600',
  },
  editButton: {
    marginLeft: spacing.sm,
  },
  editButtonText: {
    ...textStyles.caption,
    color: colors.primary,
    fontWeight: '600',
  },
  actionsCard: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
  },
  actionsTitle: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.lg,
  },
  actionButton: {
    marginBottom: spacing.md,
  },
  modalContainer: {
    flex: 1,
    backgroundColor: colors.background,
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
    borderBottomColor: colors.surface,
  },
  modalTitle: {
    ...textStyles.h3,
    color: colors.textPrimary,
  },
  cancelButton: {
    ...textStyles.body,
    color: colors.primary,
  },
  placeholder: {
    width: 60,
  },
  analyticsContent: {
    flex: 1,
    padding: spacing.lg,
  },
  analyticsCard: {
    marginBottom: spacing.lg,
  },
  analyticsTitle: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.lg,
  },
  metricsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  metric: {
    width: '48%',
    alignItems: 'center',
    marginBottom: spacing.lg,
  },
  metricValue: {
    ...textStyles.h2,
    color: colors.primary,
    marginBottom: spacing.xs,
  },
  metricLabel: {
    ...textStyles.caption,
    color: colors.textSecondary,
    textAlign: 'center',
  },
});