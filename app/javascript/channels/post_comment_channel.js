import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
document.addEventListener('turbolinks:load', () => {
// js.erb 内で使用できるように変数を定義しておく
    window.postCommentContainer = document.getElementById('post-comment-container')

// 以下のプログラムが他のページで動作しないようにしておく
    if (postCommentContainer === null) {
        return
    }
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    let html_micropost_id_int = document.getElementById("html_micropost_id").getAttribute("data-micropost_id");
    const html_micropost_id = html_micropost_id_int.toString()
    consumer.subscriptions.create("PostCommentChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            if (html_micropost_id == data["micropost_id"]) {
                // サーバー側から受け取ったHTMLを一番最初に加える
                postCommentContainer.insertAdjacentHTML("beforebegin", data["post_comment"])
                document.getElementById('post_comment_form-' + current_user_id + '-' + html_micropost_id).reset();
            }
        }
    });
})