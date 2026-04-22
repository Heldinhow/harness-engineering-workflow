const { format_timestamp } = require('./timestamp-utils');

describe('format_timestamp', () => {
    test('REQ-1: Function accepts timestamp (number) and timezone (string)', () => {
        expect(typeof format_timestamp).toBe('function');
        const result = format_timestamp(0, 'UTC');
        expect(typeof result).toBe('string');
    });

    test('REQ-2: Function returns formatted string in YYYY-MM-DD HH:mm:ss Z pattern', () => {
        const result = format_timestamp(1705320000, 'UTC');
        expect(result).toMatch(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [A-Z]{3,4}$/);
    });

    test('REQ-3: UTC timezone works correctly', () => {
        const result = format_timestamp(0, 'UTC');
        expect(result).toBe('1970-01-01 00:00:00 UTC');
    });

    test('REQ-3: America/New_York timezone works correctly', () => {
        const result = format_timestamp(0, 'America/New_York');
        expect(result).toBe('1969-12-31 19:00:00 EST');
    });

    test('REQ-3: Europe/London timezone works correctly', () => {
        const result = format_timestamp(0, 'Europe/London');
        expect(result).toBe('1970-01-01 00:00:00 GMT');
    });

    test('REQ-3: Asia/Tokyo timezone works correctly', () => {
        const result = format_timestamp(0, 'Asia/Tokyo');
        expect(result).toBe('1970-01-01 09:00:00 JST');
    });

    test('REQ-4: Unix timestamp is in seconds (not milliseconds)', () => {
        const result = format_timestamp(1705320000, 'UTC');
        expect(result).toContain('2024-01-15');
    });

    test('REQ-5: Invalid timezone falls back to UTC', () => {
        const result = format_timestamp(0, 'Invalid/Timezone');
        expect(result).toBe('1970-01-01 00:00:00 UTC');
    });

    test('REQ-5: Empty timezone falls back to UTC', () => {
        const result = format_timestamp(0, '');
        expect(result).toBe('1970-01-01 00:00:00 UTC');
    });

    test('REQ-6: Output format is YYYY-MM-DD HH:mm:ss Z', () => {
        const timestamp = 1705320000;
        const result = format_timestamp(timestamp, 'UTC');
        const expectedPattern = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [A-Z]{3,4}$/;
        expect(result).toMatch(expectedPattern);
    });

    test('EVAL-4: Edge case - timestamp 0 (Unix epoch)', () => {
        const result = format_timestamp(0, 'UTC');
        expect(result).toBe('1970-01-01 00:00:00 UTC');
    });

    test('EVAL-4: Edge case - negative timestamp', () => {
        const result = format_timestamp(-86400, 'UTC');
        expect(result).toBe('1969-12-31 00:00:00 UTC');
    });
});