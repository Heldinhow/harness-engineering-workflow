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

/**
 * Parse a formatted timestamp string back to Unix timestamp
 * @param {string} formattedTimestamp - Timestamp in "YYYY-MM-DD HH:mm:ss Z" format
 * @returns {number} Unix timestamp in seconds
 */
function parse_timestamp(formattedTimestamp) {
    if (typeof formattedTimestamp !== 'string') {
        throw new Error('Formatted timestamp must be a string');
    }

    const pattern = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}) ([A-Z]{2,4})$/;
    const match = formattedTimestamp.match(pattern);

    if (!match) {
        throw new Error('Invalid timestamp format. Expected "YYYY-MM-DD HH:mm:ss Z"');
    }

    const [, year, month, day, hour, minute, second, tzAbbr] = match;

    const timezoneMap = {
        'UTC': 'UTC',
        'EST': 'America/New_York',
        'EDT': 'America/New_York',
        'GMT': 'Europe/London',
        'BST': 'Europe/London',
        'CET': 'Europe/Paris',
        'CEST': 'Europe/Paris',
        'JST': 'Asia/Tokyo',
        'KST': 'Asia/Seoul'
    };

    const timezone = timezoneMap[tzAbbr] || 'UTC';

    const date = new Date(Date.UTC(
        parseInt(year, 10),
        parseInt(month, 10) - 1,
        parseInt(day, 10),
        parseInt(hour, 10),
        parseInt(minute, 10),
        parseInt(second, 10)
    ));

    return Math.floor(date.getTime() / 1000);
}

/**
 * Format a Unix timestamp as a human-readable relative time string
 * @param {number} timestamp - Unix timestamp in seconds
 * @returns {string} Relative time string (e.g., "2 hours ago", "in 3 days", "just now")
 */
function format_timestamp_relative(timestamp) {
    if (typeof timestamp !== 'number') {
        throw new Error('Timestamp must be a number');
    }

    const now = Math.floor(Date.now() / 1000);
    const diff = timestamp - now;

    if (Math.abs(diff) < 60) {
        return 'just now';
    }

    const absDiff = Math.abs(diff);
    const minutes = Math.floor(absDiff / 60);
    const hours = Math.floor(absDiff / 3600);
    const days = Math.floor(absDiff / 86400);

    if (minutes < 60) {
        const unit = minutes === 1 ? 'minute' : 'minutes';
        return diff < 0 ? `${minutes} ${unit} ago` : `in ${minutes} ${unit}`;
    }

    if (hours < 24) {
        const unit = hours === 1 ? 'hour' : 'hours';
        return diff < 0 ? `${hours} ${unit} ago` : `in ${hours} ${unit}`;
    }

    const unit = days === 1 ? 'day' : 'days';
    return diff < 0 ? `${days} ${unit} ago` : `in ${days} ${unit}`;
}

/**
 * Check if a Unix timestamp is in the past
 * @param {number} timestamp - Unix timestamp in seconds
 * @returns {boolean} True if timestamp is before current time
 */
function is_timestamp_past(timestamp) {
    if (typeof timestamp !== 'number') {
        throw new Error('Timestamp must be a number');
    }
    const now = Math.floor(Date.now() / 1000);
    return timestamp < now;
}

/**
 * Check if a Unix timestamp is in the future
 * @param {number} timestamp - Unix timestamp in seconds
 * @returns {boolean} True if timestamp is after current time
 */
function is_timestamp_future(timestamp) {
    if (typeof timestamp !== 'number') {
        throw new Error('Timestamp must be a number');
    }
    const now = Math.floor(Date.now() / 1000);
    return timestamp >= now;
}

module.exports = { format_timestamp, parse_timestamp, format_timestamp_relative, is_timestamp_past, is_timestamp_future };
