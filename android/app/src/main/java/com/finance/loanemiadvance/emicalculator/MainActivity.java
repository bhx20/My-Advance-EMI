package com.finance.loanemiadvance.emicalculator;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

import java.util.Map;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "facebook_events";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Register the native ad factories
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTile",
                new NativeAdFactorySmall(getContext()));
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTileMedium",
                new NativeAdFactoryMedium(getContext()));

        // Set up MethodChannel for Facebook events
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "initialize":
                            String appId = call.argument("appId");
                            String token = call.argument("token");
                            if (appId != null && token != null) {
                                FacebookSdk.setApplicationId(appId);
                                FacebookSdk.setClientToken(token);
                                FacebookSdk.sdkInitialize(getApplicationContext());
                                AppEventsLogger.activateApp(getApplication());
                                result.success("success");
                            } else {
                                result.error("INVALID_ARGUMENT", "App ID or Token is missing", null);
                            }
                            break;
                        case "logEvent":
                            String eventName = call.argument("eventName");
                            @SuppressWarnings("unchecked")
                            Map<String, Object> parameters = call.argument("parameters");
                            if (eventName != null) {
                                AppEventsLogger logger = AppEventsLogger.newLogger(getApplicationContext());
                                Bundle bundle = new Bundle();
                                if (parameters != null) {
                                    for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                                        bundle.putString(entry.getKey(), entry.getValue().toString());
                                    }
                                }
                                logger.logEvent(eventName, bundle);
                                result.success("Meta Event logged successfully");
                            } else {
                                result.error("INVALID_ARGUMENT", "Event name is missing", null);
                            }
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    @Override
    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine);

        // Unregister the native ad factories
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile");
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium");
    }
}
