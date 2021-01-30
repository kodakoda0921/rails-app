$(function () {
    $('#myfile').change(function (e) {
        //ファイルオブジェクトを取得する
        const file = e.target.files[0];
        const reader = new FileReader();

        //アップロードした画像を設定する
        reader.onload = (function (file) {
            return function (e) {
                e.target.result
                $("#img1").attr("src", e.target.result);
                $("#img1").attr("title", file.name);
                $(document).Toasts('create', {
                    body: '画像のイメージプレビュー',
                    title: file.name,
                    subtitle: 'Preview',
                    image: e.target.result,
                    imageAlt: file.name,
                    autohide: true,
                    delay: 5000
                })
                let a = document.getElementById("image-name");
                a.innerHTML = file.name;
            };
        })(file);
        reader.readAsDataURL(file);
    });

});
const inputFile = document.getElementById("myfile");

function openFile() {
    document.body.onfocus = getEvent;
}

function getEvent() {
    setTimeout(() => {
        if (inputFile.value.length) {


        } else {
            $("#img1").attr("src", null);
            $("#img1").attr("title", null);
            document.getElementById("image-name").innerHTML = ""
        }
        document.body.onfocus = null;
    }, 500);
};


