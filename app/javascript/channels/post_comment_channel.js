import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {
    window.micropostsClassContainer = document.getElementById('post-comment-container')
    // 以下のプログラムが他のページで動作しないようにしておく
    if (micropostsClassContainer === null) {
        return
    }
    const postCommentContainerClass = Array.from($(".post-comment-container"))
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    const html_micropost_id_array = document.getElementsByClassName("html_micropost_id");
    consumer.subscriptions.create("PostCommentChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            // js.erb 内で使用できるように変数を定義しておく
            let postCommentContainer = document.getElementById("post-comment-container-" + data["micropost_id"])
            let postCommentCountContainer = document.getElementById("post-comment-count-container-" + data["micropost_id"])
            let html_micropost_id = Array.from(html_micropost_id_array).find(a => a.dataset.micropost_id.toString() == data["micropost_id"])
            let match_micropost_id = html_micropost_id.dataset.micropost_id.toString()
            if (match_micropost_id == data["micropost_id"]) {
                if (data["method"] == "create") {
                    // コメントを投稿した際に投稿者と投稿が見れる人全員に対して行われる処理
                    // サーバー側から受け取ったHTMLを一番最初に加える
                    postCommentContainer.insertAdjacentHTML("beforeend", data["post_comment_html"])
                    postCommentCountContainer.innerHTML = data["post_comment_count"]
                    if ($('#collapse-card-comment-' + match_micropost_id).hasClass("show") == false) {
                        $('#collapse-card-comment-' + match_micropost_id).collapse('show')
                    }
                    // コメント投稿者以外の人に対する処理
                    if (data["post_comment"].user_id.toString() != current_user_id) {
                        $("#comment_destroy_view-" + data["post_comment"].id.toString()).empty()
                    } else {
                        // コメント投稿者のみに対する処理
                        document.getElementById('post_comment_form-' + data["current_user_id"] + '-' + match_micropost_id).reset();
                    }
                }
                if (data["method"] == "destroy") {
                    postCommentCountContainer.innerHTML = data["post_comment_count"]

                    // コメント投稿者のみに対する処理（場合分け未）
                    $("#modal_comment_destroy-" + data["post_comment_id"]).modal('hide');

                    // idがhtml上から消えてしまうため、一番最後に削除を行う
                    document.getElementById("comment-" + data["post_comment_id"]).remove();

                }
            }


        }
    });
})