import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {
    // js.erb 内で使用できるように変数を定義しておく
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    const micropostsContainer = document.getElementById('microposts-container')
    // 以下のプログラムが他のページで動作しないようにしておく
    if (micropostsContainer === null) {
        return
    }
    consumer.subscriptions.create("HomeChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel

            if (data["method"] == "create") {
                // 投稿者と投稿が見れる全員に対して行われる処理
                // サーバー側から受け取ったHTMLを一番上に加える
                let micropostsContainersSelf = document.getElementsByClassName('microposts-container-' + data["user_id"]);
                Array.from(micropostsContainersSelf).forEach(function (container) {
                    container.insertAdjacentHTML("afterbegin", data["micropost"])
                });
                // 「まだ投稿されていません」が表示されている場合は非表示にする
                if (document.getElementById("micropost_no_post_anything-" + data["user_id"]) != null) {
                    $("#micropost_no_post_anything-" + data["user_id"]).remove();
                }
                // 投稿者の場合のみフォームをクリアする
                if (data["post_user_id"] === current_user_id) {
                    document.getElementById('microposts_form-' + data["post_user_id"]).reset();
                    document.getElementById("image-name-" + data["post_user_id"]).innerHTML = "";
                }

            }

            if (data["method"] == "destroy") {
                let micropost_view = "micropost-" + data["micropost_id"]
                let micropost_modal = "modal_destroy-" + data["micropost_id"]
                $("#" + micropost_modal).modal('hide');
                $("#" + micropost_view).remove();
            }

            if (data["method"] == "update") {
                if (data["user"].id.toString() == current_user_id) {
                    let user_name_all = document.getElementsByClassName("user_widget_user_name-" + data["user"].id.toString())
                    let user_job_all = document.getElementsByClassName("user_widget_user_job-" + data["user"].id.toString())
                    let user_widget_images = $(".user_widget_images")
                    document.getElementById("user_profile_url-" + data["user"].id.toString()).innerHTML = data["profiles"].url
                    document.getElementById("user_profile_url-" + data["user"].id.toString()).href = data["profiles"].url
                    document.getElementById("user_profile_location-" + data["user"].id.toString()).innerHTML = data["profiles"].location
                    document.getElementById("user_profile_skill-" + data["user"].id.toString()).innerHTML = data["profiles"].skills
                    document.getElementById("user_profile_notes-" + data["user"].id.toString()).innerHTML = data["profiles"].notes
                    Array.prototype.forEach.call(user_name_all, function (user_name) {
                        user_name.innerHTML = data["user"].name
                    })
                    Array.prototype.forEach.call(user_job_all, function (user_job) {
                        user_job.innerHTML = data["profiles"].job
                    })
                    Array.prototype.forEach.call(user_widget_images, function (user_images) {
                        $(data["profile_images"]).replaceAll(user_images);
                    })
                    document.getElementById('profile_password_field-' + current_user_id).value = "";
                    document.getElementById('profile_password_confirmation_field-' + current_user_id).value = "";
                    $("#modal-user_widget-" + data["user"].id.toString()).modal('hide');
                }
            }

        }
    })
});