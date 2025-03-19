package com.example.task_sync;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.widget.Toast;

/**
 * This class creates a reminder by use of AsyncTask and ALarmManager.
 */
public class ReminderAsyncTask extends AsyncTask<Long, Void, String> {
    private final Context context;

    /**
     * Message to bbe passed.
     */
    private final String reminderMessage;

    /**
     * Public contructor to the class ReminderAsyncTask
     * @param context
     * @param reminderMessage String message to be displayed by the reminder.
     */
    public ReminderAsyncTask(Context context, String reminderMessage) {
        this.context = context;
        this.reminderMessage = reminderMessage;
    }

    /**
     * Simulating a background task and scheduling time with alarm manager.
     * @param params The parameters of the task.
     * @return String is returned.
     */
    @Override
    protected String doInBackground(Long... params) {
        long timeInMillis = params[0];

        try {
            Thread.sleep(2000); // Simulating background processing
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        scheduleAlarm(timeInMillis, reminderMessage);
        return "Reminder set successfully!";
    }

//    @Override
//    protected void onPostExecute(String result) {
//        Toast.makeText(context, result, Toast.LENGTH_SHORT).show();
//    }

    /**
     * The method schedules a time for the reminder using AlarmManager.
     * @param timeInMillis
     * @param message
     */
    private void scheduleAlarm(long timeInMillis, String message) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, ReminderReceiver.class);
        intent.putExtra("reminderMessage", message);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE);
        if (alarmManager != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent);
            }else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent);
            }
        }
    }
}