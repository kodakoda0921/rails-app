import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
document.addEventListener('turbolinks:load', () => {
    const postCommentContainerClass = document.getElementsByClassName('post-comment-container')
// 以下のプログラムが他のページで動作しないようにしておく
    if (postCommentContainerClass === null) {
        return
    }
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
                // サーバー側から受け取ったHTMLを一番最初に加える

                postCommentContainer.insertAdjacentHTML("beforeend", data["post_comment"])
                postCommentCountContainer.innerHTML = data["post_comment_count"]
                document.getElementById('post_comment_form-' + current_user_id + '-' + match_micropost_id).reset();
                if ($('#collapse-card-comment-' + match_micropost_id).hasClass("show") == false) {
                    $('#collapse-card-comment-' + match_micropost_id).collapse('show')
                }

                // if (a == true) {
                //     $('#collapse-card-comment-' + match_micropost_id).click()
                // }
            }
        }
    });
})