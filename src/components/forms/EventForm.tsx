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
import { EventItem } from '../../types';
import { colors, spacing, textStyles, borderRadius } from '../../theme';

interface EventFormProps {
  onSubmit: (eventData: Partial<EventItem>) => void;
  initialData?: Partial<EventItem>;
}

export const EventForm: React.FC<EventFormProps> = ({ onSubmit, initialData }) => {
  const [formData, setFormData] = useState({
    title: initialData?.title || '',
    date: initialData?.date || '',
    startTime: initialData?.startTime || '',
    price: initialData?.price || '',
    bookingLimit: initialData?.bookingLimit?.toString() || '',
    description: initialData?.description || '',
  });

  const [published, setPublished] = useState(initialData?.published ?? true);

  const handleSubmit = () => {
    if (!formData.title.trim()) {
      Alert.alert('Error', 'Please enter event title');
      return;
    }
    
    if (!formData.date.trim()) {
      Alert.alert('Error', 'Please enter event date');
      return;
    }

    const eventData: Partial<EventItem> = {
      ...formData,
      bookingLimit: formData.bookingLimit ? parseInt(formData.bookingLimit) : undefined,
      published,
      status: 'active',
      propertyIds: ['p1'], // Default to first property
    };

    onSubmit(eventData);
  };

  const updateField = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      <GlassCard style={styles.formCard}>
        <Text style={styles.sectionTitle}>Event Details</Text>
        
        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Title *</Text>
          <TextInput
            style={styles.input}
            value={formData.title}
            onChangeText={(value) => updateField('title', value)}
            placeholder="Enter event title"
            placeholderTextColor={colors.textMuted}
          />
        </View>

        <View style={styles.row}>
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>Date (DDMMYYYY) *</Text>
            <TextInput
              style={styles.input}
              value={formData.date}
              onChangeText={(value) => updateField('date', value)}
              placeholder="15082025"
              placeholderTextColor={colors.textMuted}
              keyboardType="numeric"
              maxLength={8}
            />
          </View>
          
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>Start Time</Text>
            <TextInput
              style={styles.input}
              value={formData.startTime}
              onChangeText={(value) => updateField('startTime', value)}
              placeholder="21:00"
              placeholderTextColor={colors.textMuted}
            />
          </View>
        </View>

        <View style={styles.row}>
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>Price</Text>
            <TextInput
              style={styles.input}
              value={formData.price}
              onChangeText={(value) => updateField('price', value)}
              placeholder="₹1500"
              placeholderTextColor={colors.textMuted}
            />
          </View>
          
          <View style={[styles.inputGroup, styles.halfWidth]}>
            <Text style={styles.inputLabel}>Booking Limit</Text>
            <TextInput
              style={styles.input}
              value={formData.bookingLimit}
              onChangeText={(value) => updateField('bookingLimit', value)}
              placeholder="200"
              placeholderTextColor={colors.textMuted}
              keyboardType="numeric"
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Description</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={formData.description}
            onChangeText={(value) => updateField('description', value)}
            placeholder="Enter event description"
            placeholderTextColor={colors.textMuted}
            multiline
            numberOfLines={4}
          />
        </View>

        <View style={styles.switchRow}>
          <Text style={styles.switchLabel}>Published</Text>
          <TouchableOpacity
            style={[styles.switch, published && styles.switchActive]}
            onPress={() => setPublished(!published)}
          >
            <View style={[styles.switchThumb, published && styles.switchThumbActive]} />
          </TouchableOpacity>
        </View>

        <NeonButton
          title="Create Event"
          onPress={handleSubmit}
          variant="primary"
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
    height: 100,
    textAlignVertical: 'top',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  halfWidth: {
    width: '48%',
  },
  switchRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: spacing.xl,
  },
  switchLabel: {
    ...textStyles.body,
    color: colors.textPrimary,
    fontWeight: '600',
  },
  switch: {
    width: 50,
    height: 30,
    borderRadius: 15,
    backgroundColor: colors.surface,
    justifyContent: 'center',
    paddingHorizontal: 2,
  },
  switchActive: {
    backgroundColor: colors.primary,
  },
  switchThumb: {
    width: 26,
    height: 26,
    borderRadius: 13,
    backgroundColor: colors.textMuted,
  },
  switchThumbActive: {
    backgroundColor: colors.textPrimary,
    alignSelf: 'flex-end',
  },
  submitButton: {
    marginTop: spacing.lg,
  },
});