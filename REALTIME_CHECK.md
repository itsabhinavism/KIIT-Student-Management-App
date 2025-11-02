# Supabase Realtime Configuration Check

## ⚠️ IMPORTANT: Enable Realtime in Supabase

For the chat messages to appear instantly, you **MUST** enable Realtime for the `chat_messages` table in Supabase.

### Steps to Enable Realtime:

1. **Go to Supabase Dashboard**

   - Navigate to your project: https://supabase.com/dashboard

2. **Open Database Settings**

   - Click on "Database" in the left sidebar
   - Click on "Replication" tab

3. **Enable Realtime for `chat_messages` table**

   - Find the table `chat_messages` in the list
   - Toggle the switch to **ON** for "Enable Realtime"
   - Click "Save" or it will auto-save

4. **Verify the Change**
   - The toggle should show as enabled (blue/green)
   - You might need to wait a few seconds for the change to propagate

### Alternative: Using SQL

If you prefer, you can also enable it via SQL:

```sql
-- Enable realtime for chat_messages table
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;
```

Run this in the SQL Editor in your Supabase Dashboard.

### Testing Realtime

After enabling:

1. Open the app on two different devices/browsers (logged in as different users)
2. Send a message from one device
3. The message should appear **instantly** on the other device without refreshing
4. Check the Flutter logs for "Realtime message received:" to confirm events are coming through

### Debugging

If messages still don't appear:

1. Check Flutter console for any errors
2. Look for "Realtime message received:" log statements
3. Verify both users are in the same chat room
4. Make sure Supabase Realtime is enabled (step 3 above)
5. Check that your RLS policies allow both users to read from `chat_messages`

## What We Fixed

### Bug 1: Messages Not Appearing Immediately

- **Problem**: The real-time subscription wasn't properly configured
- **Solution**:
  - Updated channel name to be unique per room: `room_{roomId}`
  - Added debug logging to track when messages arrive
  - Improved duplicate detection logic
  - Used `WidgetsBinding.instance.addPostFrameCallback` for scrolling

### Bug 2: Timezone Display

- **Problem**: Messages showed UTC time instead of local time
- **Solution**:
  - Updated `Message.fromJson()` to use `.toLocal()` on parsed DateTime
  - Now displays time in user's local timezone (IST for India)
  - Format: "3:30 PM" (12-hour format with AM/PM)

## Code Changes Summary

### 1. `chat_model.dart`

```dart
// Before: Used UTC time directly
createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now()

// After: Convert to local timezone
final utcTime = DateTime.tryParse(json['created_at']?.toString() ?? '');
final localTime = utcTime?.toLocal() ?? DateTime.now();
createdAt: localTime
```

### 2. `chat_screen.dart`

```dart
// Before: Channel name was generic
.channel('chat_messages:room_id=eq.${widget.roomId}')

// After: Unique channel per room with better callback
.channel('room_${widget.roomId}')
.onPostgresChanges(
  event: PostgresChangeEvent.insert,
  callback: (payload) {
    // Added logging and improved duplicate detection
    print('Realtime message received: ${payload.newRecord}');
    // ... rest of the logic
  }
)
```

### 3. `chat.ts` (Backend)

```dart
// Before: Only returned message ID
.select("id")

// After: Returns full message with sender info
.select(`
  id, content, created_at, sender_id,
  sender:users ( full_name, role )
`)
```

This ensures the WebSocket payload has all necessary data.
