// Sample fixture file for workflow benchmark
// This file serves as the implementation target for the simple-feature scenario

/**
 * Format a Unix timestamp in a human-readable format
 * @param {number} timestamp - Unix timestamp in seconds
 * @param {string} timezone - Timezone identifier (e.g., 'UTC', 'America/New_York')
 * @returns {string} Formatted timestamp string
 */
function formatTimestamp(timestamp, timezone) {
    // Basic implementation placeholder
    return new Date(timestamp * 1000).toISOString();
}

module.exports = { formatTimestamp };
