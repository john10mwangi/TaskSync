package com.example.task_sync;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;

/**
 * This class is the receiver for the app-specific broadcast.
 * The class will trigger a notification/reminder when brroadcast is receiveed
 */

public class ReminderReceiver extends BroadcastReceiver {

    /**
     * This method handles incoming broadcast and 
     * Extracts information from the intent.
     * @param context The Context in which the receiver is running.
     * @param intent The Intent being received.
     */
    @Override
    public void onReceive(Context context, Intent intent) {
        String message = intent.getStringExtra("reminderMessage");
        showNotification(context,message);
    }

    /**
     * This method displays a notification.
     * @param context
     * @param message This is the message passed from the app via intent.
     */
    private void showNotification(Context context, String message) {
        String channelId = "reminder_channel";
        String channelName = "Reminders";
        int notificationId = (int) (System.currentTimeMillis() % Integer.MAX_VALUE);

        NotificationManager notificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        // Create Notification Channel for Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    channelId, channelName, NotificationManager.IMPORTANCE_HIGH
            );
            notificationManager.createNotificationChannel(channel);
        }

        // Create Intent to Open App when Notification is Clicked
        Intent intent = new Intent(context, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_IMMUTABLE // Required for Android 12+
        );

        // Build Notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
                .setSmallIcon(R.mipmap.ic_launcher) // Use your own icon
                .setContentTitle("Reminder")
                .setContentText(message)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent);

        // Show Notification
        notificationManager.notify(notificationId, builder.build());
    }
}
