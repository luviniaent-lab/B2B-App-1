import React, { useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TextInput,
  StyleSheet,
  SafeAreaView,
  StatusBar,
  TouchableOpacity,
  Modal,
} from 'react-native';
import { useAppSelector } from '../hooks/useAppSelector';
import { AnimatedBackground } from '../components/ui/AnimatedBackground';
import { GlassCard } from '../components/ui/GlassCard';
import { NeonButton } from '../components/ui/NeonButton';
import { OfferCard } from '../components/ui/OfferCard';
import { OfferForm } from '../components/forms/OfferForm';
import { Offer } from '../types';
import { colors, spacing, textStyles, borderRadius } from '../theme';


export const OffersScreen: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const offers = useAppSelector(state => state.app.offers);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [statusFilter, setStatusFilter] = useState<'all' | 'active' | 'deactivated'>('all');

  const filteredOffers = offers.filter(offer => {
    const matchesSearch = offer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         offer.startDate.includes(searchQuery) ||
                         offer.endDate.includes(searchQuery);
    const matchesStatus = statusFilter === 'all' || offer.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const renderOffer = ({ item }: { item: Offer }) => (
    <OfferCard
      offer={item}
      onPress={() => console.log('Navigate to offer:', item.id)}
    />
  );

  const handleCreateOffer = (offerData: Partial<Offer>) => {
    console.log('Create offer:', offerData);
    setShowCreateModal(false);
  };

  return (
    <AnimatedBackground>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor={colors.background} />
        
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Offers</Text>
          <Text style={styles.subtitle}>Manage promotions 🎁</Text>
        </View>

        {/* Search and Filter */}
        <GlassCard style={styles.searchContainer}>
          <View style={styles.searchBar}>
            <Text style={styles.searchIcon}>🔍</Text>
            <TextInput
              style={styles.searchInput}
              placeholder="Search offers..."
              placeholderTextColor={colors.textMuted}
              value={searchQuery}
              onChangeText={setSearchQuery}
            />
          </View>
          
          <View style={styles.filterRow}>
            <View style={styles.filterChips}>
              {(['all', 'active', 'deactivated'] as const).map((status) => (
                <TouchableOpacity
                  key={status}
                  style={[
                    styles.filterChip,
                    statusFilter === status && styles.filterChipActive
                  ]}
                  onPress={() => setStatusFilter(status)}
                >
                  <Text style={[
                    styles.filterChipText,
                    statusFilter === status && styles.filterChipTextActive
                  ]}>
                    {status.charAt(0).toUpperCase() + status.slice(1)}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
            
            <NeonButton
              title="Create+"
              onPress={() => setShowCreateModal(true)}
              variant="neon"
              size="sm"
              style={styles.createButton}
            />
          </View>
        </GlassCard>

        {/* Offers List */}
        <FlatList
          data={filteredOffers}
          renderItem={renderOffer}
          keyExtractor={(item) => item.id}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.listContainer}
        />

        {/* Create Offer Modal */}
        <Modal
          visible={showCreateModal}
          animationType="slide"
          presentationStyle="pageSheet"
          onRequestClose={() => setShowCreateModal(false)}
        >
          <SafeAreaView style={styles.modalContainer}>
            <View style={styles.modalHeader}>
              <TouchableOpacity onPress={() => setShowCreateModal(false)}>
                <Text style={styles.cancelButton}>Cancel</Text>
              </TouchableOpacity>
              <Text style={styles.modalTitle}>Create Offer</Text>
              <View style={styles.placeholder} />
            </View>
            <OfferForm onSubmit={handleCreateOffer} />
          </SafeAreaView>
        </Modal>
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
  searchContainer: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    paddingHorizontal: spacing.md,
    marginBottom: spacing.md,
  },
  searchIcon: {
    fontSize: 18,
    marginRight: spacing.sm,
  },
  searchInput: {
    flex: 1,
    ...textStyles.body,
    color: colors.textPrimary,
    paddingVertical: spacing.md,
  },
  filterRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  filterChips: {
    flexDirection: 'row',
    flex: 1,
  },
  filterChip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.lg,
    backgroundColor: colors.surface,
    marginRight: spacing.sm,
    borderWidth: 1,
    borderColor: colors.textMuted,
  },
  filterChipActive: {
    backgroundColor: colors.secondary,
    borderColor: colors.secondary,
  },
  filterChipText: {
    ...textStyles.caption,
    color: colors.textSecondary,
    fontWeight: '600',
  },
  filterChipTextActive: {
    color: colors.textPrimary,
  },
  createButton: {
    minWidth: 100,
  },
  listContainer: {
    paddingBottom: spacing['6xl'],
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
});