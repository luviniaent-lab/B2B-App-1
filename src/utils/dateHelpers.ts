export const formatDate = (dateStr: string): string => {
  if (dateStr.length === 8) {
    const day = dateStr.substring(0, 2);
    const month = dateStr.substring(2, 4);
    const year = dateStr.substring(4, 8);
    return `${day}/${month}/${year}`;
  }
  return dateStr;
};

export const parseDate = (dateStr: string): Date | null => {
  if (dateStr.length === 8) {
    const day = parseInt(dateStr.substring(0, 2));
    const month = parseInt(dateStr.substring(2, 4)) - 1; // Month is 0-indexed
    const year = parseInt(dateStr.substring(4, 8));
    return new Date(year, month, day);
  }
  return null;
};

export const isDateInRange = (dateStr: string, startDate: string, endDate: string): boolean => {
  const date = parseDate(dateStr);
  const start = parseDate(startDate);
  const end = parseDate(endDate);
  
  if (!date || !start || !end) return false;
  
  return date >= start && date <= end;
};

export const getCurrentDateString = (): string => {
  const now = new Date();
  const day = now.getDate().toString().padStart(2, '0');
  const month = (now.getMonth() + 1).toString().padStart(2, '0');
  const year = now.getFullYear().toString();
  return `${day}${month}${year}`;
};