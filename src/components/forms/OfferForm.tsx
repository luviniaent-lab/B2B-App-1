import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { GlassCard } from '../ui/GlassCard';
import { NeonButton } from '../ui/NeonButton';
import { Offer } from '../../types';
import { colors, spacing, textStyles, borderRadius } from '../../theme';

interface OfferFormProps {
  onSubmit: (offerData: Partial<Offer>) => void;
  initialData?: Partial<Offer>;
}

export const OfferForm: React.FC<OfferFormProps> = ({ onSubmit, initialData }) => {
  const [formData, setFormData] = useState({
    name: initialData?.name || '',
    description: initialData?.description || '',
    startDate: initialData?.startDate || '',
    endDate: initialData?.endDate || '',
    discountType: initialData?.discountType || '%',
    amount: initialData?.amount || '',
  });

  const handleSubmit = () => {
    if (!formData.name.trim()) {
      Alert.alert('Error', 'Please enter offer name');
      return;
    }
    
    if (!formData.startDate.trim() || !formData.endDate.trim()) {
      Alert.alert('Error', 'Please enter start and end dates');
      return;
    }

    const offerData: Partial<Offer> = {
      ...formData,
      status: 'active',
      propertyIds: ['p1'], // Default to first property
    };

    onSubmit(offerData);
  };

  const updateField = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      <GlassCard style={styles.formCard}>
        <Text style={styles.sectionTitle}>Offer Details</Text>
        
        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Name *</Text>
          <TextInput
            style={styles.input}
            value={formData.name}
            onChangeText={(value) => updateField('name', value)}
            placeholder="Enter offer name"
            placeholderTextColor={colors.textMuted}
          />
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Description</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={formData.description}
            onChangeText={(value) => updateField('description', value)}
            placeholder="Enter offer description"
            placeholderTextColor={colors.textMuted}
            multiline
            numberOfLines={3}
          />
        </View>

        <View style={styles.row}>
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>Start Date (DDMMYYYY) *</Text>
            <TextInput
              style={styles.input}
              value={formData.startDate}
              onChangeText={(value) => updateField('startDate', value)}
              placeholder="10082025"
              placeholderTextColor={colors.textMuted}
              keyboardType="numeric"
              maxLength={8}
            />
          </View>
          
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>End Date (DDMMYYYY) *</Text>
            <TextInput
              style={styles.input}
              value={formData.endDate}
              onChangeText={(value) => updateField('endDate', value)}
              placeholder="31082025"
              placeholderTextColor={colors.textMuted}
              keyboardType="numeric"
              maxLength={8}
            />
          </View>
        </View>

        <Text style={styles.sectionTitle}>Discount Details</Text>
        
        <View style={styles.discountTypeContainer}>
          <Text style={styles.inputLabel}>Discount Type</Text>
          <View style={styles.discountTypes}>
            {['%', 'Flat', 'BuyXGetY'].map((type) => (
              <TouchableOpacity
                key={type}
                style={[
                  styles.discountTypeChip,
                  formData.discountType === type && styles.discountTypeChipActive
                ]}
                onPress={() => updateField('discountType', type)}
              >
                <Text style={[
                  styles.discountTypeText,
                  formData.discountType === type && styles.discountTypeTextActive
                ]}>
                  {type}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Amount</Text>
          <TextInput
            style={styles.input}
            value={formData.amount}
            onChangeText={(value) => updateField('amount', value)}
            placeholder={formData.discountType === '%' ? '30' : '₹500'}
            placeholderTextColor={colors.textMuted}
            keyboardType={formData.discountType === '%' ? 'numeric' : 'default'}
          />
        </View>

        <NeonButton
          title="Create Offer"
          onPress={handleSubmit}
          variant="secondary"
          style={styles.submitButton}
        />
      </GlassCard>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing.lg,
  },
  formCard: {
    marginBottom: spacing.xl,
  },
  sectionTitle: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.lg,
  },
  inputGroup: {
    marginBottom: spacing.lg,
  },
  inputLabel: {
    ...textStyles.body,
    color: colors.textSecondary,
    marginBottom: spacing.sm,
    fontWeight: '600',
  },
  input: {
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    ...textStyles.body,
    color: colors.textPrimary,
    borderWidth: 1,
    borderColor: colors.textMuted,
  },
  textArea: {
    height: 80,
    textAlignVertical: 'top',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  halfWidth: {
    width: '48%',
  },
  discountTypeContainer: {
    marginBottom: spacing.lg,
  },
  discountTypes: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  discountTypeChip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.lg,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.textMuted,
  },
  discountTypeChipActive: {
    backgroundColor: colors.secondary,
    borderColor: colors.secondary,
  },
  discountTypeText: {
    ...textStyles.caption,
    color: colors.textSecondary,
    fontWeight: '600',
  },
  discountTypeTextActive: {
    color: colors.textPrimary,
  },
  submitButton: {
    marginTop: spacing.lg,
  },
});