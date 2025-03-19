package com.example.task_sync

import android.content.pm.PackageManager
import android.os.AsyncTask
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.Manifest

class MainActivity: FlutterActivity(){
    private val CHANNEL = "reminder_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1)
            }
        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setReminder") {
                val timeInMillis = call.argument<Long>("timeInMillis") ?: return@setMethodCallHandler
                val message = call.argument<String>("message") ?: return@setMethodCallHandler

                ReminderAsyncTask(this, message).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR,timeInMillis)

                // Notify Flutter that the reminder was set
                Handler(Looper.getMainLooper()).post {
                    result.success("Reminder Set")
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
