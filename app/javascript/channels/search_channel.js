import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    let searchContainer = document.getElementById('search-container')
    //以下のプログラムが他のページで動作しないようにしておく
    if (searchContainer === null) {
        return
    }
    const tab_id = document.getElementById("search_tab_id-" + current_user_id).getAttribute("data-tab_id");
    const value = document.getElementById("search-container").getAttribute("data-value");
    consumer.subscriptions.create("SearchChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            if (data["method"] == "new") {
                if (data["tab_id"] == tab_id) {
                    let searchClassContainer = document.getElementsByClassName('search-container-' + data["current_user_id"] + "-" + data["tab_id"])
                    Array.from(searchClassContainer).forEach(function (container) {
                        container.innerHTML = data["microposts"]
                    });
                }
            }
            if (data["method"] == "add") {
                if (data["micropost"].content.includes(value)) {
                    let searchValueClassContainer = document.getElementsByClassName("search_value-" + value);
                    Array.from(searchValueClassContainer).forEach(function (container) {
                        container.insertAdjacentHTML("afterbegin", data["micropost_html"])
                    });
                }
            }
        }
    });
})
