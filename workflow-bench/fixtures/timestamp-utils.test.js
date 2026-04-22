const { format_timestamp, parse_timestamp, format_timestamp_relative } = require('./timestamp-utils');

const tests = [];

function test(name, fn) {
    try {
        fn();
        tests.push({ name, passed: true });
    } catch (e) {
        tests.push({ name, passed: false, error: e.message });
    }
}

function assertEquals(actual, expected, msg) {
    if (actual !== expected) {
        throw new Error(`${msg || 'Assertion failed'}: expected "${expected}", got "${actual}"`);
    }
}

// Test 1: UTC timezone with timestamp 0 (Unix epoch)
test('timestamp 0 with UTC', () => {
    const result = format_timestamp(0, 'UTC');
    assertEquals(result, '1970-01-01 00:00:00 UTC', 'Unix epoch UTC');
});

// Test 2: America/New_York timezone
test('timestamp 0 with America/New_York', () => {
    const result = format_timestamp(0, 'America/New_York');
    assertEquals(result, '1969-12-31 19:00:00 EST', 'Unix epoch NY');
});

// Test 3: Europe/London timezone
test('timestamp 0 with Europe/London', () => {
    const result = format_timestamp(0, 'Europe/London');
    assertEquals(result, '1970-01-01 01:00:00 GMT+1', 'Unix epoch London');
});

// Test 4: Asia/Tokyo timezone
test('timestamp 0 with Asia/Tokyo', () => {
    const result = format_timestamp(0, 'Asia/Tokyo');
    assertEquals(result, '1970-01-01 09:00:00 GMT+9', 'Unix epoch Tokyo');
});

// Test 5: Invalid timestamp throws error
test('invalid timestamp throws error', () => {
    let threw = false;
    try {
        format_timestamp('not a number', 'UTC');
    } catch (e) {
        threw = true;
        if (!e.message.includes('Timestamp must be a number')) {
            throw new Error('Wrong error message: ' + e.message);
        }
    }
    if (!threw) throw new Error('Should have thrown');
});

// Test 6: Invalid timezone defaults to UTC
test('invalid timezone defaults to UTC', () => {
    const result = format_timestamp(0, 'Invalid/Timezone');
    assertEquals(result, '1970-01-01 00:00:00 UTC', 'Invalid should default to UTC');
});

// Test 7: Specific timestamp (1609459200 = 2021-01-01 00:00:00 UTC)
test('specific timestamp 1609459200 UTC', () => {
    const result = format_timestamp(1609459200, 'UTC');
    assertEquals(result, '2021-01-01 00:00:00 UTC', '2021-01-01 UTC');
});

// Test 8: parse_timestamp UTC
test('parse_timestamp UTC', () => {
    const result = parse_timestamp('1970-01-01 00:00:00 UTC');
    assertEquals(result, 0, 'Unix epoch UTC');
});

// Test 9: parse_timestamp America/New_York
test('parse_timestamp America/New_York', () => {
    const result = parse_timestamp('1970-01-01 00:00:00 UTC');
    assertEquals(result, 0, 'Unix epoch UTC parsed');
});

// Test 10: parse_timestamp invalid input throws error
test('parse_timestamp invalid input throws error', () => {
    let threw = false;
    try {
        parse_timestamp(12345);
    } catch (e) {
        threw = true;
        if (!e.message.includes('Formatted timestamp must be a string')) {
            throw new Error('Wrong error message: ' + e.message);
        }
    }
    if (!threw) throw new Error('Should have thrown');
});

// Test 11: parse_timestamp invalid format throws error
test('parse_timestamp invalid format throws error', () => {
    let threw = false;
    try {
        parse_timestamp('not-a-valid-format');
    } catch (e) {
        threw = true;
        if (!e.message.includes('Invalid timestamp format')) {
            throw new Error('Wrong error message: ' + e.message);
        }
    }
    if (!threw) throw new Error('Should have thrown');
});

// Test 12: parse_timestamp and format_timestamp roundtrip
test('parse_timestamp format_timestamp roundtrip', () => {
    const original = 1609459200;
    const formatted = format_timestamp(original, 'UTC');
    const parsed = parse_timestamp(formatted);
    assertEquals(parsed, original, 'Roundtrip should preserve timestamp');
});

// Test 13: format_timestamp_relative past timestamp returns "X ago"
test('format_timestamp_relative past timestamp returns X ago', () => {
    const now = Math.floor(Date.now() / 1000);
    const pastTimestamp = now - 7200;
    const result = format_timestamp_relative(pastTimestamp);
    if (!result.endsWith(' ago')) {
        throw new Error('Expected result to end with " ago", got: ' + result);
    }
});

// Test 14: format_timestamp_relative future timestamp returns "in X"
test('format_timestamp_relative future timestamp returns in X', () => {
    const now = Math.floor(Date.now() / 1000);
    const futureTimestamp = now + 7200;
    const result = format_timestamp_relative(futureTimestamp);
    if (!result.startsWith('in ')) {
        throw new Error('Expected result to start with "in ", got: ' + result);
    }
});

// Test 15: format_timestamp_relative near timestamp returns "just now"
test('format_timestamp_relative near timestamp returns just now', () => {
    const now = Math.floor(Date.now() / 1000);
    const nearTimestamp = now + 30;
    const result = format_timestamp_relative(nearTimestamp);
    assertEquals(result, 'just now', 'Near timestamp should return just now');
});

// Test 16: format_timestamp_relative invalid input throws error
test('format_timestamp_relative invalid input throws error', () => {
    let threw = false;
    try {
        format_timestamp_relative('not a number');
    } catch (e) {
        threw = true;
        if (!e.message.includes('Timestamp must be a number')) {
            throw new Error('Wrong error message: ' + e.message);
        }
    }
    if (!threw) throw new Error('Should have thrown');
});

// Print results
console.log('\n=== Test Results ===');
let passed = 0;
let failed = 0;
tests.forEach(t => {
    const status = t.passed ? 'PASS' : 'FAIL';
    console.log(`[${status}] ${t.name}`);
    if (!t.passed) {
        console.log(`       Error: ${t.error}`);
        failed++;
    } else {
        passed++;
    }
});
console.log(`\nTotal: ${passed} passed, ${failed} failed`);

if (failed > 0) {
    process.exit(1);
}