import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {
    // js.erb 内で使用できるように変数を定義しておく
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    const flashContainer = document.getElementById("flash-container-" + current_user_id)
    //const flashClassContainer = document.getElementsByClassName("flash-container-" + current_user_id)
    // 以下のプログラムが他のページで動作しないようにしておく
    if (flashContainer === null) {
        return
    }
    consumer.subscriptions.create("FlashChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received: function (data) {
            // Called when there's incoming data on the websocket for this channel
            if (data["user_id"] == current_user_id) {
                // フラッシュメッセージを表示する
                data["flash"].forEach(function (flash) {
                    $(document).ready(function () {
                        let now = new Date();
                        $(document).Toasts('create', {
                            class: 'bg-' + flash[0],
                            title: flash[0],
                            subtitle: now.getHours() + ':' + now.getMinutes(),
                            body: flash[1],
                            autohide: true,
                            delay: 5000
                        })
                    });
                })
                data["flash"] = null;
            }
        }
    });
});
