package com.smooch.rnsmooch;

import android.app.Application;
import android.content.Intent;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.Promise;

// import java.util.HashMap;
// import java.util.Map;

import io.smooch.core.InitializationStatus;
// import io.smooch.core.Logger;
import io.smooch.core.Settings;
import io.smooch.core.Smooch;
import io.smooch.core.SmoochCallback;
// import io.smooch.core.User;

import io.smooch.features.conversationlist.ConversationListActivity;
import io.smooch.ui.ConversationActivity;

public class ReactNativeSmooch extends ReactContextBaseJavaModule {
    String LOG_TAG = "RCTSmooch";
    boolean initialized = false;

    @Override
    public String getName() {
        return "RCTSmooch";
    }

    public ReactNativeSmooch(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void initialize(String integrationId, final Promise promise) {
        Log.i(LOG_TAG, "Time to initialize");

        final Application app = (Application) getReactApplicationContext().getApplicationContext();
        final Settings settings = new Settings(integrationId);

        Smooch.init(app, settings, new SmoochCallback<InitializationStatus>() {
            @Override
            public void run(Response<InitializationStatus> response) {
                Log.i(LOG_TAG, "Inside the callback");
                if (promise != null) {
                    if (response.getError() != null) {
                        promise.reject("" + response.getStatus(), response.getError());
                        return;
                    }
                    initialized = true;
                    promise.resolve(null);
                }
            }
        });
    }

    @ReactMethod
    public void show() {
       // ConversationActivity.builder().show(getReactApplicationContext());

    //    ConversationListActivity.builder()
    //     .showCreateConversationButton(true)
    //     .withFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    //     .show(getReactApplicationContext());
    }

    @ReactMethod
    public void close() {
        // ConversationListActivity.builder().close();
    }

    @ReactMethod
    public void destroy() {
        initialized = false;
        // Smooch.destroy();
        // ConversationListActivity.builder().close();
    }

    // @ReactMethod
    // public void login(String userId, String jwt, final Promise promise) {
    //     Smooch.login(userId, jwt, new SmoochCallback() {
    //         @Override
    //         public void run(Response response) {
    //             if (promise != null) {
    //                 if (response.getError() != null) {
    //                     promise.reject("" + response.getStatus(), response.getError());
    //                     return;
    //                 }

    //                 promise.resolve(null);
    //             }
    //         }
    //     });
    // }

    // @ReactMethod
    // public void logout(final Promise promise) {
    //     Smooch.logout(new SmoochCallback() {
    //         @Override
    //         public void run(Response response) {
    //             if (response.getError() != null) {
    //                 promise.reject("" + response.getStatus(), response.getError());
    //                 return;
    //             }

    //             promise.resolve(null);
    //         }
    //     });
    // }

    // @ReactMethod
    // public void getUnreadCount(Promise promise) {
    //     int unreadCount = Smooch.getConversation().getUnreadCount();
    //     promise.resolve(unreadCount);
    // }

    // @ReactMethod
    // public void setFirstName(String firstName) {
    //     User.getCurrentUser().setFirstName(firstName);
    // }

    // @ReactMethod
    // public void setLastName(String lastName) {
    //     User.getCurrentUser().setLastName(lastName);
    // }

    // @ReactMethod
    // public void setEmail(String email) {
    //     User.getCurrentUser().setEmail(email);
    // }

    // @ReactMethod
    // public void setUserProperties(ReadableMap properties) {
    //     User.getCurrentUser().addProperties(getUserProperties(properties));
    // }

    // private Map<String, Object> getUserProperties(ReadableMap properties) {
    //     ReadableMapKeySetIterator iterator = properties.keySetIterator();
    //     Map<String, Object> userProperties = new HashMap<>();

    //     while (iterator.hasNextKey()) {
    //         String key = iterator.nextKey();
    //         ReadableType type = properties.getType(key);
    //         if (type == ReadableType.Boolean) {
    //             userProperties.put(key, properties.getBoolean(key));
    //         } else if (type == ReadableType.Number) {
    //             userProperties.put(key, properties.getDouble(key));
    //         } else if (type == ReadableType.String) {
    //             userProperties.put(key, properties.getString(key));
    //         }
    //     }

    //     return userProperties;
    // }

}
