import consumer from "./consumer"
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
$(document).on('turbolinks:load', function () {

    // js.erb 内で使用できるように変数を定義しておく
    window.micropostsClassContainer = document.getElementsByClassName('microposts-container')

    // 以下のプログラムが他のページで動作しないようにしておく
    if (micropostsClassContainer === null) {
        return
    }
    let current_user_id_int = document.getElementById("current_user_id").getAttribute("data-user_id");
    const current_user_id = current_user_id_int.toString()
    const micropostsContainer = document.getElementById('microposts-container-' + current_user_id);
    consumer.subscriptions.create("HomeChannel", {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Called when there's incoming data on the websocket for this channel
            if (data["user_id"] == current_user_id) {
                if (data["method"] == "create") {
                    // サーバー側から受け取ったHTMLを一番最後に加える
                    micropostsContainer.insertAdjacentHTML("afterbegin", data["micropost"])
                    document.getElementById('microposts_form-' + data["user_id"]).reset();
                    // document.getElementById("image-name-" + current_user_id).innerHTML = "";
                    if (document.getElementById("micropost_no_post_anything-" + data["user_id"]) != null) {
                        $("#micropost_no_post_anything").remove();
                    }
                }
                if (data["method"] == "destroy") {
                    let micropost_view = "micropost-" + data["micropost_id"]
                    let micropost_modal = "modal_destroy-" + data["micropost_id"]
                    $("#" + micropost_modal).modal('hide');
                    $("#" + micropost_view).remove();
                }
                if (data["method"] == "update") {
                    let user_name_all = document.getElementsByClassName("user_widget_user_name")
                    let user_job_all = document.getElementsByClassName("user_widget_user_job")
                    document.getElementById("user_profile_url").innerHTML = data["profiles"].url
                    document.getElementById("user_profile_location").innerHTML = data["profiles"].location
                    document.getElementById("user_profile_skill").innerHTML = data["profiles"].skills
                    document.getElementById("user_profile_notes").innerHTML = data["profiles"].notes
                    Array.prototype.forEach.call(user_name_all, function (user_name) {
                        user_name.innerHTML = data["user"].name
                    })
                    Array.prototype.forEach.call(user_job_all, function (user_job) {
                        user_job.innerHTML = data["profiles"].job
                    })
                    document.getElementById('profile_password_field-' + current_user_id).value = "";
                    document.getElementById('profile_password_confirmation_field-' + current_user_id).value = "";
                }
            }
        }
    })
});