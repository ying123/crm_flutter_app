package com.qipeipu.crm.newapp;

import android.content.Context;
import androidx.multidex.MultiDex;
import com.baturu.xiaobaim.BTR_IM_Util;
import com.netease.nimlib.sdk.mixpush.MixPushConfig;
import com.qipeipu.app.im.BTR_IM;
import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(newBase);
        MultiDex.install(this);
    }

    /**
     * 注意：每个进程都会创建自己的Application 然后调用onCreate() 方法，
     * 如果用户有自己的逻辑需要写在Application#onCreate()（还有Application的其他方法）中，一定要注意判断进程，不能把业务逻辑写在core进程，
     * 理论上，core进程的Application#onCreate()（还有Application的其他方法）只能做与im sdk 相关的工作
     */
    @Override
    public void onCreate() {
        super.onCreate();
        BTR_IM.messageRightBackground = R.drawable.message_right_bg;
        BTR_IM_Util.init(this, R.mipmap.close_white,R.mipmap.history_white,R.mipmap.back_white,R.menu.recent_contacts_activity_menu,buildMixPushConfig());
    }


    private static MixPushConfig buildMixPushConfig() {
        // 第三方推送配置
        MixPushConfig config = new MixPushConfig();
        // 小米推送
        config.xmAppId = "2882303761518014167";
        config.xmAppKey = "5231801458167";
        config.xmCertificateName = "crmXiaomi";


        // 华为推送
        config.hwCertificateName = "crmHuawei";


        //// 魅族推送
        //config.mzAppId = "111710";
        //config.mzAppKey = "282bdd3a37ec4f898f47c5bbbf9d2369";
        //config.mzCertificateName = "DEMO_MZ_PUSH";
        //
        //// fcm 推送，适用于海外用户，不使用fcm请不要配置
        //config.fcmCertificateName = "DEMO_FCM_PUSH";
        //
        //
        //// vivo推送
        //config.vivoCertificateName = "DEMO_VIVO_PUSH";
        //
        //// oppo推送
        //config.oppoAppId = "3477155";
        //config.oppoAppKey = "6clw0ue1oZ8cCOogKg488o0os";
        //config.oppoAppSercet = "e163705Bd018bABb3e2362C440A94673";
        //config.oppoCertificateName = "DEMO_OPPO_PUSH";
        return config;
    }
}
