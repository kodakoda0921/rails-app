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
                    // それぞれの一覧画面を表示させる箇所を定義する
                    let searchUserClassContainer = $(".search-user-container-" + data["current_user_id"] + "-" + data["tab_id"])
                    let searchClassContainer = $(".search-container-" + data["current_user_id"] + "-" + data["tab_id"])
                    searchClassContainer.empty()
                    searchUserClassContainer.empty()
                    // ボタンのidを最新のvalueのものに書き換える
                    let search_btn_id = "search-btn-" + data["tab_id"]
                    $("#search-btn-" + tab_id).attr("id", search_btn_id)
                    // <div data-value>の値を最新のvalueに書き換える
                    searchClassContainer.attr("data-value", data["value"])
                    searchUserClassContainer.attr("data-value", data["value"])
                    // 以下の箇所をサーバ側から送られてきたhtmlに置き換える
                    Array.from(searchClassContainer).forEach(function (container) {
                        container.innerHTML = data["microposts"]
                    });
                    Array.from(searchUserClassContainer).forEach(function (container) {
                        container.innerHTML = data["users"]
                    });
                }
            }
            // micropost投稿時に呼び出される検索結果へのhtml追加処理
            if (data["method"] == "new_micropost") {
                // micropostが投稿された瞬間に、検索値（value）を含む場合のみ以下の処理を行う
                if (data["micropost"].content.includes(value)) {
                    // 今回の検索で一致したため、結果を更新する
                    $("#search_hidden_field-" + tab_id).val(value);
                    $("#search_hidden_micropost_field-" + tab_id).val(data["micropost"].id.toString());
                    $("#search_hidden_user_field-" + tab_id).val(null);
                    document.getElementById("search-hidden-btn-" + tab_id).click();
                }
            }
            if (data["method"] == "new_profile") {
                // 今回の検索で一致したため、検索結果を更新する
                $("#search_hidden_field-" + tab_id).val(value);
                $("#search_hidden_user_field-" + tab_id).val(data["user"].id.toString());
                $("#search_hidden_micropost_field-" + tab_id).val(null);
                document.getElementById("search-hidden-btn-" + tab_id).click();
            }
            if (data["method"] == "add") {
                if (data["micropost"]) {
                    // それぞれの一覧画面を表示させる箇所を定義する
                    let searchClassContainer = $(".search-container-" + data["current_user_id"] + "-" + data["tab_id"])
                    Array.from(searchClassContainer).forEach(function (container) {
                        container.insertAdjacentHTML("afterbegin", data["micropost"])
                        $("#micropost_no_post_anything-" + data["current_user_id"]).empty()
                    });
                }
                if (data["users"]) {
                    let searchUserClassContainer = $(".search-user-container-" + data["current_user_id"] + "-" + data["tab_id"])
                    searchUserClassContainer.empty()
                    Array.from(searchUserClassContainer).forEach(function (container) {
                        container.innerHTML = data["users"]
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
