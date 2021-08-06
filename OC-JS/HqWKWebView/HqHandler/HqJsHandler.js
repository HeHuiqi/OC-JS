var HqJsHandler = {
    callNative: function (messageId, params, callBack) {
           var pass = {
               "messageId": messageId,
               "params": params,
           };
        if (callBack) {
            this.onNativeCallback = callBack;
        }
        window.webkit.messageHandlers.HqJsHandler.postMessage(pass);
    },
    onNativeCallback: function (data) {},
};
window.HqJsHandler = HqJsHandler;
