import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
document.addEventListener('turbolinks:load', () => {

    // js.erb 内で使用できるように変数を定義しておく
    window.flashContainer = document.getElementById('flash-container')

    // 以下のプログラムが他のページで動作しないようにしておく
    if (flashContainer === null) {
        return
    }
    consumer.subscriptions.create("FlashChannel", {
        user_id: $('#current_user_id').data('user_id'),
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            // サーバー側から受け取ったHTMLを一番最後に加える
            flashContainer.innerHTML = data["flash"]

            $(document).ready(function () {
                $('.toast').toast({delay: 5000}).toast('show');
                document.getElementById('microposts_form').reset();
                document.getElementById("image-name").innerHTML = "";
            });

        }
    });
});
