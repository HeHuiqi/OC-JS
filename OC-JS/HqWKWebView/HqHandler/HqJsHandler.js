var HqJsHandler = {
    callNative: function (messageId, params, callBack) {
           var pass = {
               "messageId": messageId,
               "params": params,
           };
        if (callBack) {
            this.jsCallback = callBack;
        }
        window.webkit.messageHandlers.HqJsHandler.postMessage(pass);
    },
    jsCallback: function (data) {},
};
window.HqJsHandler = HqJsHandler;
