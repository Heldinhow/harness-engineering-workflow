// Sample fixture file for workflow benchmark
// This file serves as the implementation target for the simple-feature scenario

/**
 * Format a Unix timestamp in a human-readable format
 * @param {number} timestamp - Unix timestamp in seconds
 * @param {string} timezone - Timezone identifier (e.g., 'UTC', 'America/New_York')
 * @returns {string} Formatted timestamp string in "YYYY-MM-DD HH:mm:ss Z" format
 */
function format_timestamp(timestamp, timezone) {
    if (typeof timestamp !== 'number') {
        throw new Error('Timestamp must be a number');
    }

    const timezoneLower = timezone.toLowerCase();
    const validTimezones = ['utc', 'america/new_york', 'europe/london', 'asia/tokyo'];

    let tz = timezone;
    if (!validTimezones.some(tz_lower => tz_lower === timezoneLower)) {
        tz = 'UTC';
    }

    const date = new Date(timestamp * 1000);
    const options = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
        timeZone: tz
    };

    const parts = new Intl.DateTimeFormat('en-CA', options).formatToParts(date);
    const get = (type) => parts.find(p => p.type === type)?.value || '';

    const year = get('year');
    const month = get('month');
    const day = get('day');
    const hour = get('hour');
    const minute = get('minute');
    const second = get('second');

    const tzAbbr = new Intl.DateTimeFormat('en-US', {
        timeZone: tz,
        timeZoneName: 'short'
    }).formatToParts(date).find(p => p.type === 'timeZoneName')?.value || 'UTC';

    return `${year}-${month}-${day} ${hour}:${minute}:${second} ${tzAbbr}`;
}

module.exports = { format_timestamp };
