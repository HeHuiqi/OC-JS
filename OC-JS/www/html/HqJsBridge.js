var HqJsBridge = {
    /*
    passNativeData:数据格式
    {
      "callbackId": "userInfoId",可选
       "params": params,
     }
    */
    getMobileOperatingSystem: function () {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;
        console.log('userAgent:', userAgent)

        if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
            return 'iOS';
        } else if (userAgent.match(/Android/i)) {
            return 'Android';
        } else {
            return 'unknown';
        }
    },

    callNative: function (passNativeData, callBack) {
        if (callBack) {
            const callbackId = passNativeData['callbackId']
            this.jsCallback = callBack;
            this.jsCallbacks[callbackId] = callBack
        }
        if (this.getMobileOperatingSystem() === 'iOS') {
            window.webkit.messageHandlers.HqJsBridge.postMessage(passNativeData);
        } else {
            HqAndroidJsBridge.postMessage(JSON.stringify(passNativeData));
        }
    },
    //原生主动js接口
    nativeCallJs: function (data) {
        alert("native call js");
    },
    //原生处理完回调js
    jsCallback: function (data) {},
    //原生处理完回调js，通过 callbackId 执行对应的 callback
    /*
       jsCallbacks: {
           "userInfoId": function (data) {}
        }
    */
    jsCallbacks: {},
};
window.HqJsBridge = HqJsBridge;
