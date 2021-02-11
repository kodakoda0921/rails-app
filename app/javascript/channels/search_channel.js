import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {
    window.searchContainer = document.getElementById('search-container')
    //以下のプログラムが他のページで動作しないようにしておく
    if (searchContainer === null) {
        return
    }
    console.log("aaa")
    consumer.subscriptions.create("SearchChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
            console.log("search_channel")
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            let searchClassContainer = document.getElementsByClassName('search-container-' + data["current_user_id"])
            Array.from(searchClassContainer).forEach(function (container) {
                container.innerHTML = data["microposts"]
            });
        }
    });
})
