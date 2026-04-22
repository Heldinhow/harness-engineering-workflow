const { format_timestamp } = require('./timestamp-utils');

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