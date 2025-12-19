package com.example.kinetic_template

import android.app.Application
import com.moengage.core.DataCenter
import com.moengage.core.MoEngage

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize MoEngage
        val moEngage = MoEngage.Builder(this, "YOUR_MOENGAGE_APP_ID", DataCenter.DATA_CENTER_1)
            .build()
        MoEngage.initialiseDefaultInstance(moEngage)
    }
}

