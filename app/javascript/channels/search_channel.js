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
    const image_html = document.getElementById("current_user_img-" + current_user_id).getAttribute("data-user_image");
    consumer.subscriptions.create("SearchChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            // 検索する値（value）を取得
            const value = document.getElementById("search-container").getAttribute("data-value");
            // 検索タブが初回に開かれる時、または検索ボタンが押された時の処理
            if (data["method"] == "new") {
                if (data["tab_id"] == tab_id) {
                    let searchClassContainer = $(".search-container-" + data["current_user_id"] + "-" + data["tab_id"])
                    searchClassContainer.empty()
                    searchClassContainer.attr("data-value", data["value"])
                    Array.from(searchClassContainer).forEach(function (container) {
                        container.innerHTML = data["microposts"]
                    });

                }
            }
            // micropost投稿時に呼び出される検索結果へのhtml追加処理
            if (data["method"] == "add") {
                let image_html_src = $(image_html).attr('src')
                let micropost_jquery = $(data["micropost_html"]).find("#comment_form_current_user_image").each(function (index, value) {
                    $(this).attr('src', image_html_src);
                })
                // micropostが投稿された瞬間に、検索値（value）を含む場合のみ以下の処理を行う
                if (data["micropost"].content.includes(value)) {
                    // 今回の検索で一致したため、micropostを検索結果にaddする
                    let searchValueClassContainer = $(".search_value-" + value);
                    Array.from(searchValueClassContainer).forEach(function (container) {
                        container.prepend(micropost_jquery.parents(".post")[0])
                    });
                }
            }
            // 検索結果から自分の投稿を削除するまたは、他人の投稿が削除される時に呼び出される
            if (data["method"] == "destroy") {
                let micropost_view = "micropost-" + data["micropost_id"]
                $("#" + micropost_view).remove();
                let micropost_modal = "modal_destroy-" + data["micropost_id"]
                $("#" + micropost_modal).modal('hide');
            }
        }
    });
})
